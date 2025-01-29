--1. count the number of movies vs TV shows
select * from netflix;

select 
	distinct type
from netflix;

select 
	type, 
	count(*) as total_content
from netflix
group by type;

--2 find the most common rating for movies and tv shows

select 
	type, 
	rating,
	count(*)
from netflix
group by 1, 2
order by 1, 3 desc;


select 
	type, 
	rating
from
(
	select 
		type, 
		rating,
		count(*),
		rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by 1, 2
) as t1
where ranking = 1;


-- 3. list all movies released in specific year (e.g 2020)
select * from netflix
where
type = 'Movie'
and 
release_year = 2020;

-- 4. find the top 5 countries with most content on Netflix

select 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;


select 
	unnest(string_to_array(country, ',')) as new_country
from netflix;

-- 5 identify the longest movie or tv show

select * from netflix
where 
	type = 'Movie'
	and
	duration = (select max(duration) from netflix)

-- question 6  find the content added in the last 5 years 
select * 
from netflix
where 
	to_date(date_added, 'month dd, yyyy') >= current_date - interval '5 years'

--questions 7 find all movies/TV shows by Bruno Garotti
select * from netflix 
where 
	director = 'Bruno Garotti'

select * from netflix 
where director like '%Rajiv Chilaka%'


--question 8 list all tv shows with more than 5 seasons
select type, title, duration from netflix
where 
	type = 'TV Show'
	and
	split_part(duration, ' ', 1) ::numeric > 5

	--questions 9 count the number of content items in each genre
select 
	unnest(string_to_array(listed_in, ' , ')) as genre,
	count(show_id) as total_content
from netflix 
group by 1 

-- question 10 find the average release year for content produced in a specific country
select 
	extract(year from to_date(date_added, 'month dd, yyy')) as year, 
	count(*) as yearly_content, 
	round(
	count(*)::numeric/(select count(*) from netflix where country = 'Nigeria')::numeric * 100, 2) as avg_content
from netflix
where country = 'Nigeria'
group by 1

--question 11 list all movies that are documentatries 
select title, show_id, listed_in
from netflix
where listed_in like '%Documentaries%' 

--12 find all content without a director
select * from netflix 
where director is null

--13 find how many movies actor salman khan appeared
select * from netflix
where casts like '%Salman Khan%'
and 
release_year > extract(year from current_date) - 10

--14 find the top 10 actors who have appeared in the highest number of movies produced
select  
	unnest(string_to_array(casts, ',')) as actors,
	count(*) as total_movies
from netflix
where country like '%Nigeria%'
group by 1
order by 2 desc
limit 10

--15 categorize the content based on the prescene of the keywords 'kill' and 'violence' in the description filed 
with new_table as 
(
select *,
case
when 
	description like '%kill%' or
	description like '%violence%' then 'bad_movie'
	else 'Good_movie'
	end category
from netflix
)
 select category, 
 count(*) as total_content
 from new_table
 group by 1
	



