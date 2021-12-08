require 'spec_helper'

describe 'mistral::wsgi::apache' do

  shared_examples_for 'apache serving mistral with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('mistral::deps') }
      it { is_expected.to contain_class('mistral::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('mistral_wsgi').with(
        :bind_port                   => 8989,
        :group                       => 'mistral',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'mistral',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'mistral',
        :wsgi_process_group          => 'mistral',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :access_log_file             => false,
        :access_log_format           => false,
        :custom_wsgi_process_options => {},
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => false,
          :wsgi_process_display_name   => 'mistral',
          :workers                     => 37,
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log',
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :vhost_custom_fragment       => 'Timeout 99',
        }
      end
      it { is_expected.to contain_class('mistral::deps') }
      it { is_expected.to contain_class('mistral::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('mistral_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'mistral',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'mistral',
        :vhost_custom_fragment       => 'Timeout 99',
        :workers                     => 37,
        :wsgi_daemon_process         => 'mistral',
        :wsgi_process_display_name   => 'mistral',
        :wsgi_process_group          => 'mistral',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log',
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld'
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/mistral',
            :wsgi_script_source => '/usr/bin/mistral-wsgi-api'
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/mistral',
            :wsgi_script_source => '/usr/bin/mistral-wsgi-api'
          }

        end
      end
      it_configures 'apache serving mistral with mod_wsgi'
    end
  end
end
