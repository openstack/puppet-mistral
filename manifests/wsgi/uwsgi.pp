#
# Copyright 2025 Thomas Goirand <zigo@debian.org>
#
# Author: Thomas Goirand <zigo@debian.org>
#
# == Class: mistral::wsgi::uwsgi
#
# Configure the UWSGI service for Mistral API.
#
# == Parameters
#
# [*processes*]
#   (Optional) Number of processes.
#   Defaults to $facts['os_workers'].
#
# [*threads*]
#   (Optional) Number of threads.
#   Defaults to 1.
#
# [*listen_queue_size*]
#   (Optional) Socket listen queue size.
#   Defaults to 100
#
class mistral::wsgi::uwsgi (
  $processes         = $facts['os_workers'],
  $threads           = 1,
  $listen_queue_size = 100,
) {
  include mistral::deps

  if $facts['os']['name'] != 'Debian' {
    warning('This class is only valid for Debian, as other operating systems are not using uwsgi by default.')
  }

  mistral_api_uwsgi_config {
    'uwsgi/processes': value => $processes;
    'uwsgi/threads':   value => $threads;
    'uwsgi/listen':    value => $listen_queue_size;
  }
}
