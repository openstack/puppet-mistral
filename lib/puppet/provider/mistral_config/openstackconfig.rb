Puppet::Type.type(:mistral_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/mistral/mistral.conf'
  end

end
