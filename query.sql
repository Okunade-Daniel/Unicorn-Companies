WITH comp_cte AS (SELECT industry, company_id, EXTRACT(YEAR FROM date_joined) as year
FROM industries
LEFT JOIN  dates
USING(company_id)
WHERE EXTRACT(YEAR FROM date_joined) IN (2019,2020,2021)),

unicorn_count AS (SELECT industry, COUNT(c.company_id) as num_unicorns
FROM comp_cte as c
GROUP BY industry
ORDER BY num_unicorns DESC
LIMIT 3)

SELECT u.industry, c.year, COUNT(c.company_id) as num_unicorns,
ROUND(AVG(valuation)/1000000000, 2) as average_valuation_billions
FROM unicorn_count as u
LEFT JOIN comp_cte as c
ON u.industry = c.industry
LEFT JOIN funding as f
ON c.company_id = f.company_id
GROUP BY u.industry,c.year,num_unicorns
ORDER BY u.industry, c.year DESC, num_unicorns DESC
