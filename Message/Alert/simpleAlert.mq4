// Alerts & Emails
extern string Alert_And_Mail = "--- Alerts & Mails ---";
extern bool          AlertOn = true;                     // Whether turn on Alert.
extern bool     AlertMessage = true;                     // Whether make the alert in the alerts MT4 message box window.
extern bool      AlertWindow = false;                    // Alert in single window.
extern bool       AlertSound = false;                    // Whether play sound.
extern string      SoundFile = "alert.wav";              // Play which file as "sound".
extern bool           MailOn = false;                    // Whether send mail.

// extern bool  AlertAtBarOpen = false;                     // Whether alert at bar open, if false, would alert immediately when it signals

/**
 * Alert function.
 */
void fxAlert(int op_type)
{
    string message = "";

    if (op_type == OP_BUY)
    {
        message = StringConcatenate(AdvisorName, "-", Symbol(), "-", fxTF2String(Period()), "-", TimeToStr(TimeCurrent(), TIME_SECONDS), "-Buy-", Ask);
    }
    else if (op_type == OP_SELL)
    {
        message = StringConcatenate(AdvisorName, "-", Symbol(), "-", fxTF2String(Period()), "-", TimeToStr(TimeCurrent(), TIME_SECONDS), "-Sell-", Bid);
    }

    if(AlertMessage)
    {
        Alert(message);
    }
    if(AlertWindow)
    {
        MessageBox(message, AdvisorName + "-"+ Symbol() + "-" + fxTF2String(Period()), 0x00000000);
    }
    if(AlertSound)
    {
        PlaySound(SoundFile);
    }
    if(MailOn)
    {
        SendMail(message, message);
    }
}

/**
 * Return the string format timeframe.
 */  
string fxTF2String(int tf, bool cap=true)
{
    string tf_str[5];
    tf_str[0] = "mn";
    tf_str[1] = "w";
    tf_str[2] = "d";
    tf_str[3] = "h";
    tf_str[4] = "m";
    if (cap)
    {
        tf_str[0] = "MN";
        tf_str[1] = "W";
        tf_str[2] = "D";
        tf_str[3] = "H";
        tf_str[4] = "M";
    }
    
    int tfs[5];
    tfs[0] = PERIOD_MN1;
    tfs[1] = PERIOD_W1;
    tfs[2] = PERIOD_D1;
    tfs[3] = PERIOD_H1;
    tfs[4] = PERIOD_M1;
    
    // Calculate
    string ret = "";
    int ret_p[5];
    ArrayInitialize(ret_p, 0);
    int i;
    int tf_now = tf;
    for (i = 0; i < 5; i++)
    {
        if (i == 0)
        {
            ret_p[i] = MathFloor(tf_now / tfs[i]);
        }
        else
        {
            tf_now = MathMod(tf, tfs[i-1]);
            ret_p[i] = MathFloor(tf_now / tfs[i]);
        }
    }
    
    // Format output
    int counter = 0;
    for (i = 0; i < 5; i++)
    {
        // @debug
        //Print(ret_p[i]);
        if (ret_p[i] > 0)
        {
            if (counter > 0)
            {
                ret = StringConcatenate(ret, " ");
            }
            ret = StringConcatenate(ret, tf_str[i], ret_p[i]);
            counter++;
        }
    }
    
    return (ret);
}