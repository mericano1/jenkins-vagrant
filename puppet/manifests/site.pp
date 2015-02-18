node default{

  # Lets get some Jenkins going up in here!
  include ::jenkins

  # Manage our luxurious suite of Jenkins Modules
  ############################################################################

  # Install dependency plugins, that is to say, plugins that are probably cool
  # on their own, but are really only here to support the primary plugins in
  # this example.
  jenkins::plugin { 'credentials': }
  jenkins::plugin { 'ssh-credentials': }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'token-macro': }

  # Primary Plugins
  jenkins::plugin { 'git': }
  jenkins::plugin { 'ws-cleanup': }
  jenkins::plugin { 'copyartifact': }
  jenkins::plugin { 'greenballs': }
  jenkins::plugin { 'chucknorris': }
  jenkins::plugin { 'build-flow-plugin': }
  jenkins::plugin { 'dynamic-axis': }

  include ::git
  include wget

  wget::fetch { "sbt-launch":
    source      => 'http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.5/sbt-launch.jar',
    destination => '/usr/local/bin/sbt-launch.jar',
    timeout     => 0,
    verbose     => false
  }

  file { 'sbt_launch':
    ensure => file,
    path   => '/usr/local/bin/sbt',
    owner  => 'jenkins',
    group  => 'jenkins',
    mode => 755,
    source => '/vagrant/shell/sbt',
  }

  # Place the example job configurations in place
  file { 'jenkins_home':
    ensure  => directory,
    path    => '/var/lib/jenkins/jobs',
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => '/vagrant/jenkins_home/jobs',
    recurse => remote,
    notify  => Exec['reload jenkins jobs'],
  }


  # Place an example root config
  file { 'jenkins_credentials':
    ensure => file,
    path   => '/var/lib/jenkins/credentials.xml',
    owner  => 'jenkins',
    group  => 'jenkins',
    source => '/vagrant/jenkins_home/credentials.xml',
    notify => Exec['reload jenkins jobs'],
  }



  # Tell Jenkins to reload configuratios without restarting
  exec { 'reload jenkins jobs':
    command     => '/usr/bin/curl --retry-max-time 30 --retry 3 --retry-delay 5 -d "Submit=Yes" http://localhost:8080/reload',
    tries       => '3',
    try_sleep   => '5',
    refreshonly => true,
  }


}
