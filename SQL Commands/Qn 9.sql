SELECT
*
FROM
(
SELECT a.State,h.Size, SUM(st.SalesTransactionTotalPrice) AS Total
FROM
	SalesFT sft, Cinema c, [Address] a, SalesTransaction st,
	(SELECT HallID, Size = CASE
		WHEN HallSize BETWEEN 0 AND 10 THEN 'Small'
		WHEN HallSize BETWEEN 11 AND 20 THEN 'Medium'
		WHEN HallSize > 20 THEN 'Large'
	END FROM Hall hall
	)h
WHERE 
	sft.HallID = h.HallID
	AND sft.CinemaID = c.CinemaID
	AND c.AddressID = a.AddressID
	AND st.SalesTransactionID = sft.SalesTransactionID
	AND sft.OnlineTransactionID IS NULL
GROUP BY 
	CUBE(a.State,h.Size)
) temp
PIVOT (SUM(Total) FOR size IN ([Small],[Medium],[Large])) AS somepivot