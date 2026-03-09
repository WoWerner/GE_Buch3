select konten.KontoNr as BankNr,
       SortPos,
       Statistik,
       Name,
       replace(printf('%.2f €', CAST(ifnull(bankenabschluss.Anfangssaldo, 0) AS FLOAT)/100.0), '.', ',') as StartSaldo,
       replace(printf('%.2f €', CAST(Kontostand AS FLOAT)/100.0), '.', ',') as Kontostand
from konten
left join bankenabschluss on konten.KontoNr = bankenabschluss.KontoNr
where (konten.Kontotype = "B") and (bankenabschluss.Buchungsjahr=:BJAHR)
order by SortPos
