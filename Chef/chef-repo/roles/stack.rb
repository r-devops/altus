name "stack"
description "ROLE for all stack cration"
run_list "recipe[apache]", "recipe[tomcat]", "recipe[mariadb]"
