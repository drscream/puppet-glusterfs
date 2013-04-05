# glusterfs::client::config.pp

define glusterfs::client::config(
	$server,
	$mountdir = '/mnt/gluster',
	$username = 'gluster',
	$password = '',
	$owner = "root",
	$group = "root"
) {

	include glusterfs::client
	
	$mountpath = "${mountdir}/${name}"

	file { "${mountdir}":
		ensure => directory,
		owner => root,
		group => root,
	}
	
	exec { "umount ${mountpath}":
		unless => "ls ${mountdir}",
		notify => Mount["${mountpath}"],
	}
	
	file { "${mountpath}":
		ensure => directory,
		owner => $owner,
		group => $group,
		require => [ File["${mountdir}"], Exec["umount ${mountpath}"] ],
	}

	$device = "${server}:/${name}"

	mount { "${mountpath}":
		atboot => true,
		device => $device,
		ensure => mounted,
		fstype => "glusterfs",
		options => "noatime,_netdev",
		require => [ Package["glusterfs-client"], File["${mountpath}"] ],
		remounts => false,
	}

}
