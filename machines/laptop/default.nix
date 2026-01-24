#
# Laptop Machine Configuration
#
# A DevOps-focused laptop configuration with performance optimizations.
#
{ lib, ... }:

{
  imports = [
    ./performance.nix  # Performance optimizations for DevOps workloads
  ];

  # Basic laptop configuration
  # Note: Add hardware.nix and other configurations as needed
  
  networking.hostName = lib.mkDefault "laptop";
}
