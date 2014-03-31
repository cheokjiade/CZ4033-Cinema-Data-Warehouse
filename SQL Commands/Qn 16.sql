SELECT DATEPART(WEEK,st.SalesTransactionDate) AS Week, SUM(st.SalesTransactionTotalPrice) AS WeeklyTotal, AVG(SUM(st.SalesTransactionTotalPrice)) OVER (
	ORDER BY DATEPART(WEEK,st.SalesTransactionDate)
	ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
	) AS MovingAverage
FROM
	SalesFT sft, SalesTransaction st
WHERE
	sft.SalesTransactionID = st.SalesTransactionID
	AND DATEPART(YEAR,st.SalesTransactionDate) = 2013
GROUP BY DATEPART(WEEK,st.SalesTransactionDate)