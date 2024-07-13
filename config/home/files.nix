{ ... }:
let
  inherit (import ../../options.nix) username;
in {
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
Name=${username}
IsRelative=1
Path=${username}
Default=1

[General]
StartWithLastProfile=1
Version=2
'';
home.file.".mozilla/firefox/${username}/user.js".text = ''
//␍
/* You may copy+paste this file and use it as it is.␍
 *␍
 * If you make changes to your about:config while the program is running, the␍
 * changes will be overwritten by the user.js when the application restarts.␍
 *␍
 * To make lasting changes to preferences, you will have to edit the user.js.␍
 */␍
␍
/****************************************************************************␍
 * Betterfox                                                                *␍
 * "Ad meliora"                                                             *␍
 * version: 126                                                             *␍
 * url: https://github.com/yokoffing/Betterfox                              *␍
****************************************************************************/␍
␍
/****************************************************************************␍
 * SECTION: FASTFOX                                                         *␍
****************************************************************************/␍
/** GENERAL ***/␍
user_pref("content.notify.interval", 100000);␍
␍
/** GFX ***/␍
user_pref("gfx.canvas.accelerated.cache-items", 4096);␍
user_pref("gfx.canvas.accelerated.cache-size", 512);␍
user_pref("gfx.content.skia-font-cache-size", 20);␍
␍
/** DISK CACHE ***/␍
user_pref("browser.cache.jsbc_compression_level", 3);␍
␍
/** MEDIA CACHE ***/␍
user_pref("media.memory_cache_max_size", 65536);␍
user_pref("media.cache_readahead_limit", 7200);␍
user_pref("media.cache_resume_threshold", 3600);␍
␍
/** IMAGE CACHE ***/␍
user_pref("image.mem.decode_bytes_at_a_time", 32768);␍
␍
/** NETWORK ***/␍
user_pref("network.http.max-connections", 1800);␍
user_pref("network.http.max-persistent-connections-per-server", 10);␍
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);␍
user_pref("network.http.pacing.requests.enabled", false);␍
user_pref("network.dnsCacheExpiration", 3600);␍
user_pref("network.ssl_tokens_cache_capacity", 10240);␍
␍
/** SPECULATIVE LOADING ***/␍
user_pref("network.dns.disablePrefetch", true);␍
user_pref("network.dns.disablePrefetchFromHTTPS", true);␍
user_pref("network.prefetch-next", false);␍
user_pref("network.predictor.enabled", false);␍
user_pref("network.predictor.enable-prefetch", false);␍
␍
/** EXPERIMENTAL ***/␍
user_pref("layout.css.grid-template-masonry-value.enabled", true);␍
user_pref("dom.enable_web_task_scheduling", true);␍
user_pref("dom.security.sanitizer.enabled", true);␍
␍
/****************************************************************************␍
 * SECTION: SECUREFOX                                                       *␍
****************************************************************************/␍
/** TRACKING PROTECTION ***/␍
user_pref("browser.contentblocking.category", "strict");␍
user_pref("urlclassifier.trackingSkipURLs", "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com");␍
user_pref("urlclassifier.features.socialtracking.skipURLs", "*.instagram.com, *.twitter.com, *.twimg.com");␍
user_pref("network.cookie.sameSite.noneRequiresSecure", true);␍
user_pref("browser.download.start_downloads_in_tmp_dir", true);␍
user_pref("browser.helperApps.deleteTempFileOnExit", true);␍
user_pref("browser.uitour.enabled", false);␍
user_pref("privacy.globalprivacycontrol.enabled", true);␍
␍
/** OCSP & CERTS / HPKP ***/␍
user_pref("security.OCSP.enabled", 0);␍
user_pref("security.remote_settings.crlite_filters.enabled", true);␍
user_pref("security.pki.crlite_mode", 2);␍
␍
/** SSL / TLS ***/␍
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);␍
user_pref("browser.xul.error_pages.expert_bad_cert", true);␍
user_pref("security.tls.enable_0rtt_data", false);␍
␍
/** DISK AVOIDANCE ***/␍
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);␍
user_pref("browser.sessionstore.interval", 60000);␍
␍
/** SHUTDOWN & SANITIZING ***/␍
user_pref("privacy.history.custom", true);␍
␍
/** SEARCH / URL BAR ***/␍
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);␍
user_pref("browser.urlbar.update2.engineAliasRefresh", true);␍
user_pref("browser.search.suggest.enabled", false);␍
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);␍
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);␍
user_pref("browser.formfill.enable", false);␍
user_pref("security.insecure_connection_text.enabled", true);␍
user_pref("security.insecure_connection_text.pbmode.enabled", true);␍
user_pref("network.IDN_show_punycode", true);␍
␍
/** HTTPS-FIRST POLICY ***/␍
user_pref("dom.security.https_first", true);␍
user_pref("dom.security.https_first_schemeless", true);␍
␍
/** PASSWORDS ***/␍
user_pref("signon.formlessCapture.enabled", false);␍
user_pref("signon.privateBrowsingCapture.enabled", false);␍
user_pref("network.auth.subresource-http-auth-allow", 1);␍
user_pref("editor.truncate_user_pastes", false);␍
␍
/** MIXED CONTENT + CROSS-SITE ***/␍
user_pref("security.mixed_content.block_display_content", true);␍
user_pref("security.mixed_content.upgrade_display_content", true);␍
user_pref("security.mixed_content.upgrade_display_content.image", true);␍
user_pref("pdfjs.enableScripting", false);␍
user_pref("extensions.postDownloadThirdPartyPrompt", false);␍
␍
/** HEADERS / REFERERS ***/␍
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);␍
␍
/** CONTAINERS ***/␍
user_pref("privacy.userContext.ui.enabled", true);␍
␍
/** WEBRTC ***/␍
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);␍
user_pref("media.peerconnection.ice.default_address_only", true);␍
␍
/** SAFE BROWSING ***/␍
user_pref("browser.safebrowsing.downloads.remote.enabled", false);␍
␍
/** MOZILLA ***/␍
user_pref("permissions.default.desktop-notification", 2);␍
user_pref("permissions.default.geo", 2);␍
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");␍
user_pref("permissions.manager.defaultsUrl", "");␍
user_pref("webchannel.allowObject.urlWhitelist", "");␍
␍
/** TELEMETRY ***/␍
user_pref("datareporting.policy.dataSubmissionEnabled", false);␍
user_pref("datareporting.healthreport.uploadEnabled", false);␍
user_pref("toolkit.telemetry.unified", false);␍
user_pref("toolkit.telemetry.enabled", false);␍
user_pref("toolkit.telemetry.server", "data:,");␍
user_pref("toolkit.telemetry.archive.enabled", false);␍
user_pref("toolkit.telemetry.newProfilePing.enabled", false);␍
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);␍
user_pref("toolkit.telemetry.updatePing.enabled", false);␍
user_pref("toolkit.telemetry.bhrPing.enabled", false);␍
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);␍
user_pref("toolkit.telemetry.coverage.opt-out", true);␍
user_pref("toolkit.coverage.opt-out", true);␍
user_pref("toolkit.coverage.endpoint.base", "");␍
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);␍
user_pref("browser.newtabpage.activity-stream.telemetry", false);␍
␍
/** EXPERIMENTS ***/␍
user_pref("app.shield.optoutstudies.enabled", false);␍
user_pref("app.normandy.enabled", false);␍
user_pref("app.normandy.api_url", "");␍
␍
/** CRASH REPORTS ***/␍
user_pref("breakpad.reportURL", "");␍
user_pref("browser.tabs.crashReporting.sendReport", false);␍
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);␍
␍
/** DETECTION ***/␍
user_pref("captivedetect.canonicalURL", "");␍
user_pref("network.captive-portal-service.enabled", false);␍
user_pref("network.connectivity-service.enabled", false);␍
␍
/****************************************************************************␍
 * SECTION: PESKYFOX                                                        *␍
****************************************************************************/␍
/** MOZILLA UI ***/␍
user_pref("browser.privatebrowsing.vpnpromourl", "");␍
user_pref("extensions.getAddons.showPane", false);␍
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);␍
user_pref("browser.discovery.enabled", false);␍
user_pref("browser.shell.checkDefaultBrowser", false);␍
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);␍
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);␍
user_pref("browser.preferences.moreFromMozilla", false);␍
user_pref("browser.tabs.tabmanager.enabled", false);␍
user_pref("browser.aboutConfig.showWarning", false);␍
user_pref("browser.aboutwelcome.enabled", false);␍
␍
/** THEME ADJUSTMENTS ***/␍
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);␍
user_pref("browser.compactmode.show", true);␍
user_pref("browser.display.focus_ring_on_anything", true);␍
user_pref("browser.display.focus_ring_style", 0);␍
user_pref("browser.display.focus_ring_width", 0);␍
user_pref("layout.css.prefers-color-scheme.content-override", 2);␍
user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS␍
␍
/** COOKIE BANNER HANDLING ***/␍
user_pref("cookiebanners.service.mode", 1);␍
user_pref("cookiebanners.service.mode.privateBrowsing", 1);␍
␍
/** FULLSCREEN NOTICE ***/␍
user_pref("full-screen-api.transition-duration.enter", "0 0");␍
user_pref("full-screen-api.transition-duration.leave", "0 0");␍
user_pref("full-screen-api.warning.delay", -1);␍
user_pref("full-screen-api.warning.timeout", 0);␍
␍
/** URL BAR ***/␍
user_pref("browser.urlbar.suggest.calculator", true);␍
user_pref("browser.urlbar.unitConversion.enabled", true);␍
user_pref("browser.urlbar.trending.featureGate", false);␍
␍
/** NEW TAB PAGE ***/␍
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);␍
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);␍
␍
/** POCKET ***/␍
user_pref("extensions.pocket.enabled", false);␍
␍
/** DOWNLOADS ***/␍
user_pref("browser.download.always_ask_before_handling_new_types", true);␍
user_pref("browser.download.manager.addToRecentDocs", false);␍
␍
/** PDF ***/␍
user_pref("browser.download.open_pdf_attachments_inline", true);␍
␍
/** TAB BEHAVIOR ***/␍
user_pref("browser.bookmarks.openInTabClosesMenu", false);␍
user_pref("browser.menu.showViewImageInfo", true);␍
user_pref("findbar.highlightAll", true);␍
user_pref("layout.word_select.eat_space_to_next_word", false);␍
␍
/****************************************************************************␍
 * START: MY OVERRIDES                                                      *␍
****************************************************************************/␍
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides␍
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening␍
// Enter your personal overrides below this line:␍
␍
/****************************************************************************␍
 * SECTION: SMOOTHFOX                                                       *␍
****************************************************************************/␍
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js␍
// Enter your scrolling overrides below this line:␍
␍
/****************************************************************************␍
 * END: BETTERFOX                                                           *␍
****************************************************************************/

'';
home.file.".mozilla/firefox/${username}/chrome/userChrome.css".text = ''
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
home.file.".mozilla/firefox/${username}/chrome/userContent.css".text = ''
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
