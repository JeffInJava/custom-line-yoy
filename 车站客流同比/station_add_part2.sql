SELECT *
  from (select *
           from (select sum(a.times) time1,
                         sum(a.enter_times) enter_times,
                         sum(a.exit_times) exit_times,
                         sum(a.change_times) change_times,
                         sum(b.times) time2,
                         sum(b.enter_times) en_times,
                         sum(b.exit_times) ex_times,
                         sum(b.change_times) ch_times,
                         sum(a.times) - sum(b. times) zl,
                         (sum(a.times) / sum(b.times)) - 1 zf,
                         c.station_nm_cn,
                         c.state
                    from (select station_id,
                                 sum(enter_times + change_times) / 100 times,
                                 sum(enter_times) / 100 enter_times,
                                 sum(exit_times) / 100 exit_times,
                                 sum(change_times) / 100 change_times
                            from (select station_id,
                                         substr(start_time, 9, 6) start_time,
                                         sum(enter_time s) enter_times,
                                         sum(change_times) change_times,
                                         sum(exit_times) exit_times
                                    from tbl _metro_fluxnew_20200306
                                   where ticket_type not in
                                         ('40', '41', '130', '131', '140', '141')
                                     and s
                                   tart_time >= '20200306' || '020000'
                                   group by station_id, substr(start_time, 9, 6)
                                  union all
                                  select station_id,
                                         'a' || substr(start_time, 9, 6) start_time,
                                         sum(enter _times) enter_times,
                                         sum(change_times) change_times,
                                         sum(exit_times) exit_times
                                    from tbl_metro_fluxnew_20200307
                                   where ticket_type not in
                                         ('40', '41', '130', '131', '140', '141')
                                     and start_time < '20200307' || '020000'
                                   group by station_id, substr(start_time, 9, 6))
                          
                           where (case
                                   when (substr('050000', 0, 2) = '02' or
                                        substr('090059', 0, 3) = 'a02') and
                                        (20200307 = to_char(sysdate, 'yyyyMMdd') or
                                        20200306 = to_char(sysdate, 'yyyyMMdd')) then
                                    to_char(sysdate - 30 / (24 * 60), 'hh24miss')
                                 
                                   else
                                    '090059'
                                 end) > start_time
                             and start_time > '050000'
                           group by station_id) b,
                         (select station_id,
                                  sum(enter_times + change_times) / 100 times,
                                  sum(enter_times) / 100 enter_times,
                                  sum(exit_times) / 100 exit_times,
                                  sum(change_times) / 100 change_times
                             from (select station_id,
                                          substr(start_time, 9, 6) start_time,
                                          s um(enter_times) enter_times,
                                          sum(change_times) change_times,
                                          sum(exit_times) exit_ times
                                     from tbl_metro_fluxnew_20200307
                                    where ticket_type not in
                                          ('40', '41', '130', '131', '140', '141')
                                      and start_time >= '20200307' || '020000'
                                    group by station_id, substr(start_time, 9, 6)
                                   union all
                                   select station_id,
                                          'a' || substr(start_time, 9, 6) start_t ime,
                                          sum(enter_times) enter_times,
                                          sum(change_times) change_times,
                                          sum(exit_times) exit_times
                                     from tbl_metro_fluxnew_20200308
                                    where ticket_type not in
                                          ('40', '41', '130', '131', '140', '141')
                                      and start_time < '20200308' || '020000'
                                    group by station_id, substr(start_time, 9, 6))
                            where (case
                                    when (substr('050000', 0, 2) = '02' or
                                         substr('090059', 0, 3) = 'a02') and
                                         (20200307 = to_char(sysdate, 'yyyyMMdd') o r
                                          20200306 = to_char(sysdate, 'yyyyMMdd')) then
                                     to_char(sysdate - 30 / (24 * 60),
                                             'h
h24miss')
                                    else
                                     '090059'
                                  end) > start_time
                              and start_time > '050000'
                            group by station_id) a,
                         
                         (select station_id,
                                 case
                                   when station_id in ('0418', '0631') then
                                    station_nm_cn || station_id
                                   else
                                    station_nm_cn
                                 end station_nm_cn,
                                 '1' state
                            from viw_metro_station_name
                           where station_id in
                                 (select distinct station_id
                                    from viw_metro_station_shadow
                                   where 20200307 between start_date and end_date)
                             and 20200307 between start_time and end_time
                          union all
                          select station_id,
                                 case
                                   when station_id in ('0418', '0631') then
                                    station_nm_cn || '(' || line_id || '号线)'
                                   else
                                    station_nm_cn
                                 end station_nm_cn,
                                 '2' state
                            from viw_metro_station_name
                           where station_id not in
                                 (select distinct station_id
                                    from viw_metro_station_shadow
                                   where 20200307 between start_date and end_date)
                             and 20200307 between start_time and end_time) c
                   where a.station_id = b.station_id(+)
                     and c.station_id = a.station_id
                     and (c.state = 0 or 0 = 0)
                   group by c.state, c.station_nm_cn
                  having sum(b.times) > 0)
          order by zl desc)
 WHERE rownum <= 5
