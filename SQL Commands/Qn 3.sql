SELECT * 
FROM
(
SELECT
m.MovieGenre,
CASE 
	WHEN datename(dw,s.ShowingDate) = 'Saturday' THEN 'Weekend'
	WHEN datename(dw,s.ShowingDate) = 'Sunday' THEN 'Weekend'
	ELSE 'Weekday'
END
AS WeekDayOrEnd
, 
SUM(st.SalesTransactionTotalPrice) AS Total
FROM
	Movie m, SalesFT sft, SalesTransaction st, Showing s
WHERE
	m.MovieID = sft.MovieID AND sft.SalesTransactionID = st.SalesTransactionID AND sft.ShowingID = s.ShowingID
GROUP BY m.MovieGenre, s.ShowingDate
) temp
PIVOT(SUM(Total) for WeekDayOrEnd in([Weekend],[Weekday])) as salespivot
