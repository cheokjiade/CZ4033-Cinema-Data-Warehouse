SELECT *
FROM
(
	SELECT c.CustomerGender, SUM(st.SalesTransactionTotalPrice) AS Total, COUNT(sft.TicketID) AS NumberOfTickets 
	FROM
		SalesFT sft, Customer c, SalesTransaction st
	WHERE
		sft.CustomerID = c.CustomerID
		AND sft.SalesTransactionID = st.SalesTransactionID
		AND DATEPART(YEAR,st.SalesTransactionDate) = 2013
	GROUP BY CUBE(c.CustomerGender, sft.SalesTransactionID)
) temp
PIVOT(SUM(Total) FOR CustomerGender in([M],[F])) as salespivot
