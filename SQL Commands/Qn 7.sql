SELECT a.State,m.MovieID,DATEPART(YEAR,st.SalesTransactionDate) AS Year,SUM(st.SalesTransactionTotalPrice) AS Total
FROM
	SalesFT sft, SalesTransaction st, Cinema c, [Address] a,
	(SELECT mv.*
	FROM Person p, Director d, Movie mv
	WHERE p.PersonID = d.PersonID
	AND p.Name = 'Christopher Nolan'
	AND d.MovieID = mv.MovieID) m
WHERE
	sft.SalesTransactionID = st.SalesTransactionID
	AND c.CinemaID = sft.CinemaID
	AND a.AddressID = c.AddressID
	AND m.MovieID = sft.MovieID
GROUP BY CUBE(DATEPART(YEAR,st.SalesTransactionDate),a.State,m.MovieID)