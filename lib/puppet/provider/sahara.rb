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
    @credentials.username = sahara_credentials['admin_user']
    @credentials.password = sahara_credentials['admin_password']
    @credentials.project_name = sahara_credentials['admin_tenant_name']
    @credentials.auth_url = auth_endpoint
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
    auth_keys = ['auth_uri', 'admin_tenant_name', 'admin_user',
                 'admin_password']
    conf = sahara_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]
      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
            "required sections. Can not to authenticate Sahara.")
    end
  end

  def self.get_auth_endpoint
    q = sahara_credentials
    "#{q['auth_uri']}"
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
