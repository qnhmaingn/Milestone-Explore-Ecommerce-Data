-- QUESTION 1
SELECT 
       FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
       SUM(totals.visits) AS visits,
       SUM(totals.pageviews) AS pageviews,
       SUM(totals.transactions) AS transactions

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` 
WHERE _table_suffix BETWEEN'0101' AND'0331'
GROUP BY month
ORDER BY month;
--QUESTION 2
SELECT
    trafficSource.source as source,
    sum(totals.visits) as total_visits,
    sum(totals.Bounces) as total_no_of_bounces,
    (sum(totals.Bounces)/sum(totals.visits))* 100.00 as bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY source
ORDER BY total_visits DESC;

 --QUESTION 3-- Revenue by traffic source by MONTH
SELECT
  'Month' AS time_type,
  FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time,
  trafficSource.source AS source,
  ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
  UNNEST(hits) AS h,
  UNNEST(h.product) AS product
WHERE
  product.productRevenue IS NOT NULL
GROUP BY
  1, 2, 3  -- tương ứng: time_type, time, source

UNION ALL

-- Revenue by traffic source by WEEK
SELECT
  'Week' AS time_type,
  FORMAT_DATE('%Y%W', PARSE_DATE('%Y%m%d', date)) AS time,
  trafficSource.source AS source,
  ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
  UNNEST(hits) AS h,
  UNNEST(h.product) AS product
WHERE
  product.productRevenue IS NOT NULL
GROUP BY
  1, 2, 3
ORDER BY
  time_type, time;
 -- QUERY 04: Average number of pageviews
-- by purchaser type (purchasers vs non-purchasers)
-- Period: June & July 2017
-- ============================================

with 
purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  and product.productRevenue is not null
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  and product.productRevenue is null
  group by month
)

select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
full join non_purchaser_data using(month)
order by pd.month;

 -- QUERY 05: Average number of transactions per purchaser (July 2017)
-- ============================================
select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    sum(totals.transactions)/count(distinct fullvisitorid) as Avg_total_transactions_per_user
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    ,unnest (hits) hits,
    unnest(product) product
where  totals.transactions>=1
and product.productRevenue is not null
group by month;
-- Query 06: Average amount of money spent per session (purchasers only)
select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    ((sum(product.productRevenue)/sum(totals.visits))/power(10,6)) as avg_revenue_by_user_per_visit
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  ,unnest(hits) hits
  ,unnest(product) product
where product.productRevenue is not null
  and totals.transactions>=1
group by month;
--query 7
-- subquery:
select
    product.v2productname as other_purchased_product,
    sum(product.productQuantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
where fullvisitorid in (select distinct fullvisitorid
                        from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
                        unnest(hits) as hits,
                        unnest(hits.product) as product
                        where product.v2productname = "YouTube Men's Vintage Henley"
                        and product.productRevenue is not null
                        AND totals.transactions>=1)
  and product.v2productname != "YouTube Men's Vintage Henley"
  and product.productRevenue is not null
  AND totals.transactions>=1
group by other_purchased_product
order by quantity desc;

-- CTE:

with buyer_list as(
    SELECT
        distinct fullVisitorId  
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    , UNNEST(hits) AS hits
    , UNNEST(hits.product) as product
    WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
    AND totals.transactions>=1
    AND product.productRevenue is not null
)

SELECT
  product.v2ProductName AS other_purchased_products,
  SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
JOIN buyer_list using(fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
 and product.productRevenue is not null
 AND totals.transactions>=1
GROUP BY other_purchased_products
ORDER BY quantity DESC;

-- query 8
with
product_view as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_product_view
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '2'
  GROUP BY 1
),

add_to_cart as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_addtocart
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '3'
  GROUP BY 1
),

purchase as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '6'
  and product.productRevenue is not null   --phải thêm điều kiện này để đảm bảo có revenue
  group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month;
