Puppet::Type.newtype(:mistral_workflow) do
  desc <<-EOT
    This allows manifests to declare a workflow to be created or removed
    in Mistral.

    mistral_workflow { "my_workflow":
      ensure => present,
      definition_file => "/home/workflows/my_workflow.yaml",
      is_public => yes,
    }

    Known problems / limitations:
      * When creating a worflow, the name supplied is not used because mistral
        will name the workflow according to its definition.
      * You MUST provide the definition_file if you want to change any property
        because that will cause the provider to run the 'workflow update'
        command.
      * DO NOT put multiple workflows in the definition_file. Although the
        mistral client allows it, the provider does not support it.
      * Ensure this is run on the same server as the mistral-api service.

  EOT

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:latest) do
      provider.update
    end
  end

  newparam(:name, :namevar => true) do
    desc 'The name of the workflow'
    newvalues(/.*/)
  end

  newproperty(:id) do
    desc 'The unique id of the workflow'
    newvalues(/[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}/)
  end

  newparam(:definition_file) do
    desc "The location of the file defining the workflow"
    newvalues(/.*/)
  end

  newparam(:is_public, :boolean => true) do
    desc 'Whether the workflow is public or not. Default to `true`'
    newvalues(:true, :false)
    defaultto true
  end

  # Require the Mistral API service to be running
  autorequire(:anchor) do
    ['mistral::service::end']
  end
end
