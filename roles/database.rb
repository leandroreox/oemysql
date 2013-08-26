name "database"
description "The base role for systems that serve DATABASE traffic"
run_list "recipe[mysql-server::server]"
default_attributes ({
	"mysql-server" => { 
		"shard" => [ "1", "2" ] 
	}
})
