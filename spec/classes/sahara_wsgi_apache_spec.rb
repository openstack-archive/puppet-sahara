require 'spec_helper'

describe 'sahara::wsgi::apache' do

  shared_examples 'sahara::wsgi::apache' do
    context 'with default params' do
      it {
        should contain_class('sahara::deps')
        should contain_class('sahara::params')
      }

      it { should contain_openstacklib__wsgi__apache('sahara_wsgi').with(
        :bind_port                   => 8386,
        :group                       => 'sahara',
        :path                        => '/',
        :priority                    => 10,
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'sahara',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'sahara',
        :wsgi_process_group          => 'sahara',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :headers                     => nil,
        :request_headers             => nil,
        :custom_wsgi_process_options => {},
        :access_log_file             => nil,
        :access_log_format           => nil,
      )}
    end

    context 'when overriding paramters' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => false,
          :workers                     => 8,
          :wsgi_process_display_name   => 'sahara',
          :threads                     => 2,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :headers                     => ['set X-XSS-Protection "1; mode=block"'],
          :request_headers             => ['set Content-Type "application/json"'],
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log'
        }
      end

      it { is_expected.to contain_openstacklib__wsgi__apache('sahara_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'sahara',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => false,
        :threads                     => 2,
        :user                        => 'sahara',
        :workers                     => 8,
        :wsgi_daemon_process         => 'sahara',
        :wsgi_process_display_name   => 'sahara',
        :wsgi_process_group          => 'sahara',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :headers                     => ['set X-XSS-Protection "1; mode=block"'],
        :request_headers             => ['set Content-Type "application/json"'],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log'
      )}
    end

    context 'with ssl' do
      let :params do
        {
          :ssl => true,
        }
      end

      it { should contain_openstacklib__wsgi__apache('sahara_wsgi').with_ssl(true) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 4,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :wsgi_script_path   => '/usr/lib/cgi-bin/sahara',
            :wsgi_script_source => '/usr/bin/sahara-wsgi-api'
          }
        when 'RedHat'
          {
            :wsgi_script_path   => '/var/www/cgi-bin/sahara',
            :wsgi_script_source => '/usr/bin/sahara-wsgi-api'
          }
        end
      end

      it_behaves_like 'sahara::wsgi::apache'
    end
  end
end

