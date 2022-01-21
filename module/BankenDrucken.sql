select konten.KontoNr as BankNr,      
       SortPos,
	   Statistik,
       Name as Bank,
	   ifnull(bankenabschluss.Anfangssaldo,'')  as StartSaldo, 
	   Kontostand              
from konten
left join bankenabschluss on konten.KontoNr = bankenabschluss.KontoNr
where (konten.Kontotype = "B") and (bankenabschluss.Buchungsjahr=:BJAHR)
order by SortPos