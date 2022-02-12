select journal.betrag,
       ifnull((strftime('%Y', 'now') - strftime('%Y', personen.Geburtstag)), -1) as age
from journal
left join personen on journal.PersonenID=Personen.PersonenID
where (journal.PersonenID != 0) and (Buchungsjahr=:BJahr)
order by age