select distinct es1.absolute_path 'original', m.comparison_result ' ', es2.absolute_path 'match'
  from matched m, es_document es1, es_document es2
where m.same_ext_flag = 1
--  and m.comparison_result = '>'--
  and m.matcher_name = 'match_artist_album_song'
  and es1.id = m.doc_id
  and es2.id = m.match_doc_id
  and es1.absolute_path like '%.mp3'
  and es2.absolute_path like '%.mp3'
  and es2.absolute_path like '%/random%'
 order by es1.absolute_path
