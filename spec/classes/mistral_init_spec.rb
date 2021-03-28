require 'spec_helper'

describe 'mistral' do
  let :req_params do
    {
      :purge_config        => false,
    }
  end

  let :pre_condition do
    "class { 'mistral::keystone::authtoken':
       password => 'foo',
     }"
  end

  shared_examples 'mistral' do
    context 'with only required params' do
      let :params do
        req_params
      end

      it { should contain_class('mistral::params') }

      it 'passes purge to resource' do
        should contain_resources('mistral_config').with({
          :purge => false
        })
      end

      it 'should contain default config' do
        should contain_mistral_config('DEFAULT/control_exchange').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('DEFAULT/rpc_response_timeout').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('DEFAULT/report_interval').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('DEFAULT/service_down_time').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('DEFAULT/transport_url').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('action_heartbeat/max_missed_heartbeats').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('action_heartbeat/check_interval').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('action_heartbeat/first_heartbeat_timeout').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_notifications/transport_url').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_notifications/driver').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_notifications/topics').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value('<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_rabbit/kombu_reconnect_delay').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('oslo_messaging_rabbit/kombu_failover_strategy').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('coordination/backend_url').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('coordination/heartbeat_interval').with(:value => '<SERVICE DEFAULT>')
        should contain_mistral_config('keystone_authtoken/www_authenticate_uri').with(
         :value => 'http://localhost:5000'
        )
        should contain_mistral_config('keystone_authtoken/auth_url').with(
         :value => 'http://localhost:5000'
        )
        should contain_mistral_config('keystone_authtoken/project_name').with(
         :value => 'services'
        )
        should contain_mistral_config('keystone_authtoken/username').with(
         :value => 'mistral'
        )
        should contain_mistral_config('keystone_authtoken/password').with(
         :value => 'foo'
        )
        should contain_mistral_config('openstack_actions/os_actions_endpoint_type').with(
          :value => '<SERVICE DEFAULT>'
        )
      end
    end

    context 'with enable ha queues' do
      let :params do
        req_params.merge({'rabbit_ha_queues' => true})
      end

      it 'should contain rabbit_ha_queues' do
        should contain_mistral_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => true)
      end
    end

    context 'with rabbit default transport url configured' do
      let :params do
        req_params.merge({'default_transport_url' => 'rabbit://user:pass@host:1234/virt' })
      end

      it 'should contain transport_url' do
        should contain_mistral_config('DEFAULT/transport_url').with(:value => 'rabbit://user:pass@host:1234/virt')
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
        should contain_mistral_config('oslo_messaging_notifications/transport_url').with(:value => 'rabbit://user:pass@host:1234/virt')
        should contain_mistral_config('oslo_messaging_notifications/driver').with(:value => 'messagingv1')
        should contain_mistral_config('oslo_messaging_notifications/topics').with(:value => 'openstack')
      end
    end

    context 'with rabbitmq heartbeats' do
      let :params do
        req_params.merge({
	  'rabbit_heartbeat_timeout_threshold' => '60',
          'rabbit_heartbeat_rate' => '10',
          'rabbit_heartbeat_in_pthread' => true 
	})
      end

      it 'should contain heartbeat config' do
        should contain_mistral_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60')
        should contain_mistral_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10')
        should contain_mistral_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value(true)
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

      it { should contain_oslo__messaging__rabbit('mistral_config').with(
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
          :rabbit_use_ssl     => true,
        })
      end

      it { should contain_oslo__messaging__rabbit('mistral_config').with(
        :rabbit_use_ssl => true,
      )}
    end

    context 'with SSL disabled' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => false,
        })
      end

      it { should contain_oslo__messaging__rabbit('mistral_config').with(
        :rabbit_use_ssl => false,
      )}
    end

    context 'with amqp_durable_queues disabled' do
      let :params do
        req_params
      end

      it { should contain_mistral_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
    end

    context 'with amqp_durable_queues enabled' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => true,
        })
      end

      it { should contain_mistral_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }
    end

    context 'with coordination' do
      let :params do
        req_params.merge({
          :coordination_backend_url        => 'redis://127.0.0.1',
          :coordination_heartbeat_interval => '10.0',
        })
      end

      it 'should contain coordination config' do
        should contain_mistral_config('coordination/backend_url').with(:value => 'redis://127.0.0.1')
        should contain_mistral_config('coordination/heartbeat_interval').with(:value => '10.0')
      end
    end

    context 'with os_actions_keystone_endpoint overridden' do
      let :params do
        req_params.merge({
          :os_actions_endpoint_type => 'internal',
        })
      end

      it { should contain_mistral_config('openstack_actions/os_actions_endpoint_type').with_value('internal') }
    end

    context 'with heartbeats parameters overridden' do
      let :params do
        req_params.merge({
          :max_missed_heartbeats   => '30',
          :check_interval          => '40',
          :first_heartbeat_timeout => '7200',
        })
      end

      it { should contain_mistral_config('action_heartbeat/max_missed_heartbeats').with_value('30') }
      it { should contain_mistral_config('action_heartbeat/check_interval').with_value('40') }
      it { should contain_mistral_config('action_heartbeat/first_heartbeat_timeout').with_value('7200') }
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
