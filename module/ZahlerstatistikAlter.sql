select journal.betrag,
       (strftime('%Y', 'now') - strftime('%Y', personen.Geburtstag)) as age
       from journal
left join personen on journal.PersonenID=Personen.PersonenID
where Buchungsjahr=:BJahr and age <> ''
order by age