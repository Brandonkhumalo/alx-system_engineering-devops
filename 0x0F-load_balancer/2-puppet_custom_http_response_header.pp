# Puppet manifest to add X-Served-By header with the hostname to Nginx

package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure     => running,
  enable     => true,
  require    => Package['nginx'],
}

file { '/etc/nginx/conf.d/custom_header.conf':
  ensure  => file,
  content => 'add_header X-Served-By $hostname;',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Ensure the config is included in the main nginx config
exec { 'Include custom header in nginx config':
  command => 'echo "include /etc/nginx/conf.d/*.conf;" >> /etc/nginx/nginx.conf',
  unless  => 'grep -q "include /etc/nginx/conf.d/*.conf;" /etc/nginx/nginx.conf',
  require => File['/etc/nginx/conf.d/custom_header.conf'],
  notify  => Service['nginx'],
}
