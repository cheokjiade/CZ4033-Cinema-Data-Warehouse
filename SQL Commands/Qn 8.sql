SELECT *
FROM
(
	SELECT m.MovieGenre, c.CustomerGender, SUM(st.SalesTransactionTotalPrice) AS Total
	FROM
		SalesFT sft, Customer c, SalesTransaction st,
		(SELECT mv.* FROM
		Person p, Star s, Movie mv
		WHERE p.Name = 'Tom Hanks'
		AND p.PersonID = s.PersonID
		AND s.MovieID = mv.MovieID) m
	WHERE
		st.SalesTransactionID = sft.SalesTransactionID
		AND sft.MovieID = m.MovieID
		AND c.CustomerID = sft.CustomerID
	GROUP BY CUBE(m.MovieGenre,c.CustomerGender)
) temp
PIVOT(SUM(Total) FOR CustomerGender in([M],[F])) as salespivot