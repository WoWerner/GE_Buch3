BEGIN TRANSACTION;
INSERT OR REPLACE INTO konten (KontoNr, Sortpos, Statistik, Name, Kontotype, Kontostand)  VALUES (999, 999, 999, "Ausgleichskonto für Kredite", "B", 0);
INSERT OR REPLACE INTO BankenAbschluss (KontoNr, Buchungsjahr, Anfangssaldo, Abschlusssaldo) VALUES (999, 9999, 0, 0);
Update init set version = "3.2";
COMMIT;
vacuum;
