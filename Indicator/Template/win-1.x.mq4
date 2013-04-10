/**
 * MT4/MT5 Custom Programming. Contact me at: kolier.li@gmail.com
 */


//---------- Property ----------//
#property copyright "Copyright 2012, [Client] & Kolier Li."
#property link      "http://kolier.li"
// Author: Kolier Li (http://kolier.li)
// Client: [Client]
// Tags:


//---------- Change Log ----------//
/*
1. 1.0 (2012-) Initiate version.
*/


//---------- Property Settings ----------//
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_width1 1
#property indicator_color2 Red
#property indicator_width2 1


//---------- User Input ----------//
extern string  AdvisorInformation = "--- Information ---";
extern string         AdvisorName = "";     // For Logging.
extern string      AdvisorVersion = "1.0";                 // The version number of this script.


//---------- Global Constant ----------//


//---------- Global Variable ----------//
// Buffer.
double bufUp[], bufDn[];


/**
 * Event: Initiate.
 */
int init()
{
    SetIndexBuffer(0, bufUp);
    SetIndexLabel(0, "Up");
    SetIndexBuffer(1, bufDn);
    SetIndexLabel(1, "Down");
    
    return(0);
}

/**
 * Event: Deinitiate.
 */
int deinit()
{
    return(0);
}

/**
 * Event: Start.
 */
int start()
{
    return(0);
}