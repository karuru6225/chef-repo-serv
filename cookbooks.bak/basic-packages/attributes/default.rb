case platform
	when "centos", "amazon"
		default['basic-packages']['packages'] = [
			{ :name =>  "man" },
			{ :name =>  "wget" },
			{ :name =>  "unzip" },
		]
	when "debian", "ubuntu"
		default['basic-packages']['packages'] = [
			{ :name =>  "man" },
			{ :name =>  "curl" },
			{ :name =>  "unzip" },
			{ :name =>  "at" },
		]
end
