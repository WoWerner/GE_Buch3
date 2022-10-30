select distinct
   trim(Buchungstext) 
from
   journal 
where
   (
      length(Buchungstext) < 30
   )
   and 
   (
      Datum > date('now', 'start of year', '-1 year')
   )
   and 
   (
      instr(Buchungstext, strftime('%Y', 'now')) = 0
   )
   and 
   (
      instr(Buchungstext, substr(strftime('%Y', 'now'), 3, 2)) = 0
   )
   and 
   (
      instr(Buchungstext, strftime('%Y', 'now', 'start of year', '-1 year')) = 0
   )
   and 
   (
      instr(Buchungstext, substr(strftime('%Y', 'now', 'start of year', '-1 year'), 3, 2)) = 0
   )
   and 
   (
      instr(Buchungstext, 'SVWZ') = 0
   )
order by
   upper(trim(Buchungstext))