# == Class: mistral
#
# Mistral base package & configuration
#
# === Parameters
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
# [*os_actions_endpoint_type*]
#   (optional) Type of endpoint in identity service catalog to use for
#   communication with OpenStack services
#   Defaults to $::os_service_default
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to boolean false or the $::os_service_default, it will not log to
#   any directory.
#   Defaults to '/var/log/mistral'.
#
# [*use_syslog*]
#   (Optional) Use syslog for logging.
#   Defaults to undef.
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef.
#
# [*log_facility*]
#   (Optional) Syslog facility to receive log lines.
#   Defaults to undef.
#
# [*debug*]
#   (Optional) Should the daemons log debug messages
#   Defaults to undef.
#
# [*database_connection*]
#   (optional) Url used to connect to database.
#   Defaults to undef.
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to undef.
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef.
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef.
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to undef.
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to underf.
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to undef.
#
# [*default_transport_url*]
#   (optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $::os_service_default
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all).
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $::os_service_default
#
# [*report_interval*]
#  (optional) Interval, in seconds, between nodes reporting state to
#  datastore (integer value).
#  Defaults to $::os_service_default
#
# [*service_down_time*]
#  (optional) Maximum time since last check-in for a service to be
#  considered up (integer value).
#  Defaults to $::os_service_default
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional)Use durable queues in amqp.
#   Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $::os_service_default
#
# [*coordination_backend_url*]
#   (optional) The backend URL to be used for coordination.
#   Defaults to $::os_service_default
#
# [*coordination_heartbeat_interval*]
#   (optional) Number of seconds between heartbeats for coordination.
#   Defaults to $::os_service_default
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
class mistral(
  $package_ensure                     = 'present',
  $database_connection                = $::os_service_default,
  $os_actions_endpoint_type           = $::os_service_default,
  $control_exchange                   = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $default_transport_url              = $::os_service_default,
  $notification_transport_url         = $::os_service_default,
  $notification_driver                = $::os_service_default,
  $notification_topics                = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $service_down_time                  = $::os_service_default,
  $report_interval                    = $::os_service_default,
  $kombu_failover_strategy            = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_dir                            = '/var/log/mistral',
  $log_facility                       = undef,
  $debug                              = undef,
  $coordination_backend_url           = $::os_service_default,
  $coordination_heartbeat_interval    = $::os_service_default,
  $purge_config                       = false,
  $sync_db                            = true,
){

  include ::mistral::deps
  include ::mistral::params
  include ::mistral::db
  include ::mistral::logging

  package { 'mistral-common':
    ensure => $package_ensure,
    name   => $::mistral::params::common_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  resources { 'mistral_config':
    purge => $purge_config,
  }

  mistral_config {
    'coordination/backend_url':             value => $coordination_backend_url;
    'coordination/heartbeat_interval':      value => $coordination_heartbeat_interval;
    'DEFAULT/report_interval':              value => $report_interval;
    'DEFAULT/service_down_time':            value => $service_down_time;
    'DEFAULT/os_actions_endpoint_type':     value => $os_actions_endpoint_type;
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
    rabbit_ha_queues            => $rabbit_ha_queues,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_failover_strategy     => $kombu_failover_strategy,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    amqp_durable_queues         => $amqp_durable_queues,
  }

  if $sync_db {
    include ::mistral::db::sync
  }
}
