require 'puppet/provider/sahara'

Puppet::Type.type(:sahara_node_group_template).provide(
  :openstack,
  :parent => Puppet::Provider::Sahara
) do

  desc 'Provider for managing Sahara node group templates.'

  @credentials = Puppet::Provider::Openstack::CredentialsV2_0.new

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def create
    options = []
    options << '--name' << @resource[:name]
    options << '--plugin' << @resource[:plugin]
    options << '--plugin-version' << @resource[:plugin_version]
    options << '--description' << @resource[:description] if @resource[:description]
    options << '--auto-security-group' if @resource[:auto_security_group]

    if @resource[:floating_ip_pool]
      # we need only <id> of network
      network_id = self.class.request('network', 'show', @resource[:floating_ip_pool])[:id]
      options << '--floating-ip-pool' << network_id
    end

    options << '--flavor' << @resource[:flavor]
    options << '--processes' << @resource[:node_processes]
    options << '--security-groups' << @resource[:security_groups] unless @resource[:security_groups].empty?
    self.class.request('dataprocessing node group template', 'create', options)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('dataprocessing node group template', 'delete', id)
    @property_hash.clear
  end

  def plugin=(value)
    fail('Property \'plugin\' can\'t be updated')
  end

  def plugin_version=(value)
    fail('Property \'version\' can\'t be updated')
  end

  def flavor
    # we can set flavor as in <id> format as in <name> format
    flavors = self.class.flavors_list
    if flavors[@property_hash[:flavor]] == @resource[:flavor] or
       @property_hash[:flavor] == @resource[:flavor]
      @resource[:flavor]
    else
      @property_hash[:flavor]
    end
  end

  def floating_ip_pool
    # this should be only <id>, but we can accept
    # name of network as input, because user may know
    # network name, but not a network <id>
    networks = self.class.network_list
    if networks[@property_hash[:floating_ip_pool]] == @resource[:floating_ip_pool] or
       @property_hash[:floating_ip_pool] == @resource[:floating_ip_pool]
      @resource[:floating_ip_pool]
    else
      @property_hash[:floating_ip_pool]
    end
  end

  def flavor=(value)
    @property_flush[:flavor] = value
  end

  def node_processes=(value)
    @property_flush[:node_processes] = value
  end

  def floating_ip_pool=(value)
    @property_flush[:floating_ip_pool] = value
  end

  def auto_security_group=(value)
    @property_flush[:auto_security_group] = value
  end

  def description=(value)
    @property_flush[:description] = value
  end

  def security_groups=(value)
    @property_flush[:security_groups] = value
  end

  def self.instances
    list = request('dataprocessing node group template', 'list')
    list.collect do |template|
      template_info = request('dataprocessing node group template', 'show', template[:id])
      new({
        :name                => template_info[:name],
        :ensure              => :present,
        :id                  => template_info[:id],
        :plugin              => template_info[:plugin_name],
        :plugin_version      => template_info[:plugin_version],
        :flavor              => template_info[:flavor_id],
        :description         => template_info[:description],
        :node_processes      => template_info[:node_processes].split(',').map(&:strip),
        :auto_security_group => template_info[:auto_security_group].downcase.to_sym,
        :floating_ip_pool    => template_info[:floating_ip_pool],
        :security_groups     => string2list(template_info[:security_groups]),
      })
    end
  end

  def self.string2list(input)
    return [] if input.eql? "None"
    return input[1..-2].split(",").map { |x| x.match(/'(.*?)'/)[1] }
  end

  def self.prefetch(resources)
    node_group_templates = instances
    resources.keys.each do |name|
      if provider = node_group_templates.find{ |template| template.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    options = []
    if @property_flush && !@property_flush.empty?
      options << @property_hash[:id]
      options << '--auto-security-group-enable' if @property_flush[:auto_security_group] == :true
      options << '--auto-security-group-disable' if @property_flush[:auto_security_group] == :false
      options << '--flavor' << @property_flush[:flavor] if @property_flush[:flavor]
      options << '--description' << @property_flush[:description] if @property_flush[:description]
      options << '--floating-ip-pool' << @property_flush[:floating_ip_pool] if @property_flush[:floating_ip_pool]
      options << '--processes' << @property_flush[:node_processes] if @property_flush[:node_processes]
      if @property_flush[:security_groups]
        # OSC has not ability to unset security groups at all for sahara template
        options << '--security-groups' << @property_flush[:security_groups] unless @property_flush[:security_groups].empty?
      end
      self.class.request('dataprocessing node group template', 'update', options)
      @property_flush.clear
    end
  end
end
