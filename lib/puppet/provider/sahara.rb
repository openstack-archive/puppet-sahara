require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'

class Puppet::Provider::Sahara < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

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
    @flavors_hash = nil
    @network_hash = nil
  end
end
