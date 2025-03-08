DROP table if exists netflix
create table netflix

(
		show_id	varchar(7),
		type varchar(7),
		title	varchar(150),
		director	varchar(209),
		casts	varchar(1000),
		country	varchar(150),
		date_added	varchar(150),
		release_year	int,
		rating	varchar(10),
		duration	varchar(15),
		listed_in	varchar(100),
		description varchar(250)
    );
	SELECT count(*) from netflix;

	--Q1) Count the number of Movies vs TV Shows
	 select * from netflix
	 Select type, count(show_id)
	 from netflix
	 group by 2

	-- Q2) List all movies released in a specific year (e.g., 2020)
				 select * from netflix
				WHERE 
				type ='Movie' 
				AND 
				release_year=2020;
--Q3)Find the top 5 countries with the most content on Netflix
select count(show_id) as total, unnest(string_to_array(country,','))
 From netflix
 Group By 2
Order BY 1 DESC
LIMIT 5;

--Q4)Identify the longest movie
select * from netflix
Where
type='Movie'
AND
duration=(select max(duration) from netflix)
--Q5) Find content added in the last 5 years
Select *from netflix
WHERE
 To_Date(date_added,'Month DD, YYYY')>= current_date - interval'5 years'

--Q6) Find all the movies/TV shows by director 'Rajiv Chilaka'!
Select * from netflix
Where director ILIKE '%Rajiv Chilaka%'

--Q7  List all TV shows with more than 5 seasons
Select * from netflix
Where type ='TV Show'
      AND
	  split_part(duration,' ',1)::numeric>5

--Q8)  Count the number of content items in each genre
Select count(show_id), unnest(string_to_array(listed_in,',')) from netflix
group by 2
--Q9 Find each year and the average numbers of content release in India on netflix.
Select Extract(year from To_Date(date_added,'month DD,YYYY')),
count(*),
round(count(*)::numeric/(select count(*) from netflix Where country ILIKE '%india%')*100::numeric,2) as avg_content_per_year
from netflix
Where country ILIKE '%INDIA%'
group by 1

--Q10 List all movies that are documentaries
 Select * from netflix
 Where type ='Movie'
    AND
	listed_in ILIKE '%Documentaries%'
--Q11 Find all content without a director
Select * from netflix
Where director is NULL
--Q12  Find how many movies actor 'Salman Khan' appeared in last 10 years!
Select * from netflix
Where casts ILIKE '%salman khan%'
AND
release_year >= EXTRACT(YEAR FROM current_date) - 10
--Q13 Find the top 10 actors who have appeared in the highest number of movies produced in India.
select unnest(string_to_array(casts,',')) as actors,
count(show_id) as Total_Movies
from netflix
where type='Movie'
AND
country ILIKE '%india%'
Group By 1
order by 2 DESC
LIMIT 10

--Q 14 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

With new_table as (
Select *, 
CASE WHEN
description ILIKE '%KILL%'
OR
description ILIKE '%violence%'
THEN 'BAD_Content'
ELSE
'GOOD_Content'
END catagory
From Netflix
)
select catagory, count(*) as total_content from new_table
group by 1