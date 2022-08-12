require 'spec_helper'

describe 'mistral' do
  let :req_params do
    {
      :purge_config        => false,
    }
  end

  shared_examples 'mistral' do
    context 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('mistral::params') }

      it 'passes purge to resource' do
        is_expected.to contain_resources('mistral_config').with({
          :purge => false
        })
      end

      it 'should contain default config' do
        is_expected.to contain_mistral_config('DEFAULT/report_interval').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('DEFAULT/service_down_time').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('action_heartbeat/max_missed_heartbeats').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('action_heartbeat/check_interval').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('action_heartbeat/first_heartbeat_timeout').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_oslo__messaging__default('mistral_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__notifications('mistral_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
          :rabbit_use_ssl              => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold => '<SERVICE DEFAULT>',
          :heartbeat_rate              => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread        => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay       => '<SERVICE DEFAULT>',
          :kombu_failover_strategy     => '<SERVICE DEFAULT>',
          :amqp_durable_queues         => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs          => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile          => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile           => '<SERVICE DEFAULT>',
          :kombu_ssl_version           => '<SERVICE DEFAULT>',
          :rabbit_ha_queues            => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_mistral_config('openstack_actions/os_actions_endpoint_type').with(
          :value => '<SERVICE DEFAULT>'
        )
      end
    end

    context 'with enable ha queues' do
      let :params do
        req_params.merge({'rabbit_ha_queues' => true})
      end

      it 'should contain rabbit_ha_queues' do
        is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
          :rabbit_ha_queues => true
        )
      end
    end

    context 'with rabbit default transport url configured' do
      let :params do
        req_params.merge({'default_transport_url' => 'rabbit://user:pass@host:1234/virt' })
      end

      it 'should contain transport_url' do
        is_expected.to contain_oslo__messaging__default('mistral_config').with(
          :transport_url => 'rabbit://user:pass@host:1234/virt',
        )
      end
    end

    context 'with rabbit notification transport url configured' do
      let :params do
        req_params.merge({
          :notification_transport_url => 'rabbit://user:pass@host:1234/virt',
          :notification_topics        => 'openstack',
          :notification_driver        => 'messagingv1',
        })
      end

      it 'should contain transport_url' do
        is_expected.to contain_oslo__messaging__notifications('mistral_config').with(
          :transport_url => 'rabbit://user:pass@host:1234/virt',
          :driver        => 'messagingv1',
          :topics        => 'openstack',
        )
      end
    end

    context 'with rabbitmq heartbeats' do
      let :params do
        req_params.merge({
	      :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true 
        })
      end

      it 'should contain heartbeat config' do
        is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
          :heartbeat_timeout_threshold => '60',
          :heartbeat_rate              => '10',
          :heartbeat_in_pthread        => true,
        )
      end
    end

    context 'with SSL enabled with kombu' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
          :kombu_ssl_certfile => '/path/to/ssl/cert/file',
          :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
          :kombu_ssl_version  => 'TLSv1'
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
        :rabbit_use_ssl     => true,
        :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
        :kombu_ssl_certfile => '/path/to/ssl/cert/file',
        :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
        :kombu_ssl_version  => 'TLSv1'
      )}
    end

    context 'with SSL enabled without kombu' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl => true,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
        :rabbit_use_ssl => true,
      )}
    end

    context 'with SSL disabled' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl => false,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
        :rabbit_use_ssl => false,
      )}
    end

    context 'with amqp_durable_queues enabled' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => true,
        })
      end
      it { is_expected.to contain_oslo__messaging__rabbit('mistral_config').with(
        :amqp_durable_queues => true
      )}
    end

    context 'with os_actions_keystone_endpoint overridden' do
      let :params do
        req_params.merge({
          :os_actions_endpoint_type => 'internal',
        })
      end

      it { is_expected.to contain_mistral_config('openstack_actions/os_actions_endpoint_type').with_value('internal') }
    end

    context 'with heartbeats parameters overridden' do
      let :params do
        req_params.merge({
          :max_missed_heartbeats   => '30',
          :check_interval          => '40',
          :first_heartbeat_timeout => '7200',
        })
      end

      it { is_expected.to contain_mistral_config('action_heartbeat/max_missed_heartbeats').with_value('30') }
      it { is_expected.to contain_mistral_config('action_heartbeat/check_interval').with_value('40') }
      it { is_expected.to contain_mistral_config('action_heartbeat/first_heartbeat_timeout').with_value('7200') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'mistral'
    end
  end
end
