#
# Glance Dashboard - Personal Information Dashboard
#
# A self-hosted, customizable dashboard for monitoring and quick access.
# Features: RSS feeds, bookmarks, weather, stocks, calendars, system monitoring.
#
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  
  cfg = config.programs.glance;
in {
  options.programs.glance = {
    enable = mkEnableOption "Glance personal dashboard";
    
    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port for Glance dashboard web interface";
    };

    browser = mkOption {
      type = types.str;
      default = "xdg-open";
      description = "Browser command to use for opening the dashboard";
    };

    location = mkOption {
      type = types.str;
      default = "New York, US";
      description = "Location for weather widget (e.g., 'London, UK')";
    };

    theme = mkOption {
      type = types.submodule {
        options = {
          background = mkOption {
            type = types.str;
            default = "240 21 15";
            description = "Background color in RGB format";
          };
          
          primary = mkOption {
            type = types.str;
            default = "217 92 83";
            description = "Primary accent color in RGB format";
          };
        };
      };
      default = {};
      description = "Theme configuration for dashboard";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.glance ];

    # Dashboard configuration
    xdg.configFile."glance/glance.yml".text = lib.generators.toYAML {} {
      server = {
        host = "0.0.0.0";
        port = cfg.port;
        assets-path = "";
      };

      theme = {
        background-color = cfg.theme.background;
        contrast-multiplier = 1.2;
        primary-color = cfg.theme.primary;
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };

      pages = [
        # Main DevOps Dashboard
        {
          name = "DevOps Command Center";
          columns = [
            # Left column - Time & Calendar
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  title = "Calendar";
                }
                {
                  type = "clock";
                  hour-format = "24h";
                  timezones = [
                    { timezone = "Local"; }
                    { timezone = "UTC"; label = "UTC"; }
                    { timezone = "America/New_York"; label = "New York"; }
                    { timezone = "Europe/London"; label = "London"; }
                    { timezone = "Asia/Tokyo"; label = "Tokyo"; }
                  ];
                }
              ];
            }

            # Center column - Main content
            {
              size = "full";
              widgets = [
                # Quick Links
                {
                  type = "bookmarks";
                  title = "🚀 DevOps Quick Access";
                  groups = [
                    {
                      title = "Kubernetes";
                      links = [
                        { title = "K8s Dashboard"; url = "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"; }
                        { title = "Grafana"; url = "http://localhost:3000"; }
                        { title = "Prometheus"; url = "http://localhost:9090"; }
                        { title = "AlertManager"; url = "http://localhost:9093"; }
                      ];
                    }
                    {
                      title = "Development";
                      links = [
                        { title = "GitHub"; url = "https://github.com"; }
                        { title = "GitLab"; url = "https://gitlab.com"; }
                        { title = "Docker Hub"; url = "https://hub.docker.com"; }
                        { title = "Terraform Registry"; url = "https://registry.terraform.io"; }
                      ];
                    }
                    {
                      title = "Cloud Consoles";
                      links = [
                        { title = "AWS Console"; url = "https://console.aws.amazon.com"; }
                        { title = "Azure Portal"; url = "https://portal.azure.com"; }
                        { title = "GCP Console"; url = "https://console.cloud.google.com"; }
                        { title = "DigitalOcean"; url = "https://cloud.digitalocean.com"; }
                      ];
                    }
                  ];
                }

                # Tech News Feeds
                {
                  type = "rss";
                  title = "📰 Tech & DevOps News";
                  feeds = [
                    { url = "https://kubernetes.io/feed.xml"; title = "Kubernetes Blog"; }
                    { url = "https://blog.docker.com/feed/"; title = "Docker Blog"; }
                    { url = "https://aws.amazon.com/blogs/aws/feed/"; title = "AWS News"; }
                    { url = "https://hnrss.org/frontpage"; title = "Hacker News"; }
                    { url = "https://feeds.feedburner.com/oreilly/radar/radar"; title = "O'Reilly Radar"; }
                  ];
                  limit = 10;
                }
              ];
            }

            # Right column - Weather & Stocks
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = cfg.location;
                  units = "metric";
                }
                {
                  type = "stocks";
                  stocks = [
                    { symbol = "AAPL"; name = "Apple"; }
                    { symbol = "GOOGL"; name = "Google"; }
                    { symbol = "MSFT"; name = "Microsoft"; }
                    { symbol = "NVDA"; name = "NVIDIA"; }
                    { symbol = "TSLA"; name = "Tesla"; }
                  ];
                }
              ];
            }
          ];
        }

        # Monitoring Dashboard
        {
          name = "System Monitoring";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "iframe";
                  url = "http://localhost:3000/d/node-exporter-full";
                  title = "System Metrics (Grafana)";
                  height = 500;
                }
                {
                  type = "iframe";
                  url = "http://localhost:9090/targets";
                  title = "Prometheus Targets";
                  height = 300;
                }
              ];
            }
          ];
        }
      ];
    };

    # Systemd service for automatic startup
    systemd.user.services.glance = {
      Unit = {
        Description = "Glance Personal Dashboard";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.glance}/bin/glance --config %h/.config/glance/glance.yml";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "PATH=${lib.makeBinPath [ pkgs.curl pkgs.wget ]}"
        ];
      };

      Install.WantedBy = [ "default.target" ];
    };

    # Desktop entry for quick access
    xdg.desktopEntries.glance = {
      name = "Glance Dashboard";
      comment = "Personal DevOps dashboard";
      exec = "${cfg.browser} http://localhost:${toString cfg.port}";
      icon = "dashboard";
      categories = [ "Network" "Monitor" "System" ];
      terminal = false;
    };

    # Convenient shell aliases
    programs.bash.shellAliases = lib.mkIf config.programs.bash.enable {
      dashboard = "${cfg.browser} http://localhost:${toString cfg.port}";
      glance-logs = "journalctl --user -u glance -f";
      glance-restart = "systemctl --user restart glance";
      glance-status = "systemctl --user status glance";
    };

    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      dashboard = "${cfg.browser} http://localhost:${toString cfg.port}";
      glance-logs = "journalctl --user -u glance -f";
      glance-restart = "systemctl --user restart glance";
      glance-status = "systemctl --user status glance";
    };
  };
}
