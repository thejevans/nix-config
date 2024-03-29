{ config, pkgs, lib, theme, inputs, ... }: {

  imports = [];

  options = {
    homeManagerModules.firefox.enable = lib.mkEnableOption "enables Firefox";
  };

  config = lib.mkIf config.homeManagerModules.firefox.enable {
    programs.firefox.enable = true;

    programs.firefox.package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;

        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };

      nativeMessagingHosts = [ pkgs.plasma-browser-integration ];
    };

    programs.firefox.profiles.thejevans = {
      id = 0;
      name = "thejevans";

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        decentraleyes
        darkreader
        kagi-search
        sponsorblock
        tree-style-tab
        plasma-integration
        wallabagger
      ];

      search = {
        force = true;
        default = "Kagi";

        engines = {
          "Kagi" = {
            urls = [{
              template = "https://kagi.com/search?q={searchTerms}";
          }];
            definedAliases = [ "@kagi" ];
          };

          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";

              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nw" ];
          };

          "Wikipedia (en)".metaData.alias = "@wiki";
          "Google".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };

      settings = {
          "general.smoothScroll" = true;
      };

      extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
      '';

      userChrome = (builtins.readFile ./userChrome.css);
      userContent = (builtins.readFile ./userContent.css);
    };
  };

}
