require 'puppet/provider/sahara'

Puppet::Type.type(:sahara_cluster_template).provide(
  :openstack,
  :parent => Puppet::Provider::Sahara
) do

  desc 'Provider for managing Sahara cluster templates.'

  @credentials = Puppet::Provider::Openstack::CredentialsV2_0.new

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def create
    options = []
    options << '--name' << @resource[:name]
    options << '--node-groups' << @resource[:node_groups]
    options << '--autoconfig' if @resource[:auto_config]
    options << '--description' << @resource[:description] if @resource[:description]
    self.class.request('dataprocessing cluster template', 'create', options)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('dataprocessing cluster template', 'delete', id)
    @property_hash.clear
  end

  def node_groups=(value)
    @property_flush[:node_groups] = value
  end

  def auto_config=(value)
    @property_flush[:auto_config] = value
  end

  def description=(value)
    @property_flush[:description] = value
  end

  def self.instances
    list = request('dataprocessing cluster template', 'list')
    list.collect do |template|
      template_info = request('dataprocessing cluster template', 'show', template[:id])
      new({
        :name        => template_info[:name],
        :ensure      => :present,
        :id          => template_info[:id],
        :node_groups => template_info[:node_groups].split(',').map(&:strip),
        :auto_config => template_info[:use_autoconfig].downcase.to_sym,
      })
    end
  end

  def self.prefetch(resources)
    cluster_templates = instances
    resources.keys.each do |name|
      if provider = cluster_templates.find{ |template| template.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    options = []
    if @property_flush && !@property_flush.empty?
      options << @property_hash[:id]
      options << '--autoconfig-enable' if @property_flush[:auto_config] == :true
      options << '--autoconfig-disable' if @property_flush[:auto_config] == :false
      options << '--node-groups' << @property_flush[:node_groups] if @property_flush[:node_groups]
      options << '--description' << @property_flush[:description] if @property_flush[:description]
      self.class.request('dataprocessing cluster template', 'update', options)
      @property_flush.clear
    end
  end
end
