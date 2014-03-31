SELECT a.State,c.CinemaID, SUM(st.SalesTransactionTotalPrice) AS Total, RANK() OVER (PARTITION BY a.State ORDER BY SUM(st.SalesTransactionTotalPrice) DESC) AS [Rank]
FROM
SalesFT sft, Cinema c, [Address] a, SalesTransaction st
WHERE
	sft.CinemaID = c.CinemaID
	AND sft.SalesTransactionID = st.SalesTransactionID
	AND DATEPART(YEAR,st.SalesTransactionDate) = 2013
	AND a.AddressID = c.AddressID
GROUP BY a.State,c.CinemaID