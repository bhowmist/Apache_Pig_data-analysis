text_raw = load '/data/twitter/' as (raw: chararray);

tweets =foreach text_raw generate REGEX_EXTRACT(raw, 'created_at":"([^"]+)"',1) as created_at,REGEX_EXTRACT(raw, 'created_at":"([^ ]+) ',1) as wday,REGEX_EXTRACT(raw, ' (\\d\\d):\\d\\d:\\d\\d',1) as hday, REGEX_EXTRACT(raw, '"text":"([^"]+)"',1) as text, REGEX_EXTRACT(raw, '"id_str":"(\\d+)","name"',1) as id;

prezono = filter tweets by id == '211178363';

tweet_count = foreach prezono generate hday;

hour_count = group tweet_count by hday parallel 24;

hour_count2 = foreach hour_count generate $0 as hour,COUNT(tweet_count) as count;

dump hour_count2;

STORE hour_count2 INTO 'hour_count';



