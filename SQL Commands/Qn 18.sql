SELECT * FROM
(
	SELECT *, RANK() OVER(PARTITION BY temp.State ORDER BY temp.MovingAverage DESC) AS RankByTickets FROM
	(
		SELECT a.State, DATEPART(YEAR,st.SalesTransactionDate) AS YEAR, DATEPART(WEEK,st.SalesTransactionDate) AS Week, SUM(st.SalesTransactionTotalPrice) AS WeeklyTotal, AVG(SUM(st.SalesTransactionTotalPrice)) OVER (
			PARTITION BY a.State
			ORDER BY DATEPART(WEEK,st.SalesTransactionDate)
			ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
			) AS MovingAverage
		FROM
			SalesFT sft, SalesTransaction st, Cinema c, [Address] a
		WHERE
			sft.SalesTransactionID = st.SalesTransactionID
			AND c.AddressID = a.AddressID
			AND c.CinemaID = sft.CinemaID
			AND DATEPART(YEAR,st.SalesTransactionDate) BETWEEN 2004 AND 2013
		GROUP BY a.State, DATEPART(YEAR,st.SalesTransactionDate), DATEPART(WEEK,st.SalesTransactionDate)
	)temp
) final
WHERE final.RankByTickets = 1
