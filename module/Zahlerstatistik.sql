select sum(betrag) as Summe from journal
left join personen on personen.PersonenID=Journal.PersonenID
where Buchungsjahr = :BJahr and Journal.PersonenID <> 0 and ((SachkontoNr = 84) or (SachkontoNr = 85))
group by Journal.personenID
order by Summe