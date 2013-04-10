
string phase[0];
int phase_size;

void phaseRegister(string phase_new)
{
    arrayPushString(phase, phase_new);
}

/**
 * Turn HL pattern into phase text.
 */
string phaseTextFromPattern(string side, int val)
{
    string text = "";
    if (side == "peak")
    {
        switch (val)
        {
            case 0:
                text = "All";
                break;
            case 1:
                text = "HH";
                break;
            case 2:
                text = "LH";
                break;
        }
    }
    else if (side == "through")
    {
        switch (val)
        {
            case 0:
                text = "All";
                break;
            case 1:
                text = "HL";
                break;
            case 2:
                text = "LL";
                break;
        }
    }
    
    return(text);
}

/**
 * Get the pattern form the phase.
 */
string patternFromPhase(string phase_text, string side)
{
    string text = "";
    int pos = StringFind(phase_text, "_");
    if (side == "peak")
    {
        text = StringSubstr(phase_text, 0, pos);
    }
    else if (side == "through")
    {
        text = StringSubstr(phase_text, pos + 1);
    }
    
    return(text);
}

/**
 * Module: Multiple Phase.
 */
void phaseRegister(string phase_new)
{
    arrayPushString(phase, phase_new);
}

