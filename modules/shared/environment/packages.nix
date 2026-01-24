{
  pkgs,
  lib,
  ...
}: {
  environment = {
    defaultPackages = lib.mkForce [];
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      lshw
      bind.dnsutils
      
      # DevOps essentials (ONLY lightweight CLIs)
      # Heavy tools go in project templates
      direnv         # Environment switcher (essential for Phase 2)
      jq             # JSON processor (used everywhere)
      yq-go          # YAML processor (used everywhere)
    ];
  };
}
