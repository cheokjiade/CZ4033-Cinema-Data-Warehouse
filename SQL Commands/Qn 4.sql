SELECT * 
FROM
(
	SELECT c.CustomerGender, p.PromotionDescription, SUM(st.SalesTransactionTotalPrice) AS Total
	FROM
		SalesFT sft, Promotion p, Customer c, SalesTransaction st
	WHERE
		sft.PromotionID = p.PromotionID
		AND sft.CustomerID = c.CustomerID
		AND sft.SalesTransactionID = st.SalesTransactionID
		AND DATEPART(YEAR,st.SalesTransactionDate) = 2013
	GROUP BY CUBE(c.CustomerGender, p.PromotionDescription)
) temp
PIVOT(SUM(Total) FOR CustomerGender in([M],[F])) as salespivot