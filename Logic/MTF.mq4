
0 = Current TF, 1 = M1, 5 = M5, 15 = M15, 60 = H1, 240 = H4, 1440 = D1, 10080 = W1, 43200 = MN1.


Two kinds of MTF:
-----------------

1. Bar base on current timeframe.
2. Bar base on the setted timeframe.


Value Frome Higher TimeFrame
----------------------------

In history:
While higher timeframe doesn't have history data that map to the lower timeframe bars.
Lower timeframe bars in the same period of higher timeframe may get the same value from the higher timeframe.

Now:
The higher timeframe value continue changing, the lower timeframe value follows.
This could reflect the real value of the higher timeframe.
But if the indicator is reloaded, the value may be repainted.


Internal MTF & External MTF
---------------------------

Different implementation.

Internal:
Build in iBarShift() logic.

External:
iCustom() itself.


MTF Back Fix
------------

Fix the values on bars in the same period of other timeframe.


Get Higher Timeframe Value
--------------------------

Some bars within the period of higher timeframe will be the same.


Get Lower Timeframe Value
-------------------------

1. Get the first bar value of lower timeframe.
2. Get the latest bar value of the lower timeframe.

They have their own issues.


How to Create A MTF Indicator.
------------------------------

@see MA_MTF.mq4


