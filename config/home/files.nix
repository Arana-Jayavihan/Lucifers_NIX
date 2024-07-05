{ pkgs, config, ... }:

{
  # Place Files Inside Home Directory
  home.file.".emoji".source = ./files/emoji;
  home.file.".base16-themes".source = ./files/base16-themes;
  home.file.".face".source = ./files/face.jpg; # For GDM
  home.file.".face.icon".source = ./files/face.jpg; # For SDDM
  home.file.".config/rofi/rofi.jpg".source = ./files/rofi.jpg;
  home.file.".config/starship.toml".source = ./files/starship.toml;
  home.file.".config/swaylock-bg.jpg".source = ./files/media/swaylock-bg.jpg;
  home.file.".config/ascii-neofetch".source = ./files/ascii-neofetch;
  home.file.".config/ascii-fastfetch".source = ./files/ascii-fastfetch;

  # Directories
  home.file.".local/share/fonts" = {
    source = ./files/fonts;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ./files/wlogout;
    recursive = true;
  };
  home.file.".config/obs-studio" = {
    source = ./files/obs-studio;
    recursive = true;
  };

  # Text Source Files
home.file.".mozilla/firefox/profiles.ini".text = ''
[Profile0]
Name=LuC1F3R
IsRelative=1
Path=LuC1F3R
Default=1

[General]
StartWithLastProfile=1
Version=2
'';
home.file.".mozilla/firefox/LuC1F3R/user.js".text = ''
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.capacity", 524288);
user_pref("browser.sessionstore.interval", 15000000);
user_pref("accessibility.force_disabled", 1);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.uitour.enabled", false);

/*** STARTUP ***/

/* set startup page
 * 0=blank, 1=home, 2=last visited page, 3=resume previous session*/
//user_pref("browser.startup.page", 1);
/* set HOME+NEWWINDOW page
 * about:home=Firefox Home, custom URL, about:blank*/
//user_pref("browser.startup.homepage", "about:home");
/* disable sponsored content on Firefox Home (Activity Stream)
 * [SETTING] Home>Firefox Home Content ***/
user_pref("browser.newtabpage.activity-stream.showSponsored", false); // [FF58+] Pocket > Sponsored Stories
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // [FF83+] Sponsored shortcuts
/* clear default topsites
 * [NOTE] This does not block you from adding your own ***/
user_pref("browser.newtabpage.activity-stream.default.sites", "");



/*** QUIETER FOX ***/

/* disable recommendation pane in about:addons (uses Google Analytics) ***/
user_pref("extensions.getAddons.showPane", false); // [HIDDEN PREF]
/* recommendations in about:addons' Extensions and Themes panes [FF68+] ***/
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
/* personalized Extension Recommendations in about:addons and AMO [FF65+]
 * https://support.mozilla.org/kb/personalized-extension-recommendations ***/
user_pref("browser.discovery.enabled", false);

/** TELEMETRY ***/

/* disable new data submission */
user_pref("datareporting.policy.dataSubmissionEnabled", false);
/* disable Health Reports */
user_pref("datareporting.healthreport.uploadEnabled", false);
/* 0332: disable telemetry */
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
/* disable Telemetry Coverage */
user_pref("toolkit.telemetry.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.opt-out", true); // [FF64+] [HIDDEN PREF]
user_pref("toolkit.coverage.endpoint.base", "");
/* disable PingCentre telemetry (used in several System Add-ons) [FF57+] */
user_pref("browser.ping-centre.telemetry", false);
/* disable Firefox Home (Activity Stream) telemetry ***/
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabledFirstsession", false);
user_pref("browser.vpn_promo.enabled", false);

/** STUDIES ***/

/* disable Studies ***/
user_pref("app.shield.optoutstudies.enabled", false);
/* disable Normandy/Shield [FF60+]
 * Shield is a telemetry system that can push and test "recipes" ***/
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/** CRASH REPORTS ***/

/* disable Crash Reports ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
/* enforce no submission of backlogged Crash Reports [FF58+]
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send backlogged crash reports  ***/
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

/** OTHER ***/

/* 0360: disable Captive Portal detection
 * [1] https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy ***/
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
/* disable Network Connectivity checks
 * [1] https://bugzilla.mozilla.org/1460537 ***/
user_pref("network.connectivity-service.enabled", false);

/*** [GEOLOCATION / LANGUAGE / LOCALE ***/

/* use Mozilla geolocation service instead of Google.*/
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
/* disable using the OS's geolocation service ***/
user_pref("geo.provider.ms-windows-location", false); // [WINDOWS]
user_pref("geo.provider.use_corelocation", false); // [MAC]
user_pref("geo.provider.use_gpsd", false); // [LINUX]
user_pref("geo.provider.use_geoclue", false); // [FF102+] [LINUX]

/*** disable search suggest ***/
//user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
//user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

/*** disable autofill ***/
//user_pref("browser.formfill.enable", false);
//user_pref("signon.autofillForms", false);
//user_pref("signon.formlessCapture.enabled", false);

// Integrated calculator at urlbar
user_pref("browser.urlbar.suggest.calculator", true);

'';
home.file.".mozilla/firefox/LuC1F3R/chrome/userChrome.css".text = ''
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

/* animation and effect */
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
home.file.".mozilla/firefox/LuC1F3R/chrome/userContent.css".text = ''
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
}
