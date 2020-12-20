-- Query returns total flyinghours and flyinghours ranking for each owner per
-- day between 2019-12-01 and 2020-11-30 inclusive.
SELECT
	generate_series::DATE AS datadate,
	owner,
	flyinghours,
	ranking
FROM
	-- Generate date range for data analysis.
	GENERATE_SERIES('2019-12-01', '2020-11-30', '1 day'::INTERVAL)

	-- LEFT JOIN date range above with traffic data ensures no dates are missed and
	-- removes incomplete data from 2019-11-30 (otherwise data would be returned on
	-- 2019-11-30 from flights that started on 2019-11-30 and ended on 2019-12-01).
	LEFT JOIN

		-- Aggregated table (subq2) contains total flyinghours and flyinghours ranking
		-- for each owner per day.
		(SELECT
			datadate,
			NULLIF(owner, '') AS owner,
			SUM(flyinghours) AS flyinghours,
			RANK() OVER(PARTITION BY datadate ORDER BY SUM(flyinghours) DESC) AS ranking
		FROM

			(
				-- UNIONed table (subq1) contains flyinghours per day and owner for each flight.
				-- First table in UNION contains flyinghours up until end of day latest for each
				-- flight. Second table in UNION contains remaining flyinghours on the next day
				-- for flights that span multiple days.
				((SELECT
					firstseen::DATE AS datadate,
					icao24,
					CASE
						WHEN firstseen::DATE != lastseen::DATE
						THEN EXTRACT(EPOCH FROM
							(DATE_TRUNC('day', firstseen) + '1 day - 1 sec'::INTERVAL - firstseen)) / 3600
						ELSE EXTRACT(EPOCH FROM (lastseen - firstseen)) / 3600
					END flyinghours
				FROM traffic)

				UNION ALL -- Performance benefit not using UNION which checks for duplicates

				(SELECT
					lastseen::DATE AS datadate,
					icao24,
					EXTRACT(EPOCH FROM
						(lastseen - DATE_TRUNC('day', lastseen))) / 3600 AS flyinghours
				FROM traffic
				WHERE firstseen::DATE != lastseen::DATE)) AS subq1

			LEFT JOIN 
				aircraft
			ON subq1.icao24 = aircraft.icao24)

		GROUP BY datadate, NULLIF(owner, '')) AS subq2

	ON generate_series::DATE = datadate

WHERE ranking IN (1, 2, 3, 4) -- Return only top 4 ranking owners per day
ORDER BY generate_series::DATE ASC, ranking ASC;