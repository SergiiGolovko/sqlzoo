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


