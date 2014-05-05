//-------------
// Appearance:
//-------------

static const char font[] = "-*-terminus2-medium-r-*-*-12-*-*-*-*-*-*-*";
#define NUMCOLORS 13
static const char colors[NUMCOLORS][ColLast][9] = {
 /* <border>   <fground>  <bground> */
  { "#282a2e", "#373b41", "#1d1f21" }, // 1 = normal (grey on black)
  { "#f0c674", "#c5c8c6", "#1d1f21" }, // 2 = selected (white on black)
  { "#dc322f", "#1d1f21", "#f0c674" }, // 3 = urgent (black on yellow)
  { "#282a2e", "#282a2e", "#1d1f21" }, // 4 = darkgrey on black (triangle)
  { "#282a2e", "#1d1f21", "#282a2e" }, // 5 = black on darkgrey (triangle)
  { "#282a2e", "#b294bb", "#282a2e" }, // 6 = magenta on darkgrey
  { "#282a2e", "#cc6666", "#1d1f21" }, // 7 = red on black
  { "#282a2e", "#b5bd68", "#1d1f21" }, // 8 = green on black
  { "#282a2e", "#81a2be", "#282a2e" }, // 9 = blue on darkgrey
  { "#282a2e", "#f0c674", "#1d1f21" }, // A = yellow on black
  { "#282a2e", "#f0c674", "#282a2e" }, // B = yellow on darkgrey
  { "#282a2e", "#de935f", "#1d1f21" }, // C = orange on black
  { "#282a2e", "#8abeb7", "#282a2e" }, // D = cyan on darkgrey
};

static const unsigned int borderpx = 1;    // Border pixel of windows
static const unsigned int snap     = 8;    // snap pixel
static const Bool showbar          = True; // False means no bar
static const Bool topbar           = True; // False means bottom bar

//----------
// Tagging:
//----------

static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,            True,        -1 },
    { "Firefox",  NULL,       NULL,       1 << 1,       False,       -1 },
    { "Chromium", NULL,       NULL,       1 << 1,       False,       -1 },
    { "URxvt",    NULL,       "kbcast",   0,            True,        -1 },
};

//------------
// Layout(s):
//------------

static const float mfact      = 0.5;   // Factor of master area size [0.05..0.95]
static const int nmaster      = 2;     // Number of clients in master area
static const Bool resizehints = False; // True means respect size hints in tiled resizals

static const Layout layouts[] = {
   /* <symbol>      <arrange function> */
    { "Û É Û",      tile },    // First entry is default
    { "Û Ê Û",      NULL },    // No layout function means floating behavior
    { "Û Ë Û",      monocle },
};

//------------------
// Key definitions:
//------------------

#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

//-----------
// Commands:
//-----------

static const char  *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", colors[0][ColBG], "-nf", colors[0][ColFG], "-sb", colors[1][ColBG], "-sf", colors[1][ColFG], NULL };
static const char *termcmd[]   = { "urxvtc", NULL };
static const char *zoomin[]    = { "zoom.sh", "in", NULL };
static const char *zoomout[]   = { "zoom.sh", "out", NULL };
static const char *zoom1[]     = { "zoom.sh", "1", NULL };
static const char *zoom2[]     = { "zoom.sh", "2", NULL };
static const char *zoom3[]     = { "zoom.sh", "3", NULL };
static const char *zoom4[]     = { "zoom.sh", "4", NULL };
static const char *zoom5[]     = { "zoom.sh", "5", NULL };
static const char *zoom6[]     = { "zoom.sh", "6", NULL };
static const char *zoom7[]     = { "zoom.sh", "7", NULL };
static const char *kbcast[]    = { "kbcast.sh", NULL };

static Key keys[] = {
   /* <modifier>                    <key>      <function>      <argument> */
    { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
    { MODKEY|ControlMask,           XK_j,      spawn,          {.v = zoomin } },
    { MODKEY|ControlMask,           XK_k,      spawn,          {.v = zoomout } },
    { MODKEY|ControlMask,           XK_q,      spawn,          {.v = zoom1 } },
    { MODKEY|ControlMask,           XK_w,      spawn,          {.v = zoom2 } },
    { MODKEY|ControlMask,           XK_e,      spawn,          {.v = zoom3 } },
    { MODKEY|ControlMask,           XK_r,      spawn,          {.v = zoom4 } },
    { MODKEY|ControlMask,           XK_t,      spawn,          {.v = zoom5 } },
    { MODKEY|ControlMask,           XK_y,      spawn,          {.v = zoom6 } },
    { MODKEY|ControlMask,           XK_u,      spawn,          {.v = zoom7 } },
    { MODKEY,                       XK_minus,  spawn,          {.v = kbcast } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_y,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_o,      setmfact,       {.f = +0.05} },
    { MODKEY,                       XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

//---------------------
// Button definitions:
//---------------------

/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
   /* <click>               <event mask>    <button>        <function>      <argument> */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
