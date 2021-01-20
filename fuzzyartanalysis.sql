USE fuzzyart;

SELECT
	utm_content, 
	utm_source, 
	utm_campaign
FROM website_sessions
GROUP BY 1,2,3;

-- Which search engines/sources are sending visitors to the website?
SELECT 
	utm_source,
	COUNT(DISTINCT website_session_id) AS sessions, 
	ROUND(count(*) *100.0/sum(count(*)) OVER(),2) percentage_of_total
FROM website_sessions
GROUP BY utm_source
ORDER BY percentage_of_total DESC;

-- What are the best channels to drive traffic to the website?
SELECT 
	utm_content, 
	COUNT(DISTINCT website_session_id) AS sessions,
	ROUND(count(*) *100.0/sum(count(*)) OVER (),2) percentage_of_total
FROM website_sessions
GROUP BY
	utm_content    
ORDER BY percentage_of_total DESC;
   
    
-- display the conversion rate by umt_source
SELECT 
	utm_source,
	COUNT(DISTINCT website_sessions.website_session_id) AS count_of_session,
	COUNT(DISTINCT orders.order_id) AS count_of_order,
	COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rt
FROM website_sessions
LEFT JOIN orders
    on orders.website_session_id = website_sessions.website_session_id
GROUP By 1
ORDER By conv_rt desc;       
    
 -- display the top pages in a descending order
SELECT
	pageview_url,
	COUNT(DISTINCT website_pageview_id) AS num_of_page_view
FROM website_pageviews
GROUP BY 
	pageview_url
ORDER BY 
	num_of_page_view desc;   
    
-- display the montly and weekly session 

SELECT 
	YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mo,
	min(date(website_sessions.created_at)) as week_start,
	COUNT(website_sessions.website_session_id) As ct_of_session
FROM website_sessions
GROUP BY 1,2, week(created_at)
ORDER BY week_start;

-- session by device type
 SELECT 
	device_type,
	count(Distinct website_session_id) AS sessions,
	ROUND(count(*) *100.0/sum(count(*)) OVER(),2) percentage_of_total
 FROM website_sessions
 GROUP BY device_type; 


-- display the monthly sessions by utm_source for 2019
SELECT 
	YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mo,
	COUNT(CASE WHEN utm_source='gsearch' THEN website_sessions.website_session_id ELSE NULL END) as gsearch_paid_session,
	COUNT(CASE WHEN utm_source='bsearch' THEN website_sessions.website_session_id ELSE NULL END) as bsearch_paid_session,
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_search_session,
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS dire_type_session
FROM website_sessions
LEFT JOIN orders
	on orders.website_session_id = website_sessions.website_session_id
WHERE year(website_sessions.created_at) ='2019'
GROUP BY 1,2;


-- display % of total sesions for each utm_source for 2019
SELECT 
	YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mo,
	FORMAT(COUNT(CASE WHEN utm_source='gsearch' THEN website_sessions.website_session_id ELSE NULL END) /COUNT( website_sessions.website_session_id *100),2) AS gsearch_of_total,
	FORMAT(COUNT(CASE WHEN utm_source='bsearch' THEN website_sessions.website_session_id ELSE NULL END) /COUNT( website_sessions.website_session_id *100),2) AS bsearch_of_total,
	FORMAT(COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) /COUNT(website_sessions.website_session_id *100),2) AS organi_search_of_total,
	FORMAT(COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) /COUNT( website_sessions.website_session_id *100),2) AS dire_search_of_total
FROM website_sessions
LEFT JOIN orders
	on  orders.website_session_id =website_sessions.website_session_id
WHERE year(website_sessions.created_at)='2019'
GROUP BY 1,2;
   
  
-- What is the session to order conversion rate by month?  
SELECT 
	YEAR(website_sessions.created_at) as yr,	
	MONTH(website_sessions.created_at) as mo,
	COUNT(DISTINCT website_sessions.website_session_id) As count_of_session,
	COUNT(DISTINCT orders.order_id) as count_of_order,      
	FORMAT(COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) *100,2) AS session_conv_rt 
FROM website_sessions
LEFT JOIN orders
	on website_sessions.website_session_id = orders.website_session_id
GROUP BY 1,2
ORDER BY session_conv_rt desc;    
     
   
    

 
 











