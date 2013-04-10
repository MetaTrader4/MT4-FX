
Standard Pivot Points (Mode = 0)

R3 = H + 2( PP - L )
R2 = PP+ ( H - L )
R1 = ( 2 x PP ) - L
PP = ( H + L + C ) / 3
S1 = ( 2 x PP ) - H
S2 = PP - ( H - L )
S3 = L - 2( H - PP )

Fibonacci Pivot Points (Mode = 1)

R3 = PP + ((H - L) x 1.000)
R2 = PP + ((H - L) x 0.618)
R1 = PP + ((H - L) x 0.382)
PP = (H + L + C) / 3
S1 = PP - ((H - L) x 0.382)
S2 = PP - ((H - L) x 0.618)
S3 = PP - ((H - L) x 1.000)


extern string    PP_Information = "--- Shadi_PivotPoints ---";
extern string    PP_AdvisorName = "Shadi_PivotPoints";         // For Logging.
extern string PP_AdvisorVersion = "1.1";                       // The version number of this script.
extern int       PP_BarsToCount = 0;                           // Set to 0 to count all bars, if >0, set more to calculate more bars
extern int              PP_Mode = 0;                           // 0 = Standard, 1 = Fibonacci.
extern bool     PP_IgnoreSunday = true;                        // If ignore sunday bar.
extern string         PP_Adjust = "0,0,0,0,0,0,0";             // In Pips. Corresponding to PP, S1, R1, S2, R2, S3, R3.
extern bool           PP_Expand = true;                        // If expand the lines.
extern string    PP_Expand_Show = "1,1,1,1,1,1,1";             // 1 = Show, 0 = Hide. A helper for making buy/sell adjust pairt to make some line disappear.
extern bool         PP_AutoPips = true;                        // Auto fit Digits.


double pp[7];

for (i = 0; i < 7; i++)
{
    pp[i] = iCustom(NULL, 0, PP_AdvisorName, PP_Information, PP_AdvisorName, PP_AdvisorVersion,
            PP_BarsToCount, PP_Mode, PP_IgnoreSunday, PP_Adjust, PP_Expand, PP_Expand_Show, AutoPips, i, 0);
}


