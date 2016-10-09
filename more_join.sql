# Solutions to sqlzoo challenge
# Self JOIN

# Database -> Movie Database
# movie(id, title, yr, director, budget, gross)
# actor(id, name)
# casting(movieid, actorid, ord)


# comment -> ord = 1 implies actor was a star (leading actor)		

# Harder Questions

# 12. Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT m.yr AS "Year", COUNT(m.title) AS "COUNT"
FROM actor a
JOIN casting c ON a.id = c.actorid
JOIN movie m ON m.id = c.movieid
WHERE (a.name = 'John Travolta')
GROUP BY (m.yr)
HAVING (COUNT(m.title) > 2)

# 13. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT m.title, a.name
FROM actor a
JOIN casting c ON a.id = c.actorid
JOIN movie m ON m.id = c.movieid
WHERE (c.ord = 1) AND (m.id IN (SELECT m1.id
                                FROM movie m1
                                JOIN casting c1 ON m1.id = c1.movieid
                                JOIN actor a1 ON a1.id = c1.actorid
                                WHERE a1.name = 'Julie Andrews'))
									
# 14. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT a.name 
FROM actor a
JOIN casting c ON a.id = c.actorid
WHERE c.ord = 1
GROUP BY a.name
HAVING COUNT(c.movieid) >= 30
ORDER BY a.name

# 15. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) AS cast
FROM movie JOIN casting ON id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY cast DESC, title

# 16. List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT a1.name
FROM actor a1
JOIN casting c1 ON a1.id = c1.actorid
WHERE (a1.name <> 'Art Garfunkel') AND (c1.movieid IN (SELECT m.id
                                                       FROM movie m 
                                                       JOIN casting c2 ON m.id = c2.movieid
                                                       JOIN actor a2 ON a2.id = c2.actorid
                                                       WHERE a2.name = 'Art Garfunkel'))
