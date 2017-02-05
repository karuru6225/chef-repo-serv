case platform
	when "centos"
		default['vim']['packages'] = [
			"vim-enhanced"
		]
	when "debian", "ubuntu"
		default['vim']['packages'] = [
			"vim"
		]
end
