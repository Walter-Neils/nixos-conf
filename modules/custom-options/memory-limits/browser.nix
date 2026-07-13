{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  options.win.limits.memory.browser = {
    memoryHigh = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "When the application should be throttled for high memory usage";
      default = null;
    };

    memoryMax = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "When the application should be killed for overusing memory";
      default = null;
    };
  };
}
