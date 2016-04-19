Puppet::Type.newtype(:sahara_node_group_template) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of this node group template.'
    newvalues(/\S+/)
  end

  newproperty(:id) do
    desc 'The unique Id of the node group template.'
    validate do |v|
      raise ArgumentError, 'This is a read only property'
    end
  end

  newproperty(:plugin) do
    desc 'The plugin name for current template'
    defaultto { fail 'Property \'plugin\' is required.' }
    newvalues(/\S+/)
  end

  newproperty(:description) do
    desc 'The description of this node group template.'
  end

  newproperty(:plugin_version) do
    desc 'The version of plugin for this template'
    defaultto { fail 'Property \'plugin_version\' is required.' }
    newvalues(/\S+/)
  end

  newproperty(:node_processes, :array_matching => :all) do
    desc 'List of the processes that will be launched on each instance'
    defaultto { fail 'Property \'node_processes\' is required.' }

    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:flavor) do
    desc 'The id or name of the flavor assigned to this node group template'
    defaultto { fail 'Property \'flavor\' is required.' }
    newvalues(/\S+/)
  end

  newproperty(:floating_ip_pool) do
    desc 'The id or name of floating ip pool'
    newvalues(/\S+/)
  end

  newproperty(:auto_security_group) do
    desc 'Indicates if an additional security group should be created for the node group'
    newvalues(/(t|T)rue/, /(f|F)alse/, true, false)
    defaultto(true)
    munge do |value|
      value.to_s.downcase.to_sym
    end
  end

  newproperty(:security_groups, :array_matching => :all) do
    desc 'List of the processes that will be launched on each instance'
    defaultto([])

    def insync?(is)
      is.sort == should.sort
    end
  end

  validate do
    if self[:node_processes].empty?
      raise ArgumentError, 'You should specify at least one node process.'
    end
  end

  autorequire(:service) do
    [ 'sahara-api', 'sahara-all', 'sahara-engine' ]
  end

end
