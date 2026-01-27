{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./config
  ];

  config = {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
