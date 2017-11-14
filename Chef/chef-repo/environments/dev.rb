name 'dev'
description 'The development environment'
cookbook_versions  'demo2' => '= 0.1.1'
default_attributes({ 'demo2' => {'NAME' => 'DEMO2 from ENVIRONMENT'}})
override_attributes({ 'demo2' => {'NAME' => 'DEMO2 from ENVIRONMENT OVERRIDE'}})
