{ pkgs, firefox, opt, ... }:
let
  inherit (opt) username;
  userChrome = ''
  /*
* penguinFox
* by p3nguin-kun
*/

/* config */


* {
  --animation-speed: 0.2s;
  --button-corner-rounding: 30px;
  --urlbar-container-height: 40px !important;
  --urlbar-min-height: 30px !important;
  --urlbar-height: 30px !important;
  --urlbar-toolbar-height: 38px !important;
  --moz-hidden-unscrollable: scroll !important;
  --toolbarbutton-border-radius: 3px !important;
  --tabs-border-color: transparent;
}

:root {
    --window: -moz-Dialog !important;
    --secondary: color-mix(in srgb, currentColor 5%, -moz-Dialog) !important;
    --uc-border-radius: 0px;
    --uc-status-panel-spacing: 0px;
    --uc-page-action-margin: 7px;
}
/*
animation and effect 
#nav-bar:not([customizing]) {
  visibility: visible;
  margin-top: -40px;
  transition-delay: 0.1s;
  filter: alpha(opacity=0);
  opacity: 0;
  transition: visibility, ease 0.1s, margin-top, ease 0.1s, opacity, ease 0.1s,
  rotate, ease 0.1s !important;
}

#nav-bar:hover,
#nav-bar:focus-within,
#urlbar[focused='true'],
#identity-box[open='true'],
#titlebar:hover + #nav-bar:not([customizing]),
#toolbar-menubar:not([inactive='true']) ~ #nav-bar:not([customizing]) {
  visibility: visible;

  margin-top: 0px;
  filter: alpha(opacity=100);
  opacity: 100;
  margin-bottom: -0.2px;
}
*/

#PersonalToolbar {
  margin-top: 0px;
}
#nav-bar .toolbarbutton-1[open='true'] {
  visibility: visible;
  opacity: 100;
}

:root:not([customizing]) :hover > .tabbrowser-tab:not(:hover) {
  transition: blur, ease 0.1s !important;
}

:root:not([customizing]) :not(:hover) > .tabbrowser-tab {
  transition: blur, ease 0.1s !important;
}

#tabbrowser-tabs .tab-label-container[customizing] {
  color: transparent;
  transition: ease 0.1s;
  transition-delay: 0.2s;
}

.tabbrowser-tab:not([pinned]) .tab-icon-image ,.bookmark-item .toolbarbutton-icon{opacity: 0!important; transition: .15s !important; width: 0!important; padding-left: 16px!important}
.tabbrowser-tab:not([pinned]):hover .tab-icon-image,.bookmark-item:hover .toolbarbutton-icon{opacity: 100!important; transition: .15s !important; display: inline-block!important; width: 16px!important; padding-left: 0!important}
.tabbrowser-tab:not([hover]) .tab-icon-image,.bookmark-item:not([hover]) .toolbarbutton-icon{padding-left: 0!important}

/*  Removes annoying buttons and spaces */
.titlebar-spacer[type="pre-tabs"], .titlebar-spacer[type="post-tabs"]{display: none !important}
#tabbrowser-tabs{border-inline-start-width: 0!important}

/*  Makes some buttons nicer  */
#PanelUI-menu-button, #unified-extensions-button, #reload-button, #stop-button {padding: 2px !important}
#reload-button, #stop-button{margin: 1px !important;}

/* X-button */
:root {
    --show-tab-close-button: none;
    --show-tab-close-button-hover: -moz-inline-block;
}
.tabbrowser-tab:not([pinned]) .tab-close-button { display: var(--show-tab-close-button) !important; }
.tabbrowser-tab:not([pinned]):hover .tab-close-button { display: var(--show-tab-close-button-hover) !important }

/* tabbar */

/* Hide the secondary Tab Label
 * e.g. playing indicator (the text, not the icon) */
.tab-secondary-label { display: none !important; }

:root {
  --toolbarbutton-border-radius: 0 !important;
  --tab-border-radius: 0 !important;
  --tab-block-margin: 0 !important;
}

.tabbrowser-tab:is([visuallyselected='true'], [multiselected])
  > .tab-stack
  > .tab-background {
  box-shadow: none !important;
}

.tab-background {
  border-right: 0px solid rgba(0, 0, 0, 0) !important;
  margin-left: -1px !important;
}

.tabbrowser-tab[last-visible-tab='true'] {
  padding-inline-end: 0 !important;
}

#tabs-newtab-button {
  padding-left: 0 !important;
}

/* multi tab selection */
#tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([multiselected])
  > .tab-stack
  > .tab-background:-moz-lwtheme { outline-color: var(--toolbarseparator-color) !important; }

/* remove gap after pinned tabs */
#tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab:nth-child(1 of :not([pinned], [hidden])) { margin-inline-start: 0 !important; }

