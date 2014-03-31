SELECT
details.Name, details.MovieTitle, SUM(st.SalesTransactionTotalPrice) AS Total, RANK() OVER (PARTITION BY details.Name ORDER BY SUM(st.SalesTransactionTotalPrice)  DESC) AS Rank
FROM
	SalesFT sft, SalesTransaction st, Customer c,
	(SELECT p.*,mv.*
	FROM Person p, Director d, Movie mv
	WHERE p.PersonID = d.PersonID
	AND d.MovieID = mv.MovieID) details
WHERE
	sft.CustomerID = c.CustomerID
	AND DATEDIFF(YEAR,c.CustomerDOB,st.SalesTransactionDate) < 30
	AND sft.SalesTransactionID = st.SalesTransactionID
	AND details.MovieID = sft.MovieID
GROUP BY
	details.Name, details.MovieTitle
ORDER BY details.Name