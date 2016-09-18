# Solutions to sqlzoo challenge
# Self JOIN

# Database -> Edinburgh Busses 
# stops(id, name)
# route(num,company,pos, stop) 

# 1. How many stops are in the database.
SELECT COUNT(*) AS N_STOPS
FROM stops

# 2. Find the id value for the stop 'Craiglockhart'
SELECT id 
FROM stops 
WHERE name = 'Craiglockhart'

# 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT s.id, s.name
FROM stops s 
JOIN route r 
ON (s.id = r.stop)
WHERE (r.num = 4) AND (r.company = 'LRT')  

# 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

# 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT 