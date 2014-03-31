SELECT * FROM
(
SELECT c.CustomerGender, s.TimeOfTheDay, COUNT(s.TimeOfTheDay) AS TicketsSold
FROM 
	SalesFT sft, Customer c,

	(SELECT *, TimeOfTheDay = CASE 
		WHEN DATEPART(hour, ShowingTime) BETWEEN 5 AND 12 THEN 'Morning' 
		WHEN DATEPART(hour, ShowingTime) BETWEEN 13 AND 17 THEN 'Afternoon' 
		WHEN DATEPART(hour, ShowingTime) BETWEEN 18 AND 22 THEN 'Evening'
		WHEN DATEPART(hour, ShowingTime) BETWEEN 23 AND 24 THEN 'Night' 
		WHEN DATEPART(hour, ShowingTime) BETWEEN 0 AND 4 THEN 'Night' 
	END 
	FROM Showing) s
WHERE
	sft.ShowingID = s.ShowingID
	AND sft.CustomerID = c.CustomerID
	AND DATEPART(YEAR, s.ShowingDate) = 2013
GROUP BY CUBE(c.CustomerGender, s.TimeOfTheDay)
) temp
PIVOT(SUM(TicketsSold) FOR CustomerGender in([M],[F])) as salespivot