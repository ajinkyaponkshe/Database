USE ig_clone; 


# 1 Create a SQL Query to return the 5 oldest users within the sample database 
Select username
from users
order by created_at 
limit 5;

# 2 Create a SQL Query to return the most popular registration date 
select date_1, count(date_1) as popular_dates from (select substr(created_at,1,10) as date_1 from users) as a
group by 1
having count(date_1) > 1
order by count(date_1) desc;

#  Create a SQL Query to return all users without any photos---
select a.username
from users as a
left join photos as b
on a.id = b.user_id
where b.image_url is Null;

# 4 Create a SQL Query to return the most popular photo and the user who posted it 
Select e.username, d.photo_id
from (select c.user_id, b.photo_id
from (select a.photo_id, count(a.photo_id) as freq from likes as a
group by 1
order by 2 desc
limit 1) as b
left join photos as c
on b.photo_id = c.id) as d
left join users as e
on d.user_id = e.id;

# 5 Create a SQL Query to calculate average number of photos per user 
select round(count(id)/count(distinct image_url),2) as average from
(select a.id, b.image_url from users as a
left join photos as b
on a.id = b.user_id) as c;

#6 Create a SQL Query to return the ten most popular hashtags 
Select b.tag_name
from (select tag_id, count(photo_id) as count1 from photo_tags
group by 1
order by 2 desc
limit 10) as a
left join tags as b
on a.tag_id = b.id;

# 7 Create a SQL Query to return the users who have liked every single photo 
Select c.username
from (select user_id
from likes
group by 1
having count(photo_id) in (select count(id) from photos as a)) as b
left join users as c
on b.User_id = c.id;

