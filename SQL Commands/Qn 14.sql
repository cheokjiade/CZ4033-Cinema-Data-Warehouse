SELECT * FROM
(
	SELECT c.CustomerGender, m.MovieTitle, RANK() OVER(PARTITION BY c.CustomerGender ORDER BY COUNT(sft.TicketID) DESC) AS RankByTickets FROM
		SalesFT sft, Customer c, Movie m, SalesTransaction st
	WHERE
		sft.MovieID = m.MovieID
		AND sft.CustomerID =c.CustomerID
		AND sft.SalesTransactionID = st.SalesTransactionID
		AND DATEPART(YEAR,st.SalesTransactionDate) = 2010
	GROUP BY c.CustomerGender, m.MovieTitle
) temp
WHERE temp.RankByTickets <=10;

SELECT c.CustomerGender, m.MovieTitle, COUNT(sft.TicketID) FROM
	SalesFT sft, Customer c, Movie m, SalesTransaction st
WHERE
	sft.MovieID = m.MovieID
	AND sft.CustomerID =c.CustomerID
	AND sft.SalesTransactionID = st.SalesTransactionID
		AND DATEPART(YEAR,st.SalesTransactionDate) = 2010
GROUP BY c.CustomerGender, m.MovieTitle
