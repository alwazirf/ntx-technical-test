'''I used the PostgreSQL database to solve this problem'''

-- **Test Case 1: Channel Analysis**
SELECT e.country, 
       e."channelGrouping", 
       SUM(e."totalTransactionRevenue") AS total_revenue
FROM public.ecommerce_test e
WHERE e."totalTransactionRevenue" IS NOT NULL
  AND e.country IN (
    SELECT country
    FROM public.ecommerce_test
    WHERE "totalTransactionRevenue" IS NOT NULL
    GROUP BY country
    ORDER BY SUM("totalTransactionRevenue") DESC
    LIMIT 5
) -- sub query untuk mencari 5 negara dengan totalTransactionRevenue teratas
GROUP BY e.country, e."channelGrouping"
ORDER BY total_revenue DESC;

-- **Test Case 2: User Behavior Analysis**
SELECT 
    user_level."fullVisitorId",
    user_level.avg_time_on_site,
    user_level.avg_pageviews,
    user_level.avg_session_quality
FROM 
    (
        -- Subquery untuk mencari avg level user
        SELECT 
            "fullVisitorId",
            SUM("timeOnSite") / COUNT(*) AS avg_time_on_site,
            SUM("pageviews") / COUNT(*) AS avg_pageviews,
            SUM("sessionQualityDim") / COUNT(*) AS avg_session_quality
			
        FROM public.ecommerce_test
        GROUP BY "fullVisitorId"
    ) user_level, 
	(
		-- Subquery untuk mencari overall
		SELECT
			AVG(avg_time_on_site) AS overall_avg_time_on_site,
			AVG(avg_pageviews) AS overall_avg_pageviews
		FROM
			(SELECT 
	            SUM("timeOnSite") / COUNT(*) AS avg_time_on_site,
	            SUM("pageviews") / COUNT(*) AS avg_pageviews
	        FROM public.ecommerce_test
	        GROUP BY "fullVisitorId")
	) overall_level

-- cek filter user level > overall time on site dan pageview user < pageview overall 
WHERE 
    user_level.avg_time_on_site > overall_level.overall_avg_time_on_site
    AND user_level.avg_pageviews < overall_level.overall_avg_pageviews
ORDER BY user_level.avg_time_on_site DESC;

-- **Test Case 3: Product Performance**
SELECT "v2ProductName",
	COALESCE(SUM("totalTransactionRevenue"), 0) AS total_revenue,
	COALESCE(SUM(CAST("itemQuantity" AS int)), 0) AS total_quantity_sold,
	COALESCE(SUM(CAST("productRefundAmount" AS int)), 0) AS total_refund_amount,
	COALESCE(SUM("totalTransactionRevenue"), 0) - COALESCE(SUM(CAST("productRefundAmount" AS int)), 0) AS net_revenue,
	CASE
		-- saat productRefundAmount diatas 10% maka ditandai
		WHEN COALESCE(SUM(CAST("productRefundAmount" AS int)), 0) > 0.1 * COALESCE(SUM("totalTransactionRevenue"), 0)
			THEN 'Flagged' 
	        ELSE 'Not Flagged'
		END AS refund_flag
FROM public.ecommerce_test
GROUP BY "v2ProductName"
ORDER BY net_revenue DESC

--data yang digunakan pada kolom itemQuantity dan productRefundAmount = null maka hasil yang diperoleh tidak ada refund produk yang melebihi total pendapatan
