name "demo"
description "DEMO ROLE "
run_list "recipe[demo2]"
default_attributes "demo2" => { "NAME" => "DEMO2 from ROLE" }
