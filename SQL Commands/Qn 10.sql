SELECT
*
FROM
(
	SELECT c.CustomerGender, DATEDIFF(YEAR,c.CustomerDOB,GETDATE()) AS Age, c.CustomerAge,SUM(st.SalesTransactionTotalPrice) AS Total FROM 
		SalesFT sft, SalesTransaction st, 
		(SELECT *, CustomerAge = CASE 
			WHEN DATEDIFF(hour,CustomerDOB,GETDATE())/8766 BETWEEN 1 AND 10 THEN 'Children'
			WHEN DATEDIFF(hour,CustomerDOB,GETDATE())/8766 BETWEEN 11 AND 20 THEN 'Teenagers'
			WHEN DATEDIFF(hour,CustomerDOB,GETDATE())/8766 BETWEEN 21 AND 30 THEN 'Young Adults'
			WHEN DATEDIFF(hour,CustomerDOB,GETDATE())/8766 BETWEEN 31 AND 40 THEN 'Adults'
			WHEN DATEDIFF(hour,CustomerDOB,GETDATE())/8766 > 40 THEN 'Older Adults'
		END
		FROM Customer) c
	WHERE
		sft.SalesTransactionID = st.SalesTransactionID
		AND c.CustomerID = sft.CustomerID
		AND DATEPART(YEAR,st.SalesTransactionDate) BETWEEN 2004 AND 2013
	GROUP BY
		CUBE(c.CustomerGender),ROLLUP(DATEDIFF(YEAR,c.CustomerDOB,GETDATE()), c.CustomerAge)
)temp
PIVOT(SUM(Total) FOR  CustomerAge IN ([Children],[Teenagers],[Young Adults],[Adults],[Older Adults])) AS somepivot
