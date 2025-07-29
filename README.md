# twitch-gaming-data-analysis

This project analyzes Twitch stream viewing and chat behavior using SQL.  
The dataset contains two tables: stream view data and chat log data (800,000 rows, from a public sample).

## Project Features

- Multi-table join and exploratory data analysis (EDA)
- User and channel engagement analysis
- Time-based, platform-based, and regional activity breakdown
- SQL queries for actionable insights

## Dataset

- `video_play.csv`: Stream viewing data
- `chat.csv`: Chat room usage data

## How to Use

1. Import `video_play.csv` and `chat.csv` into your preferred SQL database (SQLite, DuckDB, etc.).
2. Use the provided `analysis.sql` for all main queries.
3. Reproduce the analyses or build your own!

## Example SQL

```sql
-- Analyze viewer and chat activity by hour
SELECT strftime('%H', video_time) AS hour,
       COUNT(DISTINCT device_id) AS viewers,
       COUNT(chat_time) AS chat_messages
FROM combined_table
GROUP BY hour
ORDER BY viewers DESC, chat_messages DESC;

