-- 1. Revenue by Game: Which game generated the most money?

SELECT
    g.home_team || ' vs ' || g.away_team AS matchup,
    TO_CHAR(g.tipoff_time, 'YYYY-MM-DD') AS game_date,
    COUNT(ts.ticket_id) AS tickets_sold,
    TO_CHAR(SUM(ts.purchase_price), '$99,999.00') AS total_revenue
FROM Ticket_Sales ts
JOIN NBA_game g ON ts.game_id = g.game_id
GROUP BY g.home_team, g.away_team, g.tipoff_time
-- NOTE: order by the raw SUM, not the formatted string.
-- The '$'-formatted total_revenue is text, so ordering by it would sort
-- alphabetically ('$9,000.00' would come before '$10,800.50').
ORDER BY SUM(ts.purchase_price) DESC;

-- 2. VIP Customer Identification: fans who contribute the most revenue

SELECT
    f.username,
    f.email_address,
    COUNT(ts.ticket_id) AS tickets_purchased,
    TO_CHAR(SUM(ts.purchase_price), '$99,999.00') AS total_spent
FROM Fan f
JOIN Ticket_Sales ts ON f.fan_id = ts.fan_id
GROUP BY f.username, f.email_address
HAVING SUM(ts.purchase_price) > 2000
ORDER BY SUM(ts.purchase_price) DESC;

-- 3. Revenue by Seat Tier: which seating category earns the most?

SELECT
    st.tier_name,
    COUNT(ts.ticket_id) AS tickets_sold,
    TO_CHAR(SUM(ts.purchase_price), '$99,999.00') AS total_revenue,
    TO_CHAR(AVG(ts.purchase_price), '$99,999.00') AS avg_price
FROM Ticket_Sales ts
JOIN Seat_Tier st ON ts.tier_code = st.tier_code
GROUP BY st.tier_name
ORDER BY SUM(ts.purchase_price) DESC;
