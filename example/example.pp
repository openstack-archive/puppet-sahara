
class { 'sahara::db::mysql': password => 'sahara', }

class { 'sahara::keystone::auth':
  password         => 'sahara',
  public_address   => '127.0.0.1',
  admin_address    => '127.0.0.1',
  internal_address => '127.0.0.1',
}

class { 'sahara':
  sahara_host        => '127.0.0.1',
  db_host            => '127.0.0.1',
  sahara_db_password => 'sahara',
  keystone_auth_host => '127.0.0.1',
  keystone_password  => 'sahara',
  sahara_verbose     => true,
}

class { 'sahara::dashboard':
  sahara_host => '127.0.0.1',
  use_neutron => true,
}
