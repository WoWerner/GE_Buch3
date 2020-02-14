Update banken set statistik = 20 where BankNr = 1;
insert into banken (banknr, bank, konto, kontostand, Sortpos, Statistik) values (999, "Sammelkonto", "Ausgleichskonto", 0, 999, 20);
insert into BankenAbschluss (BankNr, Buchungsjahr, Anfangssaldo, Abschlusssaldo) values (999, '+ inttostr(nBuchungsjahr)+', 0, 0);
insert into sachkonten (Sachkontonr, Sachkonto, LetzterBetrag, Sortpos, KontoType, Statistik) values (999, "Sammelkonto / Ausgleichskonto", 0, 999, "D", 1);
Update Version set version = "1.1"; 