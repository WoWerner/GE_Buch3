Select
  ((strftime('%Y', date('now'), 'start of month', '-1 day') * 12 +
    strftime('%m', date('now'), 'start of month', '-1 day') -
    strftime('%Y', Personen.Geburtstag) * 12 -
    strftime('%m', Personen.Geburtstag)) / 120) * 10  as Altersgruppe,
  printf("%.2f", cast(sum(Journal.betrag) as float) / 100) as Betrag,  
  count(DISTINCT Journal.PersonenID) as AnzahlZahler
from
  Journal
left join
  Personen on Journal.PersonenID=Personen.PersonenID
Where
  (Journal.PersonenID <> '' or Journal.PersonenID is not null) and
   Journal.BuchungsJahr = 2021 and
   Personen.Gemeindeglied
group by Altersgruppe
order by Altersgruppe