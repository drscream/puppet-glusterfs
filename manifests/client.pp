# client.pp

class glusterfs::client {
	
	package { "glusterfs-client":
	  ensure => installed
	}

}
