=== Types
* Support
* Resistant

=== Format Factors
--- Support
* Within a specific period.
* Start from the lowest point within the period as the first point.
* Connect the second low point after the first point which make the line not cross any subsequent candles body.


=== Event
--- Support
* Cross and New Low
    When have new low, only spot the point, and wait to see if the next candle have a lower low, if it just form a higher low, can draw the new Support trend line.
* Corss


=== Formula
* y = a * x + b
* Bars_N


=== Procedure
* Initiate the first possible trendline.
* Keep checking if cross
    * Yes, if need to form a new trendline
        * Yes, initiate the nearest trendline.
        * No, move the second point to it.
    * No, next.


=== API ===
* fxTrendLine();