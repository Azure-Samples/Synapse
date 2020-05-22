SELECT author, COUNT(*) AS Number_Of_Mentions
FROM dbo.mentions
WHERE mention = 'MikeDoesBigData'
GROUP BY author
ORDER BY Number_Of_Mentions DESC;