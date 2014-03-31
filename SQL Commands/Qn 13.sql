SELECT
a.[State], ol.Browser, SUM(st.SalesTransactionTotalPrice) AS Total, RANK() OVER (PARTITION BY a.[State] ORDER BY SUM(st.SalesTransactionTotalPrice)  DESC) AS Rank
FROM
	SalesFT sft, Customer c, [Address] a, OnlineTransaction ol, Cinema ci, SalesTransaction st
WHERE
	sft.CustomerID = c.CustomerID
	AND sft.OnlineTransactionID = ol.OnlineTransactionID 
	AND sft.CinemaID = ci.CinemaID
	AND ci.AddressID = a.AddressID
	AND st.SalesTransactionID = sft.SalesTransactionID
GROUP BY
	a.[State], ol.Browser