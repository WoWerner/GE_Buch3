select konten.KontoNr as BankNr,      
       SortPos,
	   Statistik,
       Name,
	   ifnull(bankenabschluss.Anfangssaldo, 0) as StartSaldo, 
	   Kontostand              
from konten
left join bankenabschluss on konten.KontoNr = bankenabschluss.KontoNr
where (konten.Kontotype = "B") and (bankenabschluss.Buchungsjahr=:BJAHR)
order by SortPos