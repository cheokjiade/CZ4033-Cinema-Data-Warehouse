SELECT * FROM
(
	SELECT a.State, c.CinemaID, RANK() OVER(PARTITION BY a.State ORDER BY COUNT(sft.TicketID) DESC) AS RankByTickets FROM
		SalesFT sft, SalesTransaction st, Cinema c, [Address] a
	WHERE
		sft.CinemaID = c.CinemaID
		AND c.AddressID = a.AddressID
		AND sft.SalesTransactionID = st.SalesTransactionID
		AND DATEPART(YEAR,st.SalesTransactionDate) BETWEEN 2004 AND 2013
	GROUP BY a.State, c.CinemaID
) temp
WHERE temp.RankByTickets <=5;