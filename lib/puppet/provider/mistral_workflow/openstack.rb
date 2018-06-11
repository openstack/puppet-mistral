require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/mistral')

Puppet::Type.type(:mistral_workflow).provide(
  :openstack,
  :parent => Puppet::Provider::Mistral
) do
  desc <<-EOT
    Mistral provider to manage workflow type
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  mk_resource_methods

  def create
    properties = []
    properties << (@resource[:is_public] == :true ? '--public' : '--private')
    properties << @resource[:definition_file]

    self.class.request('workflow', 'create', properties)
    @property_hash[:ensure] = :present
    @property_hash[:definition_file] = resource[:definition_file]
    @property_hash[:is_public] = resource[:is_public]
    @property_hash[:name] = name
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('workflow', 'delete', @resource[:name])
    @property_hash.clear
  end

  def update
    # Update the workflow if it exists, otherwise create it
    if exists?
      properties = []
      if @resource[:is_public] == :true
        properties << '--public'
      end
      properties << @resource[:definition_file]

      self.class.request('workflow', 'update', properties)
      @property_hash[:ensure] = :present
      @property_hash[:definition_file] = resource[:definition_file]
      @property_hash[:is_public] = resource[:is_public]
      @property_hash[:name] = name
    else
      create
    end
  end

  def self.instances
    list = request('workflow', 'list')
    list.collect do |wf|
      attrs = request('workflow', 'show', wf[:id])
      new({
        :ensure => :present,
        :id     => wf[:id],
        :name   => wf[:name],
        :is_public => (attrs[:scope] == "public")
      })
    end
  end

  def self.prefetch(resources)
    workflows = instances
    resources.keys.each do |name|
      if provider = workflows.find{ |wf| wf.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    if @property_flush
      opts = [@resource[:name]]

      (opts << '--public') if @property_flush[:is_public] == :true
      (opts << '--private') if @property_flush[:is_public] == :false
      opts << @property_flush[:definition_file]

      self.class.request('workflow', 'update', opts)
      @property_flush.clear
    end
  end

end
