# First, install a mysql server
class { 'mysql::server':
  # sahara documentation recommends this configuration.
  override_options   => {
    'mysqld' => {
      'max_allowed_packet' => '256M',
    },
  },

  # many configurations will need this line, too
  package_name       => 'mariadb-galera-server',

  # if you're installing into an existing openstack
  manage_config_file => false,
  purge_conf_dir     => false,
}

# Then, create a database
class { 'sahara::db::mysql':
  password => 'a_big_secret',
}

# Then the common class
class { 'sahara':
  database_connection => 'mysql+pymysql://sahara:a_big_secret@127.0.0.1:3306/sahara',
  debug               => true,
  host                => '0.0.0.0',
  port                => 8386,
  use_floating_ips    => true,
}

# Keystone authtoken parameters
class { 'sahara::keystone::authtoken':
  password => 'a_big_secret',
}

# Setup API service in Apache
class { 'sahara::service::api':
  service_name => 'httpd',
}

# On Ubuntu there are Apache configuration that is dropped when the
# sahara-api package is installed. The puppet-sahara module will remove
# these and fix the apache configuration for you but the Ubuntu packages
# requires these files to exist for upgrading the sahara-api package to not
# break.
if ($facts['os']['name'] == 'Ubuntu') {
  ensure_resource('file', '/etc/apache2/sites-available/sahara-api.conf', {
    'ensure'  => 'present',
    'content' => '',
  })
  ensure_resource('file', '/etc/apache2/sites-enabled/sahara-api.conf', {
    'ensure'  => 'present',
    'content' => '',
  })

  Package['sahara-api'] -> File['/etc/apache2/sites-available/sahara-api.conf']
  -> File['/etc/apache2/sites-enabled/sahara-api.conf'] ~> Anchor['sahara::install::end']
}

include apache
class { 'sahara::wsgi::apache':
  workers => 2,
}

# Setup the engine service
class { 'sahara::service::engine': }

# Finally, make it accessible
class { 'sahara::keystone::auth':
  password => 'secrete',
}
