return {
	-- CMake integration
	{
		"cdelledonne/vim-cmake",
		config = function()
			-- use ':CMakeGenerate' as 'build' is already defined as default config
			vim.g.cmake_build_dir_location = "."
			vim.g.cmake_default_config = "build"
			vim.g.cmake_generate_options = { "-D CMAKE_EXPORT_COMPILE_COMMANDS=ON" }
		end
	},
}
