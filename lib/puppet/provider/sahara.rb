require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'

class Puppet::Provider::Sahara < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

  def self.conf_filename
    '/etc/sahara/sahara.conf'
  end

  def self.sahara_conf
    return @sahara_conf if @sahara_conf
    @sahara_conf = Puppet::Util::IniConfig::File.new
    @sahara_conf.read(conf_filename)
    @sahara_conf
  end

  def self.request(service, action, properties=nil)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError, Puppet::Error::OpenstackUnauthorizedError => error
      sahara_request(service, action, error, properties)
    end
  end

  def self.sahara_request(service, action, error, properties=nil)
    properties ||= []
    @credentials.username = sahara_credentials['username']
    @credentials.password = sahara_credentials['password']
    @credentials.project_name = sahara_credentials['project_name']
    @credentials.auth_url = auth_endpoint
    if sahara_credentials['region_name']
      @credentials.region_name = sahara_credentials['region_name']
    end
    if @credentials.version == '3'
      @credentials.user_domain_name = sahara_credentials['user_domain_name']
      @credentials.project_domain_name = sahara_credentials['project_domain_name']
    end
    raise error unless @credentials.set?
    Puppet::Provider::Openstack.request(service, action, properties, @credentials)
  end

  def self.sahara_credentials
    @sahara_credentials ||= get_sahara_credentials
  end

  def sahara_credentials
    self.class.sahara_credentials
  end

  def self.get_sahara_credentials
    auth_keys = ['auth_url', 'project_name', 'username',
                 'password']
    conf = sahara_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]
      if conf['project_domain_name']
        creds['project_domain_name'] = conf['project_domain_name']
      else
        creds['project_domain_name'] = 'Default'
      end
      if conf['user_domain_name']
        creds['user_domain_name'] = conf['user_domain_name']
      else
        creds['user_domain_name'] = 'Default'
      end
      if conf['keystone_authtoken']['region_name']
        creds['region_name'] = conf['keystone_authtoken']['region_name']
      end
      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
            "required sections. Can not to authenticate Sahara.")
    end
  end

  def self.get_auth_endpoint
    q = sahara_credentials
    "#{q['auth_url']}"
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  def self.flavors_list
    unless @flavors_hash
      list = request('flavor', 'list')
      @flavors_hash = Hash[list.collect { |flavor| [ flavor[:id], flavor[:name] ] } ]
    end
    @flavors_hash
  end

  def self.network_list
    unless @network_hash
      list = request('network', 'list')
      @network_hash = Hash[list.collect { |network| [ network[:id], network[:name] ] } ]
    end
    @network_hash
  end

  def self.reset
    @sahara_conf = nil
    @sahara_credentials = nil
  end
end
