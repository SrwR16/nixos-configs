#
# Zen Browser - Privacy-Focused Browser
#
# A Firefox-based browser with enhanced privacy features and modern UI.
# Features: Vertical tabs, workspaces, built-in ad blocking, fingerprinting protection.
#
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  
  cfg = config.programs.zen-browser;
in {
  options.programs.zen-browser = {
    enable = mkEnableOption "Zen privacy-focused browser";
  };

  config = mkIf cfg.enable {
    # Install Zen browser from flake input
    home.packages = [ inputs.zen-browser.packages.${pkgs.system}.default ];

    # Set Zen as default browser for web content
    xdg.mimeApps.defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
    };

    # Default profile with privacy enhancements
    home.file.".zen/default/user.js".text = ''
      // ========================================
      // Privacy Enhancements
      // ========================================
      
      // Disable telemetry completely
      user_pref("toolkit.telemetry.enabled", false);
      user_pref("toolkit.telemetry.unified", false);
      user_pref("toolkit.telemetry.server", "");
      user_pref("datareporting.healthreport.uploadEnabled", false);
      user_pref("datareporting.policy.dataSubmissionEnabled", false);
      user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
      user_pref("browser.newtabpage.activity-stream.telemetry", false);
      user_pref("browser.ping-centre.telemetry", false);

      // Enhanced tracking protection
      user_pref("privacy.trackingprotection.enabled", true);
      user_pref("privacy.trackingprotection.socialtracking.enabled", true);
      user_pref("privacy.trackingprotection.cryptomining.enabled", true);
      user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
      user_pref("privacy.donottrackheader.enabled", true);
      user_pref("privacy.firstparty.isolate", true);

      // Fingerprinting resistance
      user_pref("privacy.resistFingerprinting", true);
      user_pref("privacy.resistFingerprinting.letterboxing", false);
      user_pref("webgl.disabled", false); // Keep WebGL for compatibility

      // DNS over HTTPS (Cloudflare)
      user_pref("network.trr.mode", 2); // 2 = prefer DoH, fallback to system DNS
      user_pref("network.trr.uri", "https://1.1.1.1/dns-query");
      user_pref("network.trr.custom_uri", "https://1.1.1.1/dns-query");

      // ========================================
      // Security Enhancements
      // ========================================
      
      user_pref("security.ssl.require_safe_negotiation", true);
      user_pref("security.tls.enable_0rtt_data", false);
      user_pref("browser.safebrowsing.malware.enabled", true);
      user_pref("browser.safebrowsing.phishing.enabled", true);

      // ========================================
      // Performance Optimizations
      // ========================================
      
      user_pref("gfx.webrender.all", true);
      user_pref("layers.acceleration.force-enabled", true);
      user_pref("layout.css.backdrop-filter.enabled", true);
      user_pref("media.ffmpeg.vaapi.enabled", true); // Hardware acceleration

      // ========================================
      // Developer Tools
      // ========================================
      
      user_pref("devtools.debugger.remote-enabled", true);
      user_pref("devtools.chrome.enabled", true);
      user_pref("devtools.debugger.prompt-connection", false);

      // ========================================
      // Zen-Specific Features
      // ========================================
      
      user_pref("zen.view.sidebar-expanded", true);
      user_pref("zen.tabs.vertical", true);
      user_pref("zen.workspaces.enabled", true);
      user_pref("zen.theme.accent-color", "#c4a7e7"); // Rose Pine accent

      // ========================================
      // UI Preferences
      // ========================================
      
      user_pref("browser.tabs.warnOnClose", false);
      user_pref("browser.tabs.warnOnCloseOtherTabs", false);
      user_pref("browser.urlbar.suggest.searches", true);
      user_pref("browser.urlbar.suggest.history", true);
      user_pref("browser.urlbar.suggest.bookmark", true);
      user_pref("browser.download.autohideButton", false);
    '';

    # Development profile for web development (relaxed security)
    home.file.".zen/dev/user.js".text = ''
      // Development Profile - Relaxed Security for Local Development
      
      // Enable all developer tools
      user_pref("devtools.chrome.enabled", true);
      user_pref("devtools.debugger.remote-enabled", true);
      user_pref("devtools.debugger.prompt-connection", false);
      user_pref("devtools.command-button-pick.enabled", true);
      user_pref("devtools.performance.enabled", true);
      user_pref("devtools.webconsole.timestampMessages", true);
      user_pref("devtools.webconsole.persistlog", true);

      // Allow localhost and development URLs
      user_pref("security.tls.insecure_fallback_hosts", "localhost,127.0.0.1,.local");
      user_pref("network.stricttransportsecurity.preloadlist", false);

      // Allow mixed content for local development
      user_pref("security.mixed_content.block_active_content", false);
      user_pref("security.mixed_content.block_display_content", false);

      // Disable some privacy features that interfere with development
      user_pref("privacy.resistFingerprinting", false);
      user_pref("privacy.firstparty.isolate", false);

      // Keep standard tracking protection
      user_pref("privacy.trackingprotection.enabled", true);
    '';

    # Privacy-focused profile for sensitive browsing
    home.file.".zen/privacy/user.js".text = ''
      // Privacy Profile - Maximum Privacy Settings
      
      // Extreme fingerprinting resistance
      user_pref("privacy.resistFingerprinting", true);
      user_pref("privacy.resistFingerprinting.letterboxing", true);
      user_pref("webgl.disabled", true);
      user_pref("javascript.options.asmjs", false);
      user_pref("javascript.options.wasm", false);

      // Strict content blocking
      user_pref("browser.contentblocking.category", "strict");
      user_pref("privacy.trackingprotection.cryptomining.enabled", true);
      user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
      user_pref("privacy.trackingprotection.socialtracking.enabled", true);

      // Disable WebRTC (prevents IP leaks)
      user_pref("media.peerconnection.enabled", false);
      user_pref("media.navigator.enabled", false);

      // Force DNS over HTTPS (no fallback)
      user_pref("network.trr.mode", 3);
      user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

      // Disable location services
      user_pref("geo.enabled", false);
      user_pref("geo.provider.network.url", "");

      // Clear data on shutdown
      user_pref("privacy.sanitize.sanitizeOnShutdown", true);
      user_pref("privacy.clearOnShutdown.cache", true);
      user_pref("privacy.clearOnShutdown.cookies", true);
      user_pref("privacy.clearOnShutdown.downloads", true);
      user_pref("privacy.clearOnShutdown.formdata", true);
      user_pref("privacy.clearOnShutdown.history", true);
      user_pref("privacy.clearOnShutdown.sessions", true);
    '';

    # Profile switcher aliases
    programs.bash.shellAliases = lib.mkIf config.programs.bash.enable {
      zen = "zen-browser";
      zen-dev = "zen-browser --profile dev";
      zen-privacy = "zen-browser --profile privacy";
    };

    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      zen = "zen-browser";
      zen-dev = "zen-browser --profile dev";
      zen-privacy = "zen-browser --profile privacy";
    };
  };
}
