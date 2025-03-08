# == Class: mistral
#
# Mistral base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
# [*os_actions_endpoint_type*]
#   (optional) Type of endpoint in identity service catalog to use for
#   communication with OpenStack services
#   Defaults to $facts['os_service_default']
#
# [*default_transport_url*]
#   (optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $facts['os_service_default']
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all).
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_quorum_queue*]
#   (Optional) Use quorum queues for transients queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_length*]
#   (Optional) Limit the number of messages in the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_bytes*]
#   (Optional) Limit the number of memory bytes used by the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $facts['os_service_default']
#
# [*report_interval*]
#  (optional) Interval, in seconds, between nodes reporting state to
#  datastore (integer value).
#  Defaults to $facts['os_service_default']
#
# [*service_down_time*]
#  (optional) Maximum time since last check-in for a service to be
#  considered up (integer value).
#  Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional)Use durable queues in amqp.
#   Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the mistral config.
#   Defaults to false.
#
# [*sync_db*]
#   (Optional) Enable dbsync
#   Defaults to true.
#
# [*max_missed_heartbeats*]
#   (Optional) The maximum amount of missed heartbeats to be allowed.
#   If set to 0 then this feature is disabled. See check_interval for more
#   details.
#   Defaults to $facts['os_service_default']
#
# [*check_interval*]
#   (Optional) How often (in seconds) action executions are checked.
#   For example when check_interval is 10, check action
#   executions every 10 seconds. When the checker runs it will
#   transit all running action executions to error if the last
#   heartbeat received is older than 10 * max_missed_heartbeats
#   seconds. If set to 0 then this feature is disabled.
#   Defaults to $facts['os_service_default']
#
# [*first_heartbeat_timeout*]
#   (Optional) The first heartbeat is handled differently, to provide a
#   grace period in case there is no available executor to handle
#   the action execution. For example when first_heartbeat_timeout = 3600, wait
#   3600 seconds before closing the action executions that never received a
#   heartbeat.
#   Defaults to $facts['os_service_default']
#
class mistral(
  $package_ensure                     = 'present',
  $os_actions_endpoint_type           = $facts['os_service_default'],
  $control_exchange                   = $facts['os_service_default'],
  $rpc_response_timeout               = $facts['os_service_default'],
  $default_transport_url              = $facts['os_service_default'],
  $notification_transport_url         = $facts['os_service_default'],
  $notification_driver                = $facts['os_service_default'],
  $notification_topics                = $facts['os_service_default'],
  $rabbit_ha_queues                   = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold = $facts['os_service_default'],
  $rabbit_heartbeat_rate              = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread        = $facts['os_service_default'],
  $rabbit_quorum_queue                = $facts['os_service_default'],
  $rabbit_transient_quorum_queue      = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit       = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length    = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes     = $facts['os_service_default'],
  $rabbit_use_ssl                     = $facts['os_service_default'],
  $service_down_time                  = $facts['os_service_default'],
  $report_interval                    = $facts['os_service_default'],
  $kombu_failover_strategy            = $facts['os_service_default'],
  $kombu_ssl_ca_certs                 = $facts['os_service_default'],
  $kombu_ssl_certfile                 = $facts['os_service_default'],
  $kombu_ssl_keyfile                  = $facts['os_service_default'],
  $kombu_ssl_version                  = $facts['os_service_default'],
  $kombu_reconnect_delay              = $facts['os_service_default'],
  $amqp_durable_queues                = $facts['os_service_default'],
  Boolean $purge_config               = false,
  Boolean $sync_db                    = true,
  $max_missed_heartbeats              = $facts['os_service_default'],
  $check_interval                     = $facts['os_service_default'],
  $first_heartbeat_timeout            = $facts['os_service_default'],
){

  include mistral::deps
  include mistral::params
  include mistral::db

  package { 'mistral-common':
    ensure => $package_ensure,
    name   => $::mistral::params::common_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  resources { 'mistral_config':
    purge => $purge_config,
  }

  mistral_config {
    'DEFAULT/report_interval':                  value => $report_interval;
    'DEFAULT/service_down_time':                value => $service_down_time;
    'action_heartbeat/max_missed_heartbeats':   value => $max_missed_heartbeats;
    'action_heartbeat/check_interval':          value => $check_interval;
    'action_heartbeat/first_heartbeat_timeout': value => $first_heartbeat_timeout;
  }

  mistral_config {
    'openstack_actions/os_actions_endpoint_type':  value => $os_actions_endpoint_type;
    'DEFAULT/os_actions_endpoint_type':           ensure => absent;
  }

  oslo::messaging::default {'mistral_config':
    transport_url        => $default_transport_url,
    control_exchange     => $control_exchange,
    rpc_response_timeout => $rpc_response_timeout,
  }

  oslo::messaging::notifications {'mistral_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  oslo::messaging::rabbit {'mistral_config':
    rabbit_ha_queues                => $rabbit_ha_queues,
    rabbit_use_ssl                  => $rabbit_use_ssl,
    kombu_failover_strategy         => $kombu_failover_strategy,
    kombu_ssl_version               => $kombu_ssl_version,
    kombu_ssl_ca_certs              => $kombu_ssl_ca_certs,
    kombu_ssl_certfile              => $kombu_ssl_certfile,
    kombu_ssl_keyfile               => $kombu_ssl_keyfile,
    kombu_reconnect_delay           => $kombu_reconnect_delay,
    heartbeat_timeout_threshold     => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                  => $rabbit_heartbeat_rate,
    heartbeat_in_pthread            => $rabbit_heartbeat_in_pthread,
    amqp_durable_queues             => $amqp_durable_queues,
    rabbit_quorum_queue             => $rabbit_quorum_queue,
    rabbit_transient_quorum_queue   => $rabbit_transient_quorum_queue,
    rabbit_quorum_delivery_limit    => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes  => $rabbit_quorum_max_memory_bytes,
  }

  if $sync_db {
    include mistral::db::sync
  }
}
