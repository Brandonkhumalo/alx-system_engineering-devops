# Ensure the SSH config file exists
file { '/home/ubuntu/.ssh/config':
  ensure  => file,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0600',
}

# Add line to use private key
file_line { 'Declare identity file':
  path  => '/home/ubuntu/.ssh/config',
  line  => '  IdentityFile ~/.ssh/school',
  match => '^ *IdentityFile',
}

# Add line to disable password authentication
file_line { 'Turn off passwd auth':
  path  => '/home/ubuntu/.ssh/config',
  line  => '  PasswordAuthentication no',
  match => '^ *PasswordAuthentication',
}
