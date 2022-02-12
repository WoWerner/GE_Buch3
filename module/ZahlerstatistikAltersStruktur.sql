select personen.Vorname,
       ifnull((strftime('%Y', 'now') - strftime('%Y', personen.Geburtstag)), -1) as age
from personen
where personen.Gemeindeglied
order by age