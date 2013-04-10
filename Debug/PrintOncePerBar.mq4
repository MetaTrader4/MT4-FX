
void PrintOncePerBar(string text)
{
    static datetime time_print_once_per_bar = 0;
    if (time_print_once_per_bar < Time[0])
    {
        time_print_once_per_bar = Time[0];
        Print(text);
    }
}