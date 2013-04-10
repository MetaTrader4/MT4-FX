// Buy/Sell, Entry/Exit.
datetime time_phase[2,2]; // Don't need phase, time already stands for phase, if not, will be zero.
datetime time_trade[2,2];
datetime time_trade_start[2,2];

1. Set time_trade_start if allow new phase.
2. Check if
    1) time_phase > time_phase_start (New signal after allow new order).
    2) time_trade_start > time_trade (Not traded signal).
3. Trade and set time_trade.


Use local time_check to check bar_open limit.