-- Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?
WITH pulocationid_sum AS (
	SELECT "PULocationID", SUM(total_amount) AS day_sum
	FROM green_tripdata
	WHERE DATE(lpep_pickup_datetime) = '2025-11-18'
	GROUP BY "PULocationID" 
)
SELECT "Zone", "Borough", service_zone, day_sum
FROM taxi_zone_lookup t JOIN pulocationid_sum p ON p."PULocationID" = t."LocationID"
ORDER BY day_sum DESC;

-- East Harlem North


-- For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

-- Note: it's tip , not trip. We need the name of the zone, not the ID.
WITH grouped_tripdata_zone AS (
	SELECT 
		g."PULocationID",
		g."DOLocationID",
		g.tip_amount,
		pu."Zone" AS pickup_zone,
		d."Zone" AS drop_zone
	FROM green_tripdata g JOIN taxi_zone_lookup pu ON g."PULocationID" = pu."LocationID" 
		JOIN taxi_zone_lookup d ON g."DOLocationID" = d."LocationID"
	WHERE (lpep_pickup_datetime >= '2025-11-01' AND lpep_pickup_datetime < '2025-12-01')
)
SELECT MAX(pickup_zone), drop_zone, MAX(tip_amount) AS max_tip
FROM grouped_tripdata_zone
WHERE pickup_zone = 'East Harlem North'
GROUP BY drop_zone
ORDER BY max_tip DESC;

