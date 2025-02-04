update
   konten 
set
   kontostand = 
ifnull((
   select
      anfangssaldo 
   from
      bankenabschluss 
   where
      bankenabschluss.kontonr = konten.KontoNr 
      and bankenabschluss.buchungsjahr = :BJAHR), 0) 
+ ifnull((
      select
         sum(betrag) 
      from
         Journal
	  
      where
         konten.KontoNr = Journal.BankNr and 
		 Journal.buchungsjahr = :BJAHR ), 0) 
- ifnull((
         select
            sum(betrag) 
         from
            Journal  		 	
         where
            konten.KontoNr = Journal.konto_nach and 
			Journal.buchungsjahr = :BJAHR), 0) 
where
  konten.Kontotype = "B" and 
  konten.statistik <> 99;