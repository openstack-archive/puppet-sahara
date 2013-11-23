
class { 'savanna::db::mysql': password => 'savanna', }

class { 'savanna::keystone::auth':
  password         => 'savanna',
  public_address   => '127.0.0.1',
  admin_address    => '127.0.0.1',
  internal_address => '127.0.0.1',
}

class { 'savanna':
  savanna_host        => '127.0.0.1',
  db_host             => '127.0.0.1',
  savanna_db_password => 'savanna',
  keystone_auth_host  => '127.0.0.1',
  keystone_password   => 'savanna',
  savanna_verbose     => true,
}

class { 'savanna::dashboard':
  savanna_host => '127.0.0.1',
  use_neutron  => true,
  require      => Class['Openstack::Horizon']
}
