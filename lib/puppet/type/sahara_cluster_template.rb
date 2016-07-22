Puppet::Type.newtype(:sahara_cluster_template) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of this cluster template.'
    newvalues(/\S+/)
  end

  newproperty(:id) do
    desc 'The unique Id of the cluster template.'
    validate do |v|
      raise ArgumentError, 'This is a read only property'
    end
  end

  newproperty(:description) do
    desc 'The description of this cluster template.'
  end

  newproperty(:node_groups, :array_matching => :all) do
    desc 'List of the node groups(names or IDs) and numbers of instances for each one of them.'
    defaultto { fail 'Property \'node_groups\' is required.' }
    validate do |group|
      args = group.split(':')
      raise ArgumentError, 'You should specify node_groups in format <node_group_name:count> format' unless args.count == 2
      raise ArgumentError, 'Node group count should be an integer' unless args[1].to_i.to_s == args[1]
    end

    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:auto_config) do
    desc 'If enabled, instances of the cluster will be automatically configured'
    newvalues(/(t|T)rue/, /(f|F)alse/, true, false)
    defaultto(true)
    munge do |value|
      value.to_s.downcase.to_sym
    end
  end

  validate do
    if self[:node_groups].empty?
      raise ArgumentError, 'You should specify at least one node group.'
    end
  end

  autorequire(:service) do
    [ 'sahara-api', 'sahara-all', 'sahara-engine' ]
  end

  autorequire(:sahara_node_group_template) do
    templates = []
    self[:node_groups].each do |template|
      templates.push(template.split(':')[0])
    end
    templates
  end
end
