select LaufendeNr,
       journal.Konto_nach,
       journal.BankNr,
       Journal.PersonenID,
       ifnull(Betrag/100,0) as Betrag
from journal
left join personen on personen.PersonenID = Journal.PersonenID
left join konten   on konten.KontoNr      = Journal.Konto_nach
where (Buchungsjahr = :BJahr) and
      ((journal.Konto_nach not in (select konten.KontoNr from konten)) or
       (journal.BankNr not in (select konten.KontoNr from konten)) or
       ((Journal.PersonenID not in (select personen.PersonenID from Personen)) and (Journal.PersonenID > 0)) or
       ((journal.Betrag > 0) and (konten.Kontotype = 'A')) or
       ((journal.Betrag < 0) and (konten.Kontotype = 'E')))
order by LaufendeNr