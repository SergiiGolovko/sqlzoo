# Solutions to sqlzoo challenge
# JOIN

# Database -> UEFA EURO 2012
# game(id, mdate, stadium, team1, team2)
# goal(matchid, teamid, player, gtime)
# eteam(id, teamname, coach)

# 1. Show the matchid and player name for all goals scored by Germany.
SELECT g.matchid, g.player
FROM goal g
JOIN eteam e ON g.teamid = e.id
WHERE e.teamname = 'Germany'

# 2. Show id, stadium, team1, team2 for just game 1012
SELECT DISTINCT ga.id, ga.stadium, ga.team1, ga.team2
FROM game ga
JOIN goal go ON go.matchid = ga.id
WHERE go.matchid = 1012

# 3. Show the player, teamid, stadium and mdate and for every German goal.
SELECT go.player, go.teamid, ga.stadium, ga.mdate
FROM goal go
JOIN game ga ON go.matchid = ga.id
JOIN eteam e ON go.teamid = e.id
WHERE e.teamname = 'Germany' 

# 4. Show the team1, team2 and player for every goal scored by a player called Mario.
SELECT ga.team1, ga.team2, go.player
FROM game ga
JOIN goal go ON go.matchid = ga.id
WHERE player LIKE 'Mario%'

# 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes.
SELECT go.player, go.teamid, e.coach, go.gtime
FROM goal go
JOIN eteam e ON go.teamid = e.id
WHERE go.gtime <= 10

# 6. List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT ga.mdate, e.teamname
FROM game ga
JOIN eteam e ON e.id = ga.team1
WHERE e.coach = 'Fernando Santos' 

# 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT go.player
FROM goal go
JOIN game ga ON go.matchid = ga.id
WHERE ga.stadium = 'National Stadium, Warsaw'

# 8. Show the name of all players who scored a goal against Germany
SELECT DISTINCT go.player
FROM goal go
JOIN game ga ON go.matchid = ga.id
WHERE ((go.teamid = team1) AND (team2='GER')) OR ((go.teamid = team2) AND (team1='GER')) 

# 9. Show teamname and the total number of goals scored.
SELECT e.teamname, COUNT(e.teamname)
FROM eteam e 
LEFT JOIN goal go ON (e.id=go.teamid)
GROUP BY e.teamname   
 
# 10. Show the stadium and the number of goals scored in each stadium.
SELECT ga.stadium, COUNT(go.matchid) AS ngoals
FROM game ga
LEFT JOIN goal go ON (ga.id = go.matchid)
GROUP BY ga.stadium  

# 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT go.matchid, ga.mdate, COUNT(go.matchid) AS ngoals
FROM game ga
JOIN goal go ON (ga.id = go.matchid)
WHERE (ga.team1 = 'POL') OR (ga.team2 = 'POL')
GROUP BY go.matchid, ga.mdate

# 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT go.matchid, ga.mdate, COUNT(go.matchid) AS ngoals
FROM goal go
JOIN eteam e ON (e.id = go.teamid)
JOIN game ga ON (ga.id = go.matchid)
WHERE e.teamname = 'Germany'
GROUP BY go.matchid, ga.mdate 
  

# 13. List every match with the goals scored by each team as shown: (mdate, team1, score1, team2, score2).  Sort your result by mdate, matchid, team1 and team2.
SELECT mdate, team1, SUM(score1) AS score1, team2, SUM(score2) AS score2
FROM (SELECT mdate, team1, matchid, team2, 
            CASE WHEN teamid=team1 THEN 1 ELSE 0 END score1,
            CASE WHEN teamid=team2 THEN 1 ELSE 0 END score2
            FROM game LEFT JOIN goal ON matchid = id) r
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2


