# Basic Puppet Apache manifest
#
class mysql-server {

  #empty password
  $password = ""
  package { "mysql-client": ensure => installed }
  package { "mysql-server": ensure => installed }

  exec { "Set MySQL server root password":
    subscribe => [ Package["mysql-server"], Package["mysql-client"]],
    refreshonly => true,
    unless => "mysqladmin -uroot -p$password status",
    path => "/bin:/usr/bin",
    command => "mysqladmin -uroot password $password",
  }

  exec { "Configure PunchTab user & database":
    path => "/bin:/usr/bin",
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON punchtab.* TO 'root'@'%' IDENTIFIED BY '';FLUSH PRIVILEGES;CREATE DATABASE IF NOT EXISTS punchtab;\"",
    subscribe => [ Package["mysql-server"], Package["mysql-client"]],
    logoutput => "on_failure",
  }


  exec { "Change mysql bind IP address":
    path => "/bin:/usr/bin",
    command => "sed 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf > /tmp/my.cnf; cp /tmp/my.cnf /etc/mysql/my.cnf",
    logoutput => "on_failure",
    subscribe => [ Package["mysql-server"], Package["mysql-client"] ],
  }
  
  service { "mysql":
    ensure  => "running",
    enable  => "true",
    require => Package["mysql-server"],
  }

  file { "/etc/mysql/my.cnf":
    notify  => Service["mysql"],  # this sets up the relationship
    mode => 600,
    owner => "root",
    group => "root",
    require => Package["mysql-server"],
  }

}

class mongo-server {

  package { "mongodb": ensure => installed }

  exec { "mongodb_bind_ip":
    path => "/bin:/usr/bin",
    command => "sed 's/127.0.0.1/0.0.0.0/' /etc/mongodb.conf > /tmp/mongodb.conf ; cp /tmp/mongodb.conf /etc/mongodb.conf",
    logoutput => "on_failure",
    subscribe => Package["mongodb"],
    refreshonly => true
  }

  service { "mongodb":
    ensure  => running,
    enable  => true,
    subscribe => Exec["mongodb_bind_ip"],
  }

}

class rabbitmq-server {

  package { "rabbitmq-server": ensure => installed }

}

class redis-server {

  package { "redis-server": ensure => installed }

  service { "redis-server":
    ensure  => "running",
    enable  => "true",
    require => Package["redis-server"],
  }

  exec { "Change the bind IP address for redis":
    path => "/bin:/usr/bin",
    command => "sed 's/bind/#bind/' /etc/redis/redis.conf > /tmp/redis.conf ; cp /tmp/redis.conf /etc/redis/redis.conf",
    logoutput => "on_failure",
    subscribe => [ Package["redis-server"]],
  }

  file { "/etc/redis/redis.conf":
    notify  => Service["redis-server"],  # this sets up the relationship
    mode => 755,
    owner => "root",
    group => "root",
    require => Package["redis-server"],
  }

}


class git-client {
    package { "git": ensure => installed }
}

class libmysql {
    package {"libmysqlclient-dev": ensure => installed}
}

class python-tools {
    package {'python-pip': ensure => installed}
    package {'python-virtualenv': ensure => installed}
}

class libpg {
    package {"libpq-dev": ensure => installed}
}


class python-dev {
    package {"python2.7-dev": ensure => installed}
}

class tools {
  package {"vim": ensure => installed}
  package {"screen": ensure => installed}
}

class  mysql-client {
    package {"mysql-client-core-5.5": ensure => installed}
}

class somelib {
    package { "libxml2-dev": 
        ensure => installed
    } 
    package {"libxslt1-dev": 
        ensure => installed
    }
}

class dotcloud {
    exec { "Install dotcloud":
        path => "/bin:/usr/bin",
        command => "pip install dotcloud",
    }
}

exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
}

# all packages need to wait until apt-get update is finished
Exec["apt-get update"] -> Package <||>

include git-client
include python-tools
#include libmysql
#include libpg
#include somelib
#include python-dev
#include mysql-client
include tools
include dotcloud


# all packages need to wait until apt-get update is finished
Exec["apt-get update"] -> Package <||>      


#include mysql-server
#include mongo-server
#include rabbitmq-server
#include redis-server
include git-client
include python-tools
#include libmysql
#include libpg
#include python-dev
#include mysql-client
include tools
include dotcloud
