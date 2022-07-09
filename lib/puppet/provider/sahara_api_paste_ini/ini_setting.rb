Puppet::Type.type(:sahara_api_paste_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/sahara/api-paste.ini'
  end

end
