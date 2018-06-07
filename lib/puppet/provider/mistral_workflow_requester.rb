require 'csv'
require 'puppet'
require 'timeout'

class Puppet::Provider::MistralWorkflowRequester < Puppet::Provider::Openstack
  # This class only overrides the request method of the Openstack provider
  # because Mistral behaves differently when creating workflows.
  # The mistral client allows the creation of multiple workflows with a single
  # definition file so the creation call returns a list of workflows instead of
  # a single value.
  # Consequently the shell output format is not available and the csv formatter
  # must be used instead.

  # Returns an array of hashes, where the keys are the downcased CSV headers
  # with underscores instead of spaces
  #
  # @param options [Hash] Other options
  # @options :no_retry_exception_msgs [Array<Regexp>,Regexp] exception without retries
  def self.request(service, action, properties, credentials=nil, options={})
    env = credentials ? credentials.to_env : {}

    # We only need to override the create action
    if action != 'create'
      return super
    end

    Puppet::Util.withenv(env) do
      rv = nil
      begin
        # shell output is:
        # ID,Name,Description,Enabled
        response = openstack(service, action, '--quiet', '--format', 'csv', properties)
        response = parse_csv(response)
        keys = response.delete_at(0)

        if response.collect.length > 1
          definition_file = properties[-1]
          Puppet.warning("#{definition_file} creates more than one workflow, only the first one will be returned after the request.")
        end
        rv = response.collect do |line|
          hash = {}
          keys.each_index do |index|
            key = keys[index].downcase.gsub(/ /, '_').to_sym
            hash[key] = line[index]
          end
          hash
        end
      rescue Puppet::ExecutionFailure => exception
        raise Puppet::Error::OpenstackUnauthorizedError, 'Could not authenticate' if exception.message =~ /HTTP 40[13]/
        raise
      end
    end
    return rv
  end

  private

  def self.parse_csv(text)
    # Ignore warnings - assume legitimate output starts with a double quoted
    # string.  Errors will be caught and raised prior to this
    text = text.split("\n").drop_while { |line| line !~ /^\".*\"/ }.join("\n")
    return CSV.parse(text + "\n")
  end
end
