{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;
in {
  home.file.".config/vesktop/themes/theme.css".text = ''
  /**
 * @name midnight
 * @description A dark, rounded discord theme.
 * @author refact0r
 * @version 1.6.2
 * @invite nz87hXyvcy
 * @website https://github.com/refact0r/midnight-discord
 * @source https://github.com/refact0r/midnight-discord/blob/master/midnight.theme.css
 * @authorId 508863359777505290
 * @authorLink https://www.refact0r.dev
*/

/* IMPORTANT: make sure to enable dark mode in discord settings for the theme to apply properly!!! */

@import url('https://refact0r.github.io/midnight-discord/midnight.css');

/* customize things here */
:root {
	/* font, change to 'gg sans' for default discord font*/
	--font: 'JetBrainsMono Nerd Font';

	/* top left corner text */
	--corner-text: 'Midnight';

	/* color of status indicators and window controls */
	--online-indicator: var(--accent-2); /* change to #23a55a for default green                   #52c9e0*/
	--dnd-indicator: hsl(340, 60%, 60%); /* change to #f13f43 for default red                     #d65c85*/
	--idle-indicator: hsl(50, 60%, 60%); /* change to #f0b232 for default yellow                  #d6c25c*/
	--streaming-indicator: hsl(260, 60%, 60%); /* change to #593695 for default purple            #855cd6*/

        /* accent colors */
        
	/* --accent-1: hsl(190, 70%, 60%); links                                                      #52c9e0 */
	/* --accent-2: hsl(190, 70%, 48%); general unread/mention elements                            #25b4d0*/
	/* --accent-3: hsl(190, 70%, 42%); accent buttons                                             #209db6*/
	/* --accent-4: hsl(190, 70%, 36%); accent buttons when hovered                                #1c879c*/
	/* --accent-5: hsl(190, 70%, 30%); accent buttons when clicked                                #177082*/
	/* --mention: hsla(190, 80%, 52%, 0.1); mentions & mention messages */
        /* --mention-hover: hsla(190, 80%, 52%, 0.05); mentions & mention messages when hovered */
        --accent-1: #${palette.base0A};
        --accent-2: #${palette.base09};
        --accent-3: #${palette.base08};
        --accent-4: #${palette.base07};
        --accent-5: #${palette.base06};
        --mention: #${palette.base02};
        --mention-hover: #${palette.base0A};

	/* text colors */
	--text-0: white; /* text on colored elements */
	--text-1: var(--text-2); /* other normally white text                                         #9facc6*/
	--text-2: #${palette.base0A}; /* headings and important text                                  #9facc6*/
	--text-3: #${palette.base09}; /* normal text                                                  #8a94a8*/
	--text-4: #${palette.base07}; /* icon buttons and channels                                    #576175*/
	--text-5: #${palette.base06}; /* muted channels/chats and timestamps                          #363d49*/

	/* background and dark colors */
	--bg-1: #${palette.base01}; /* dark buttons when clicked                                      #2b303b*/
	--bg-2: #${palette.base02}; /* dark buttons                                                   #23272f*/
	--bg-3: #${palette.base00}; /* spacing, secondary elements                                    #1c1f26*/
	--bg-4: #${palette.base00}; /* main background color                                          #16181d*/
	--hover: hsla(230, 20%, 40%, 0.1); /* channels and buttons when hovered                       #52587a*/  
	--active: hsla(220, 20%, 40%, 0.2); /* channels and buttons when clicked or selected          #525f7a*/
	--message-hover: hsla(220, 0%, 0%, 0.1); /* messages when hovered                             #000000*/

	/* amount of spacing and padding */
	--spacing: 12px;

	/* animations */
	/* ALL ANIMATIONS CAN BE DISABLED WITH REDUCED MOTION IN DISCORD SETTINGS */
	--list-item-transition: 0.2s ease; /* channels/members/settings hover transition */
	--unread-bar-transition: 0.2s ease; /* unread bar moving into view transition */
	--moon-spin-transition: 0.4s ease; /* moon icon spin */
	--icon-spin-transition: 1s ease; /* round icon button spin (settings, emoji, etc.) */

	/* corner roundness (border-radius) */
	--roundness-xl: 22px; /* roundness of big panel outer corners */
	--roundness-l: 20px; /* popout panels */
	--roundness-m: 16px; /* smaller panels, images, embeds */
	--roundness-s: 12px; /* members, settings inputs */
	--roundness-xs: 10px; /* channels, buttons */
	--roundness-xxs: 8px; /* searchbar, small elements */

	/* direct messages moon icon */
	/* change to block to show, none to hide */
	--discord-icon: none; /* discord icon */
	--moon-icon: block; /* moon icon */
	--moon-icon-url: url('https://upload.wikimedia.org/wikipedia/commons/c/c4/Font_Awesome_5_solid_moon.svg'); /* custom icon url */
	--moon-icon-size: auto;

	/* filter uncolorable elements to fit theme */
	/* (just set to none, they're too much work to configure) */
	--login-bg-filter: saturate(0.3) hue-rotate(-15deg) brightness(0.4); /* login background artwork */
	--green-to-accent-3-filter: hue-rotate(56deg) saturate(1.43); /* add friend page explore icon */
	--blurple-to-accent-3-filter: hue-rotate(304deg) saturate(0.84) brightness(1.2); /* add friend page school icon */
}
'';
}

