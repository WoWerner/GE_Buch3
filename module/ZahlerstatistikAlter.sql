select journal.betrag,
       (strftime('%Y', 'now') - strftime('%Y', personen.Geburtstag)) as age
       from journal
left join personen on journal.PersonenID=Personen.PersonenID
where Buchungsjahr=:BJahr and
      Journal.SachkontoNr=84 and
      age <> ''
order by age