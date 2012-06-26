# define: nginx::resource::upstream
#
# This definition creates a new upstream proxy entry for NGINX
#
# Parameters:
#   [*ensure*]      - Enables or disables the specified location (present|absent)
#   [*members*]     - Array of member URIs for NGINX to connect to. Must follow valid NGINX syntax.
#   [*unix*]				- Valid NGINX syntax for unix socket
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::upstream { 'proxypass':
#    ensure  => present,
#    members => [
#        'localhost:3000',
#        'localhost:3001',
#        'localhost:3002',
#    ],
#  }
#  
#  nginx::resource::upstream { 'proxypass':
#		 ensure => present,
#		 socket => "unix:/tmp/unicorn.todo.sock fail_timeout=0"}
#	 }

define nginx::resource::upstream (
	$ensure = 'present',
	$members = undef,
	$socket
){
	File { 
		owner => 'root', 
		group => 'root', 
		mode  => '0644', 
	}

	if ($members != undef) {
		file { "/etc/nginx/conf.d/${name}-upstream.conf": 
			ensure => $ensure ? {
				'absent' => absent,
				default	 => 'file',
			},
			content => template('nginx/conf.d/upstream_port.erb'),
			notify => Class['nginx::service'],
		}
	} else {
		file { "/etc/nginx/conf.d/${name}-upstream.conf": 
			ensure => $ensure ? {
				'absent' => absent,
				default	 => 'file',
			},
			content => template('nginx/conf.d/upstream_socket.erb'),
			notify => Class['nginx::service'],
		}
	}
	
	
}