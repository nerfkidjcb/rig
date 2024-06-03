#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 5;	/* border pixel of windows */
static const unsigned int gappx     = 25;	/* gaps between windows */
static const unsigned int snap      = 32;	/* snap pixel */
static const int showbar            = 1;	/* 0 means no bar */
static const int topbar             = 1;	/* 0 means bottom bar */
static const int vertpad	    = 25;	/* vertical padding of bar*/
static const int sidepad	    = 25;	/* horiontal padding of bar */
static const int horizpadbar        = 25;	/* horizontal padding for statusbar */
static const int vertpadbar         = 25;	/* vertical padding for statusbar */
static const char *fonts[]	    = { "JetBrainsMono Nerd Font:weight=bold:size=16" };
static const char *colors[][3]      = {
	/*               text       container  border    */
	[SchemeNorm] = { "#ffffff", "#04070D", "#04070D" },
	[SchemeSel]  = { "#ffffff", "#0D1117", "#2F81F7"  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact	= 0.55;	/* factor of master area size [0.05..0.95] */
static const int nmaster	= 1;	/* number of clients in master area */
static const int resizehints	= 1;	/* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;	/* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* function commands */
static const char *volumeUp[]   = { "amixer", "sset", "Master", "5%+", NULL };
static const char *volumeDown[]   = { "amixer", "sset", "Master", "5%-", NULL };
static const char *volumeStatus[]   = { "pkill", "-RTMIN+1", "dwmblocks", NULL };

/* program commands */
static const char *openTerminal[]  = { "alacritty", NULL };
static const char *openBrowser[] = { "firefox", NULL };

/* utility commands */
static const char *rebootMachine[] = { "reboot", NULL };
static const char *poweroffMachine[] = { "poweroff", NULL };

static const Key keys[] = {
	/* MODIFIER			KEY				FUNCTION	ARGUMENT */

	/* functions */
    	{ 0,				XF86XK_AudioRaiseVolume,	spawn,          {.v = volumeUp } },
    	{ 0,				XF86XK_AudioRaiseVolume,	spawn,         	{.v = volumeStatus } },
    	{ 0,				XF86XK_AudioLowerVolume,	spawn,          {.v = volumeDown } },
    	{ 0,				XF86XK_AudioLowerVolume,	spawn,         	{.v = volumeStatus } },

	/* programs */
	{ MODKEY,			XK_Return,			spawn,          {.v = openTerminal } },
	{ MODKEY,			XK_p,				spawn,          {.v = openBrowser } },
	{ MODKEY,			XK_c,				killclient,     {0} },

	/* monitors */
	{ MODKEY,                       XK_comma,			focusmon,       {.i = +1 } },
	{ MODKEY,			XK_period,			tagmon,         {.i = +1 } },
	
	/* layout */
	{ MODKEY,                       XK_t,				setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,				setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,				setlayout,      {.v = &layouts[2]} },

	/* tags */
	{ MODKEY,                       XK_Tab,				view,           {0} },
	{ MODKEY,                       XK_0,				view,           {.ui = ~0 } },
	TAGKEYS(XK_1, 0)
	TAGKEYS(XK_2, 1)
	TAGKEYS(XK_3, 2)
	TAGKEYS(XK_4, 3)
	TAGKEYS(XK_5, 4)

	/* utility */
	{ MODKEY,			XK_h,				setmfact,	{.f = -0.05} },
	{ MODKEY,			XK_l,				setmfact,	{.f = +0.05} },
	{ MODKEY,			XK_b,				togglebar,      {0} },
	{ MODKEY,			XK_q,				quit,           {0} },
	{ MODKEY|ShiftMask,		XK_r,				spawn,          {.v = rebootMachine } },
	{ MODKEY|ShiftMask,		XK_q,				spawn,		{.v = poweroffMachine } },
};
		

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = openTerminal } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
