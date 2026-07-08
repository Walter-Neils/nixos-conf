{ pkgs, inputs, config, ... }:
{
	boot.kernel.sysctl = {
	  "vm.max_map_count" = 1048576;
	  "fs.file-max" = 524288;
	};
}
