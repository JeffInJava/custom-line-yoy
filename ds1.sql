with tp1 as
(
  select line_id,stmt_day,start_time,sum(enter_times) enter_times,sum(exit_times) exit_times,sum(change_times) change_times from
  (
    select line_id,case when substr(start_time,1,2)<'02' then to_char(to_date(stmt_day,'yyyyMMdd')-1,'yyyyMMdd') else stmt_day end stmt_day,
    case when substr(start_time,1,2)<'02' then 'a'||start_time else start_time end start_time,enter_times,exit_times,change_times from
    (
        select ${m_cur_date}||'' stmt_day,line_id,substr(start_time,9,2)||lpad(trunc(substr(start_time,11,2)/${m_selType},0)*${m_selType},2,'0') start_time,
             case when 1 in (${m_flag}) then sum(enter_times) / 100 else 0 end enter_times,
             case when 2 in (${m_flag}) then sum(exit_times) / 100 else 0 end exit_times,
             case when 3 in (${m_flag}) then sum(change_times) / 100 else 0 end change_times from tbl_metro_fluxnew_${m_cur_date}
        where ticket_type not in (40, 41, 130, 131, 140, 141) 
        group by line_id,substr(start_time,9,2)||lpad(trunc(substr(start_time,11,2)/${m_selType},0)*${m_selType},2,'0')
        union all
        select ${m_next_date1} stmt_day,line_id,substr(start_time,9,2)||lpad(trunc(substr(start_time,11,2)/${m_selType},0)*${m_selType},2,'0') start_time,
             case when 1 in (${m_flag}) then sum(enter_times) / 100 else 0 end enter_times,
             case when 2 in (${m_flag}) then sum(exit_times) / 100 else 0 end exit_times,
             case when 3 in (${m_flag}) then sum(change_times) / 100 else 0 end change_times from tbl_metro_fluxnew_${m_next_date}
        where ticket_type not in (40, 41, 130, 131, 140, 141)
        group by line_id,substr(start_time,9,2)||lpad(trunc(substr(start_time,11,2)/${m_selType},0)*${m_selType},2,'0')
        union all
        select stmt_day,line_id,substr(start_time,9,2)||lpad(trunc(substr(start_time,11,2)/${m_selType},0)*${m_selType},2,'0') start_time,
             case when 1 in (${m_flag}) then sum(enter_times) / 100 else 0 end enter_times,
             case when 2 in (${m_flag}) then sum(exit_times) / 100 else 0 end exit_times,
             case when 3 in (${m_flag}) then sum(change_times) / 100 else 0 end change_times 
        from tbl_metro_fluxnew_history
        where stmt_day between ${m_start_date1} and ${m_cur_next} and stmt_day<>${m_next_date1} 
        group by stmt_day,line_id,substr(start_time,9,2)||lpad(trunc(substr(start_time,11,2)/${m_selType},0)*${m_selType},2,'0')
     )
  ) t1 group by line_id,stmt_day,start_time
  
),
nm as
(select count(*) n from (select stmt_day from tp1 group by stmt_day))
select to_char(to_date(replace(start_time,'a',''),'hh24:mi'),'hh24:mi')||'~'||to_char(to_date(replace(start_time,'a',''),'hh24:mi')+${m_selType}/60/24,'hh24:mi') start_time,
start_time start_time_order,line_id,round(sum(enter_times)/(${m_avg_total})) enter_times,
round(sum(exit_times)/(${m_avg_total})) exit_times,round(sum(change_times)/(${m_avg_total})) change_times,
round((sum(enter_times)+sum(exit_times)+sum(change_times))/(${m_avg_total})) total_times from tp1
group by start_time,line_id
