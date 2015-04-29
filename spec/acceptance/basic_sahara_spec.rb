require 'spec_helper_acceptance'

describe 'basic sahara' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      include ::apt
      # some packages are not autoupgraded in trusty.
      # it will be fixed in liberty, but broken in kilo.
      $need_to_be_upgraded = ['python-tz', 'python-pbr']
      apt::source { 'trusty-updates-kilo':
        location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu/',
        release           => 'trusty-updates',
        required_packages => 'ubuntu-cloud-keyring',
        repos             => 'kilo/main',
        trusted_source    => true,
      } ~>
      exec { '/usr/bin/apt-get -y dist-upgrade':
        refreshonly => true,
      }
      Apt::Source['trusty-updates-kilo'] -> Package<| |>

      class { '::mysql::server': }

      class { '::rabbitmq':
        delete_guest_user => true,
        erlang_cookie     => 'secrete',
      }

      rabbitmq_vhost { '/':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user { 'sahara':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'sahara@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Keystone resources, needed by Sahara to run
      class { '::keystone::db::mysql':
        password => 'keystone',
      }
      class { '::keystone':
        verbose             => true,
        debug               => true,
        database_connection => 'mysql://keystone:keystone@127.0.0.1/keystone',
        admin_token         => 'admin_token',
        enabled             => true,
      }
      class { '::keystone::roles::admin':
        email    => 'test@example.tld',
        password => 'a_big_secret',
      }
      class { '::keystone::endpoint':
        public_url => "https://${::fqdn}:5000/",
        admin_url  => "https://${::fqdn}:35357/",
      }

      # Sahara resources
      class { '::sahara':
        database_connection => 'mysql://sahara:a_big_secret@127.0.0.1/sahara?charset=utf8',
        keystone_password   => 'a_big_secret',
      }
      class { '::sahara::db::mysql':
        password => 'a_big_secret',
      }
      class { '::sahara::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::sahara::client': }
      class { '::sahara::notify::rabbitmq':
        rabbit_userid       => 'sahara',
        rabbit_password     => 'an_even_bigger_secret',
        rabbit_host         => '127.0.0.1',
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8386) do
      it { is_expected.to be_listening.with('tcp') }
    end

  end
end
