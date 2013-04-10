Logic:
    Continue changing channel, when price touch the upper or lower will draw
    an arrow to mark it.
    Trend, direction of the channel change frequently.
    
Deviation:
    [custom]
    WinfriedHuf_SHI_Channel_true
        1. Top; 2. Bottom; 3. Center as Top; 4. Center as Bottom.

// SHI_Channel_true
extern string SHIC_Indicator = "SHI_Channel_true";
extern int      SHIC_AllBars = 240;
extern int SHIC_BarsForFract = 0;


// SHI_Channel_true
extern string SHIC_Indicator = "WinfriedHuf_SHI_Channel_true";
extern int      SHIC_AllBars = 240;
extern int SHIC_BarsForFract = 0;

double shic_t, shic_b, shic_ct, shic_cb;

shic_t = iCustom(NULL, 0, SHIC_Indicator, SHIC_AllBars, SHIC_BarsForFract, 0, 1);
shic_b = iCustom(NULL, 0, SHIC_Indicator, SHIC_AllBars, SHIC_BarsForFract, 1, 1);
shic_ct = iCustom(NULL, 0, SHIC_Indicator, SHIC_AllBars, SHIC_BarsForFract, 2, 1);
shic_cb = iCustom(NULL, 0, SHIC_Indicator, SHIC_AllBars, SHIC_BarsForFract, 3, 1);