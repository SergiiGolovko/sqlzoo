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

# 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop IN (SELECT id
				 FROM stops s
			 	 WHERE s.name = 'Craiglockhart')
AND b.stop IN (SELECT id 
               FROM stops s
		       WHERE s.name = 'London Road')
			   
# 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name='London Road'

# 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON 
	(a.company = b.company AND a.num = b.num)
WHERE (a.stop = 115) AND (b.stop = 137) 

# 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON 
	(a.company = b.company AND a.num = b.num)
WHERE a.stop IN (SELECT id
  				 FROM stops s
			     WHERE s.name='Craiglockhart')
AND b.stop IN (SELECT id
               FROM stops s
		       WHERE s.name='Tollcross') 

# 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

SELECT DISTINCT s.name, a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
             JOIN stops s ON (s.id = b.stop)
WHERE a.stop IN (SELECT id
                 FROM stops
			     WHERE name = 'Craiglockhart')
AND a.company='LRT' 

# 10. Find the routes involving two buses that can go from Craiglockhart to Sighthill. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.

# route a -> begin, stop s -> transfer stop, b -> end 
SELECT DISTINCT a.num, a.company, s.name, c.num, c.company 
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
			 JOIN stops s ON (s.id = b.stop)
			 JOIN route c ON (s.id = c.stop)
			 JOIN route d ON (c.company = d.company AND c.num = d.num)
WHERE a.stop IN (SELECT id
			     FROM stops
			     WHERE name = 'Craiglockhart')
AND d.stop IN (SELECT id
               FROM stops
		       WHERE name = 'Sighthill')
AND b.stop IN (SELECT id 
               FROM stops
		       WHERE name NOT IN ('Craiglockhart', 'Sighthill'))
ORDER BY LENGTH(a.num), a.num, s.id, LENGTH(b.num), b.num