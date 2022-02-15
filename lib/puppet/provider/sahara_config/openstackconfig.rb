Puppet::Type.type(:sahara_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/sahara/sahara.conf'
  end

end
