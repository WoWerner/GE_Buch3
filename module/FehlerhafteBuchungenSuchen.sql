select LaufendeNr,
       journal.Konto_nach,
       journal.BankNr,
       Journal.PersonenID,
       ifnull(personen.Nachname,'')||', '||ifnull(personen.Vorname,'') as Name
from journal
left join personen on personen.PersonenID=Journal.PersonenID
where (Buchungsjahr = :BJahr) and
      ((journal.Konto_nach not in (select konten.KontoNr from konten)) or
       (journal.BankNr not in (select konten.KontoNr from konten)) or
       ((Journal.PersonenID not in (select personen.PersonenID from Personen)) and (Journal.PersonenID > 0)))
order by LaufendeNr