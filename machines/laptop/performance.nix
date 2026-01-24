#
# Performance Optimizations for DevOps Workloads
#
# System tuning for development and container workloads.
# Optimizes network, memory, and I/O performance.
#
# WARNING: Some settings reduce security for performance.
# Only use on development/personal machines.
#
{ lib, ... }:

{
  # ========================================
  # Kernel Parameters
  # ========================================
  
  boot.kernel.sysctl = {
    # Network Performance Tuning
    "net.core.rmem_max" = 134217728;              # 128MB max receive buffer
    "net.core.wmem_max" = 134217728;              # 128MB max send buffer
    "net.core.rmem_default" = 134217728;
    "net.core.wmem_default" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728"; # TCP receive buffer
    "net.ipv4.tcp_wmem" = "4096 65536 134217728"; # TCP send buffer
    "net.core.netdev_max_backlog" = 5000;         # Packet queue size
    "net.ipv4.tcp_congestion_control" = "bbr";    # Better congestion algorithm
    
    # Virtual Memory Tuning
    "vm.swappiness" = 10;                         # Reduce swap usage
    "vm.dirty_ratio" = 15;                        # Start background writeback at 15%
    "vm.dirty_background_ratio" = 5;              # Background writeback at 5%
    "vm.vfs_cache_pressure" = 50;                 # Prefer keeping cache
    
    # File System Limits
    "fs.file-max" = 2097152;                      # Max open files
    "fs.inotify.max_user_watches" = 524288;       # For file watchers (IDEs, etc)
    "fs.inotify.max_user_instances" = 512;
    
    # Kernel Performance
    "kernel.pid_max" = 4194304;                   # Max process IDs
    "kernel.threads-max" = 4194304;               # Max threads
    
    # Container Networking
    "net.ipv4.ip_forward" = 1;                    # Enable IP forwarding
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
  };

  # ========================================
  # Boot Parameters
  # ========================================
  
  boot.kernelParams = [
    "quiet"                                       # Reduce boot messages
    "splash"                                      # Show splash screen
    "transparent_hugepage=madvise"                # THP for performance
    "nowatchdog"                                  # Disable watchdog (faster boot)
    
    # Security vs Performance trade-off
    # WARNING: DO NOT ENABLE ON PRODUCTION SYSTEMS!
    # Disabling mitigations re-enables vulnerabilities including:
    # - Spectre (CVE-2017-5753, CVE-2017-5715)
    # - Meltdown (CVE-2017-5754)
    # - L1TF (CVE-2018-3615, CVE-2018-3620, CVE-2018-3646)
    # - MDS/Zombieload (CVE-2018-12126, CVE-2018-12127, CVE-2018-12130, CVE-2019-11091)
    # Only consider for isolated development VMs with no sensitive data.
    # "mitigations=off"                           # Disable CPU mitigations (UNSAFE)
  ];

  # ========================================
  # CPU Frequency Scaling
  # ========================================
  
  powerManagement = {
    # Performance governor for maximum CPU speed
    cpuFreqGovernor = "performance";
    
    # Enable powertop auto-tuning (comment out if using performance governor)
    # powertop.enable = true;
  };

  # ========================================
  # I/O Scheduler
  # ========================================
  
  # Use optimal I/O scheduler based on drive type
  services.udev.extraRules = ''
    # SSD/NVMe - use none/noop scheduler
    ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
    
    # HDD - use mq-deadline scheduler
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="mq-deadline"
  '';

  # ========================================
  # Networking Optimizations
  # ========================================
  
  networking = {
    # Use systemd-resolved for faster DNS
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    
    # Enable TCP Fast Open
    firewall.extraCommands = ''
      echo 3 > /proc/sys/net/ipv4/tcp_fastopen
    '';
  };

  # ========================================
  # System Limits
  # ========================================
  
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "1048576";
    }
    {
      domain = "*";
      type = "soft";
      item = "nproc";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nproc";
      value = "unlimited";
    }
  ];

  # ========================================
  # ZRam (Compressed Swap in RAM)
  # ========================================
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # Use 50% of RAM for zram
  };

  # ========================================
  # Filesystem Optimizations
  # ========================================
  
  # Enable TRIM for SSDs (if using SSD)
  services.fstrim.enable = true;
  
  # tmpfs for /tmp (faster builds)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%"; # Use 50% of RAM for /tmp
}
