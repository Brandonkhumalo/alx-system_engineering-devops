# Ensure the SSH client config file exists
file { '/etc/ssh/ssh_config':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

# Add line to specify private key for authentication
file_line { 'Declare identity file':
  path  => '/etc/ssh/ssh_config',
  line  => 'IdentityFile ~/.ssh/school',
  match => '^IdentityFile',
}

# Add line to disable password authentication
file_line { 'Turn off passwd auth':
  path  => '/etc/ssh/ssh_config',
  line  => 'PasswordAuthentication no',
  match => '^PasswordAuthentication',
}