/*  Removes annoying border  */
#navigator-toolbox{border:none !important;}

/*  Removes the annoying rainbow thing from the hamburger  */
#appMenu-fxa-separator{border-image:none !important;}
  '';

  userContent = ''
@-moz-document url-prefix(about:){

/*  Removes the scrollbar on some places  */
body,html{overflow-y: auto}

/*  Devtools  */
@-moz-document url-prefix(about:devtools){
#toolbox-container{margin-top: 10px !important}
.devtools-tabbar{background: transparent !important}
.devtools-tab-line{border-radius: 0 0 5px 5px}
.customize-animate-enter-done,.customize-menu,.top-site-outer:hover,button{background-color: transparent!important}}

/*  Newtab  */
@-moz-document url("about:home"), url("about:newtab"){
.search-wrapper .search-handoff-button .fake-caret {top: 13px !important; inset-inline-start: 48px !important}
.search-wrapper .logo-and-wordmark{opacity: 0.9 !important; order: 1 !important; margin-bottom: 0 !important; flex: 1 !important; flex-basis: 20% !important}
.search-wrapper .search-handoff-button .fake-caret{top: 13px !important; inset-inline-start: 48px !important}
.search-wrapper .logo-and-wordmark{opacity: 0.9 !important; order: 1 !important; margin-bottom: 0 !important; flex: 1 !important; flex-basis: 20% !important}
.outer-wrapper .search-wrapper{padding: 0px !important; display: flex !important; flex-direction: row !important; flex-wrap: wrap !important; justify-content: center !important; align-items: center !important; align-content: space-around !important; gap: 20px 10px !important}
.search-wrapper .logo-and-wordmark .logo{background-size: 60px !important; height: 60px !important; width: 60px !important}
.search-wrapper .search-inner-wrapper{min-height: 42px !important; order: 2 !important; flex: 3 !important; flex-basis: 60% !important; top: 4px !important}
.search-wrapper .search-inner-wrapper{min-height: 42px !important; order: 2 !important; flex: 3 !important; flex-basis: 60% !important; top: 4px !important}
.outer-wrapper.ds-outer-wrapper-breakpoint-override.only-search.visible-logo{display: flex !important; padding-top: 0px !important;vertical-align: middle}
.customize-menu{border-radius: 10px 0 0 10px !important}
#root > div{align-items: center; display: flex}}}
  '';

  settings = {
    "content.notify.interval" = 100000;
    "gfx.canvas.accelerated.cache-items" = 4096;
    "gfx.canvas.accelerated.cache-size" = 512;
    "gfx.content.skia-font-cache-size" = 20;
    "browser.cache.jsbc_compression_level" = 3;
    "media.memory_cache_max_size" = 65536;
    "media.cache_readahead_limit" = 7200;
    "media.cache_resume_threshold" = 3600;
    "image.mem.decode_bytes_at_a_time" = 32768;
    "network.http.max-connections" = 1800;
    "network.http.max-persistent-connections-per-server" = 10;
    "network.http.max-urgent-start-excessive-connections-per-host" = 5;
    "network.http.pacing.requests.enabled" = false;
    "network.dnsCacheExpiration" = 3600;
    "network.ssl_tokens_cache_capacity" = 10240;
    "network.dns.disablePrefetch" = true;
    "network.dns.disablePrefetchFromHTTPS" = true;
    "network.prefetch-next" = false;
    "network.predictor.enabled" = false;
    "network.predictor.enable-prefetch" = false;
    "layout.css.grid-template-masonry-value.enabled" = true;
    "dom.enable_web_task_scheduling" = true;
    "dom.security.sanitizer.enabled" = true;
    "browser.contentblocking.category" = "strict";
    "urlclassifier.trackingSkipURLs" = "*.reddit.com = *.twitter.com = *.twimg.com = *.tiktok.com";
    "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com = *.twitter.com = *.twimg.com";
    "network.cookie.sameSite.noneRequiresSecure" = true;
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.uitour.enabled" = false;
    "privacy.globalprivacycontrol.enabled" = true;
    "security.OCSP.enabled" = 0;
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.pki.crlite_mode" = 2;
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.xul.error_pages.expert_bad_cert" = true;
    "security.tls.enable_0rtt_data" = false;
    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "browser.sessionstore.interval" = 60000;
    "privacy.history.custom" = true;
    "browser.urlbar.trimHttps" = true;
    "browser.search.separatePrivateDefault.ui.enabled" = true;
    "browser.urlbar.update2.engineAliasRefresh" = true;
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.quicksuggest.enabled" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.groupLabels.enabled" = false;
    "browser.formfill.enable" = false;
    "security.insecure_connection_text.enabled" = true;
    "security.insecure_connection_text.pbmode.enabled" = true;
    "network.IDN_show_punycode" = true;
    "dom.security.https_first" = true;
    "dom.security.https_first_schemeless" = true;
    "signon.formlessCapture.enabled" = false;
    "signon.privateBrowsingCapture.enabled" = false;
    "network.auth.subresource-http-auth-allow" = 1;
    "editor.truncate_user_pastes" = false;
    "security.mixed_content.block_display_content" = true;
    "pdfjs.enableScripting" = false;
    "extensions.postDownloadThirdPartyPrompt" = false;
    "network.http.referer.XOriginTrimmingPolicy" = 2;
    "privacy.userContext.ui.enabled" = true;
    "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
    "media.peerconnection.ice.default_address_only" = true;
    "browser.safebrowsing.downloads.remote.enabled" = false;
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 2;
    "permissions.manager.defaultsUrl" = "";
    "webchannel.allowObject.urlWhitelist" = "";
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data: =";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;
    "dom.private-attribution.submission.enabled" = false;
    "browser.privatebrowsing.vpnpromourl" = "";
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.preferences.moreFromMozilla" = false;
    "browser.tabs.tabmanager.enabled" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.compactmode.show" = true;
    "browser.display.focus_ring_on_anything" = true;
    "browser.display.focus_ring_style" = 0;
    "browser.display.focus_ring_width" = 0;
    "layout.css.prefers-color-scheme.content-override" = 2;
    "browser.privateWindowSeparation.enabled" = false;
    "cookiebanners.service.mode" = 1;
    "cookiebanners.service.mode.privateBrowsing" = 1;
    "full-screen-api.transition-duration.enter" = "0 0";
    "full-screen-api.transition-duration.leave" = "0 0";
    "full-screen-api.warning.delay" = -1;
    "full-screen-api.warning.timeout" = 0;
    "browser.urlbar.suggest.calculator" = true;
    "browser.urlbar.unitConversion.enabled" = true;
    "browser.urlbar.trending.featureGate" = false;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "extensions.pocket.enabled" = false;
    "browser.download.always_ask_before_handling_new_types" = true;
    "browser.download.manager.addToRecentDocs" = false;
    "browser.download.open_pdf_attachments_inline" = true;
    "browser.bookmarks.openInTabClosesMenu" = false;
    "browser.menu.showViewImageInfo" = true;
    "findbar.highlightAll" = true;
    "layout.word_select.eat_space_to_next_word" = false;
  };

  searchEngines = {
    "Brave" = {
      urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
      icon = "https://cdn.search.brave.com/serp/v1/static/brand/9b3cd14668935362449eebb1854f575091a1169bf51aba6a8c17b39f64a9d07e-favicon-16x16.png";
      definedAliases = [ "@br" ];
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
      urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
      icon = "https://wiki.nixos.org/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nw" ];
    };
  };

in {
  programs.firefox = {
    enable = true;
    # Keep the pre-26.05 profile location (silences the configPath default-change warning).
    configPath = ".mozilla/firefox";
    package = firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
    policies = {
      HttpsOnlyMode = "enabled";
      SSLVersionMin = "tls1.2";
      HardwareAcceleration = true;
      CaptivePortal = true;
      DisableProfileImport = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true; 
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DNSOverHTTPS = {
        Enabled = true;
        Locked = false;
        Fallback = false;
      };
      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };
      FirefoxSuggest = {
        WebSuggestions = true;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      PopupBlocking = {
        Default = false;
        Locked = true;
      };
      Proxy = {
        Mode = "manual";
        Locked = false;
        SOCKSProxy = "127.0.0.1:1080";
        SOCKSVersion = 5;
        Passthrough = "localhost, 127.0.0.1, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, .portal.azure.com, .microsoft.com, .microsoftonline.com, .xdaforums.com, .reddit.com, teams.microsoft.com, bleepingcomputer.com, esp-psc.mitesp.local, mybank.nationstrust.com, .bybit.com, .spotify.com, .checkpoint.com, deviantart.com";
        UseProxyForDNS = true;
      };
      ExtensionUpdate = true;
      ExtensionSettings = {
        "*".installation_mode = "allowed";

        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };

        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        "queryamoid@kaply.com" = {
          install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
    profiles = {
      "${username}" = {
        id = 0;
        name = "${username}"; 
        isDefault = true;
        search = {
          default = "Brave";
          privateDefault = "Brave";
          engines = searchEngines;
        };
        inherit settings userChrome userContent;
      };
      "${username}-work" = {
        id = 1;
        name = "${username}-work";
        search = {
          default = "Brave";
          privateDefault = "Brave";
          engines = searchEngines;
        };
        inherit settings userChrome userContent;
      };
      "Guest" = {
        id = 2;
        name = "Guest";
        search = {
          default = "Brave";
          privateDefault = "Brave";
          engines = searchEngines;
        };
      };
    };
  };
}
