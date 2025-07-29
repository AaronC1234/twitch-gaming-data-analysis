-- Find unique games in the video_play table
SELECT DISTINCT game
FROM video_play;

-- Find the most popular game  from the video_paly table and create a list of their number of viewers
SELECT game, COUNT(*)
FROM video_play
GROUP BY game
ORDER BY COUNT(*) DESC;

-- Find the most popular game (League of Legends) stream's viewers located
SELECT country, COUNT(*)
FROM video_play
WHERE game = 'League of Legends'
GROUP BY country
ORDER BY COUNT(*) DESC
LIMIT 10;

/* 
Find the number of streamers using each player platform 
(e.g., iphone_t, ipad_t, android, etc.) to understand 
which devices are most commonly used to view streams.
 */
SELECT player, COUNT(*)
FROM video_play
GROUP BY 1
ORDER BY 2 DESC;

-- Classify each game into a genre (MOBA, FPS, Survival, or Other)
SELECT game, 
 CASE
  WHEN game = 'League of Legends' 
    THEN 'MOBA'
  WHEN game = 'Dota 2'
    THEN 'MOBA'
  WHEN game = 'Hero of the Storm'
    THEN 'MOBA'
  WHEN game = 'Counter-Strike: Global Offensive'
    THEN 'FPS'
  WHEN game = 'DayZ'
    THEN 'Survival'
  WHEN game = 'ARK: Survival Evolved'
    THEN 'Survival'
  ELSE 'Other'
  END AS 'genre', 
  COUNT (*)
FROM video_play
GROUP BY 1
ORDER BY 3 DESC;

-- Combine two tables
CREATE TABLE combined_table AS
SELECT
  video_play.device_id,
  video_play.time AS video_time,
  chat.time AS chat_time,
  video_play.login AS video_login,
  chat.login AS chat_login,
  video_play.channel,
  video_play.country,
  video_play.player,
  video_play.game AS video_game,
  chat.game AS chat_game,
  video_play.stream_format,
  video_play.subscriber
FROM video_play
JOIN chat
  ON video_play.device_id = chat.device_id;

-- Identify the hour of the day when most users are watching streams, helping uncover peak traffic times.
SELECT 
  strftime('%H', time) AS hour,
  COUNT(*) AS view_count
FROM video_play
GROUP BY hour
ORDER BY view_count DESC;

-- Analyze the number of viewers and chat messages by hour to find the busiest time slots.
SELECT
  strftime('%H', video_time) AS hour,
  COUNT(DISTINCT device_id) AS viewers,
  COUNT(chat_time) AS chat_messages
FROM combined_table
GROUP BY hour
ORDER BY viewers DESC, chat_messages DESC;

-- Compare viewer counts and chat activity by device platform to find which platforms are most interactive.
SELECT
  player,
  COUNT(DISTINCT video_login) AS viewers,
  COUNT(chat_time) AS chat_messages
FROM combined_table
GROUP BY player
ORDER BY viewers DESC;

-- Compare viewer and chat activity across different game genres (MOBA, FPS, Survival, Other).
SELECT
  CASE
    WHEN video_game IN ('League of Legends', 'Dota 2', 'Hero of the Storm') THEN 'MOBA'
    WHEN video_game = 'Counter-Strike: Global Offensive' THEN 'FPS'
    WHEN video_game IN ('DayZ', 'ARK: Survival Evolved') THEN 'Survival'
    ELSE 'Other'
  END AS genre,
  COUNT(DISTINCT video_login) AS viewers,
  COUNT(chat_time) AS chat_messages
FROM combined_table
GROUP BY genre
ORDER BY viewers DESC;

-- Find the top 10 countries by average chat messages per viewer to identify the most engaged regions.
SELECT
  country,
  COUNT(DISTINCT video_login) AS viewers,
  COUNT(chat_time) AS chat_messages,
  ROUND(COUNT(chat_time) * 1.0 / NULLIF(COUNT(DISTINCT video_login), 0), 2) AS msg_per_viewer
FROM combined_table
GROUP BY country
ORDER BY msg_per_viewer DESC
LIMIT 10;

--  Identify users (login) who watched and chatted in multiple games to find your most active cross-game users.
SELECT
  video_login,
  COUNT(DISTINCT video_game) AS unique_games,
  COUNT(chat_time) AS chat_messages
FROM combined_table
GROUP BY video_login
HAVING unique_games > 1
ORDER BY unique_games DESC, chat_messages DESC
LIMIT 10;

-- Compare subscriber and non-subscriber viewer and chat activity to see if subscribers are more interactive.
SELECT
  subscriber,
  COUNT(DISTINCT video_login) AS viewers,
  COUNT(chat_time) AS chat_messages,
  ROUND(COUNT(chat_time) * 1.0 / NULLIF(COUNT(DISTINCT video_login), 0), 2) AS msg_per_viewer
FROM combined_table
GROUP BY subscriber
ORDER BY viewers DESC;

-- Analyze the top 10 channels by viewer and chat activity to find the most popular and interactive channels.
SELECT
  channel,
  COUNT(DISTINCT video_login) AS viewers,
  COUNT(chat_time) AS chat_messages,
  ROUND(COUNT(chat_time) * 1.0 / NULLIF(COUNT(DISTINCT video_login), 0), 2) AS msg_per_viewer
FROM combined_table
GROUP BY channel
ORDER BY viewers DESC
LIMIT 10;