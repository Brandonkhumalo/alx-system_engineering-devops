# Puppet manifest to add X-Served-By header with the hostname to Nginx

package { 'nginx':
  ensure => installed,
}

# Ensure nginx service is enabled and running
service { 'nginx':
  ensure    => running,
  enable    => true,
  require   => Package['nginx'],
}

# Create a custom header config file
file { '/etc/nginx/conf.d/custom_header.conf':
  ensure  => file,
  content => 'add_header X-Served-By $hostname;',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Make sure custom conf files are included in nginx.conf (idempotent)
augeas { 'Include conf.d in nginx.conf':
  context => '/files/etc/nginx/nginx.conf',
  changes => [
    'ins include after http',
    'set include "include /etc/nginx/conf.d/*.conf;"',
  ],
  onlyif  => 'match /files/etc/nginx/nginx.conf/http/include[. = "include /etc/nginx/conf.d/*.conf;"] size == 0',
  require => File['/etc/nginx/conf.d/custom_header.conf'],
  notify  => Service['nginx'],
}
