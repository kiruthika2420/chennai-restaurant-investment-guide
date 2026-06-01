USE zomato_project;
SELECT DATABASE();
select count(*) from zomato_cuisine_exploded;
SHOW TABLES;
-- Q1: Top 10 Most Popular Cuisines
-- Finding: Chinese (3430) and North Indian (3163) dominate, South Indian 4th (2912)
-- Surprising: Chinese beats South Indian in Chennai despite being a South Indian city
-- Opportunity: Biryani (1807) has strong demand with potentially less competition than Chinese
select cuisine_list,count(*) as popular_cuisines
from zomato_cuisine_exploded
group by cuisine_list
order by popular_cuisines desc
limit 10;
-- Q2: Top 15 Areas by Restaurant Count and Avg Rating
-- Finding: Central and South Chennai areas have highest restaurant density
select location,count(*) as restaurant_count ,avg(dining_rating),avg(delivery_rating)
from zomato_restaurants
where dining_rating > 0 or delivery_rating > 0
group by location
order by restaurant_count desc
limit 15;
-- Q3: Price Category Performance
-- Finding: Mid Range is sweet spot — 3.60 dining, 3.85 delivery at lower investment than Premium
select price_category,avg(case when dining_rating > 0 then dining_rating else null end) as avg_dining_rating,
AVG(case when delivery_rating > 0 then delivery_rating else null end) as avg_delivery_rating
from zomato_restaurants
group by price_category 
order by avg_dining_rating desc;
-- Q4: Delivery vs Dine-in Performance
-- Finding: Both model dominates (4244 restaurants) with 3.47 dining and 3.84 delivery rating
-- Delivery Only scores 3.73 vs Dine-in Only 3.25 — delivery experience rated higher by customers
-- Recommendation: Launch with Both services, prioritize delivery quality
select case when has_dine_in = 1 and has_delivery = 1 then 'Both'
            when has_dine_in = 1 and has_delivery = 0 then 'Dine-in Only'
            when has_dine_in = 0 and has_delivery =1 then 'Delivery_only'
           else 'Neither'
       end as 'Service_Model',
count(*) as restaurant_count,
avg(case when dining_rating > 0 then dining_rating else null end) as avg_dining_rating,
avg(case when delivery_rating > 0 then delivery_rating else null end) as avg_delivery_rating
from zomato_restaurants
group by Service_Model
order by restaurant_count desc;
-- Q5: Best Cuisine + Area Combination
-- Finding: Rolls+Egmore (4.90), Bakery+Royapettah (4.77), Healthy Food+Thousand Lights (4.60 delivery)
-- Insight: Niche cuisines in specific areas outperform mass cuisines
select e.cuisine_list,
r.location,
count(*)as restaurant_count,
avg(case when r.dining_rating > 0 then r.dining_rating else null end) as avg_dining_rating,
avg(case when r.delivery_rating > 0 then r.delivery_rating else null end) as avg_delivery_rating
from zomato_cuisine_exploded e join zomato_restaurants r on e.name = r.name
group by e.cuisine_list,r.location
having count(*)>=10
order by avg_dining_rating desc 
limit 20;





