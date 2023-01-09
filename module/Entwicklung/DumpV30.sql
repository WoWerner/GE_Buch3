PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
ANALYZE sqlite_master;
INSERT INTO "sqlite_stat1" VALUES('Journal',NULL,'87');
CREATE TABLE SQLITEADMIN_QUERIES(ID INTEGER PRIMARY KEY,NAME VARCHAR(100),SQL TEXT);
CREATE TABLE [Personen] ([PersonenID] INTEGER  PRIMARY KEY NULL,[BriefAnrede] VARCHAR(20)  NULL,[Titel] VARCHAR(20)  NULL,[Vorname] VARCHAR(100)  NULL,[Vorname2] VARCHAR(100)  NULL,[Nachname] VARCHAR(100)  NULL,[Strasse] VARCHAR(100)  NULL,[Land] VARCHAR(3)  NULL,[PLZ] VARCHAR(5)  NULL,[Ort] VARCHAR(100)  NULL,[Ortsteil] VARCHAR(100)  NULL,[TelPrivat] VARCHAR(20)  NULL,[TelDienst] VARCHAR(20)  NULL,[TelMobil] VARCHAR(20)  NULL,[eMail] VARCHAR(100)  NULL,[GE_KartID] INTEGER  NULL,[Geburtstag] DATE  NULL,[Abgang] BOOLEAN  NULL,[Notiz] VARCHAR(100)  NULL,[Gemeindeglied] BOOLEAN DEFAULT 'TRUE' NULL);
INSERT INTO "Personen" VALUES(2,'Frau','','Hilde','Auguste','Adomat','Bahnhofstraße 26','','35753','Greifenstein','Allendorf','06478/2176','','','',2,'1936-02-13',0,NULL,1);
INSERT INTO "Personen" VALUES(302,'','','Karolina','','Albrecht','Finkenstr.24','','75217','Birkenfeld','','072319389464','','','',306,NULL,0,NULL,1);
INSERT INTO "Personen" VALUES(400,'Frau','','Irmgard','Elisabeth','Adam','Bergstraße 9','','35753','Greifenstein','Ulm','06478/2361','77','','',1,'1945-01-18','Y','test','Y');
INSERT INTO "Personen" VALUES(407,'Frau','','Heike','Angelika','Arndt','Herrenacker 5','','35753','Greifenstein','Allendorf','06478/1298','','','heike.ar@arcor.de',5,'1960-07-15','False','','true');
CREATE TABLE [konten] ([KontoNr] INTEGER  NOT NULL PRIMARY KEY,[Sortpos] INTEGER  NULL,[Statistik] INTEGER  NULL,[Name] VARCHAR (100)  NULL,[Kontotype] VARCHAR(2)  NULL,[Kontostand] INTEGER  NULL,[Finanzamt] VARCHAR(100)  NULL,[Finanzamtvom] VARCHAR(100)  NULL,[Finanzamtnr] VARCHAR(100)  NULL);
INSERT INTO "konten" VALUES(39,390,3,'Andere Personalaufwendungen','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(41,410,41,'Reise- und Sitzungskosten','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(42,420,42,'Kraftfahrzeug-Unterhaltung','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(43,430,43,'Postgebühren (Porto, Telefon)','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(44,440,44,'allg. Verwaltungskosten','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(45,450,45,'Aufwendungen für Grundstücke und Gebäude','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(46,460,46,'sonstige Sachaufwendungen','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(47,470,47,'Aufwendungen, die auf Erstattung angelegt sind (z.B. Gemeindefahrten, Kalender)','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(51,510,51,'Publizistik','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(52,520,52,'Gottesdienstbedarf','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(53,530,53,'Kinder- und Jugendarbeit','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(54,540,54,'Alten- und Krankenbetreuung','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(55,550,55,'Chöre','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(56,560,56,'Sonstige Gemeindekreise, Veranstaltungen der Gemeinde','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(57,570,57,'Druckschriften, Gesangbücher','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(58,580,58,'Verborgene Not','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(59,590,59,'Außerordentliche Aufwendungen','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(61,610,61,'Lutherische Theologische Hochschule','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(62,620,62,'Projekthilfe','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(63,630,63,'Amt für Gemeindedienst','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(64,640,64,'Jugendwerk','A',0,'Keins','','');
INSERT INTO "konten" VALUES(65,650,65,'Amt für Kirchenmusik','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(66,660,66,'Sonstige Zuschüsse (aus dem Gemeindeetat)','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(67,670,67,'Umlagebeiträge an die Kirchenbezirkskasse / Allgemeine Kirchenkasse (AKK)','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(68,680,68,'Sonstige Zahlungen an die Kirchenbezirkskasse, an die Sprengelkasse oder an die AKK','A',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(71,710,71,'Zinsen','A',NULL,'','','');
INSERT INTO "konten" VALUES(72,720,72,'Gebühren der Kreditinstitute','A',NULL,'','','');
INSERT INTO "konten" VALUES(73,730,73,'Sonstige Kosten des Finanzverkehrs','A',NULL,'','','');
INSERT INTO "konten" VALUES(81,810,81,'Erlöse aus Vermögen (Miete, Pacht, Zinsen, Dividende)','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576');
INSERT INTO "konten" VALUES(82,820,82,'Zuschüsse und allgemeine Erstattungen','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576');
INSERT INTO "konten" VALUES(84,840,84,'Allgemeine Kirchenbeiträge','E',0,'','','');
INSERT INTO "konten" VALUES(85,850,85,'Spenden für gemeindeeigene Zwecke','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576');
INSERT INTO "konten" VALUES(86,860,86,'Kollekten für gemeindeeigene Zwecke','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576');
INSERT INTO "konten" VALUES(87,860,87,'Sonstige Einnahmen','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576');
INSERT INTO "konten" VALUES(88,880,88,'Einnahmen für gemeindeeigene Zwecke','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576');
INSERT INTO "konten" VALUES(110,110,11,'Barkasse','B',6600,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(120,120,12,'Sparkasse Giro','B',119500,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(121,121,12,'Volksbank Giro','B',200500,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(130,130,13,'Sparkasse Sparbuch','B',10000,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(140,140,14,'Depot bei der Masterbank','B',1200000,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(150,150,15,'Bausparkasse','B',1800000,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(160,160,16,'Kredit an Gemeinde A','B',370000,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(170,170,17,'Kredit von Gemeinde B','B',-560000,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(231,231,231,'Lutherische Kirchenmission','D',0,'Fin.Amt Celle','24.02.2015','17/204/00145');
INSERT INTO "konten" VALUES(232,232,232,'Diakonie','D',0,'Fin.Amt für Körperschaften I, Berlin','23.05.2014','27/630/51049');
INSERT INTO "konten" VALUES(234,234,234,'Diasporawerk','D',0,'Dortmund-Ost','29.09.2015','317/5942/0309');
INSERT INTO "konten" VALUES(237,237,237,'Personalkosten der SELK','D',0,'','','');
INSERT INTO "konten" VALUES(241,241,241,'Lutherische Kirchenmission','D',0,'Fin.Amt Celle','24.02.2015','17/204/00145');
INSERT INTO "konten" VALUES(242,242,242,'Jugendarbeit','D',0,'','','');
INSERT INTO "konten" VALUES(243,243,243,'Lutherische Theologische Hochschule','D',0,'','','');
INSERT INTO "konten" VALUES(244,244,244,'Kirchenmusik','D',0,'','','');
INSERT INTO "konten" VALUES(245,245,245,'Bausteinsammlung','D',0,'','','');
INSERT INTO "konten" VALUES(246,246,246,'Sonstige','D',0,NULL,NULL,NULL);
INSERT INTO "konten" VALUES(247,247,247,'Diasporawerk','D',0,'Dortmund-Ost','29.09.2015','317/5942/0309');
INSERT INTO "konten" VALUES(248,248,248,'Lutherische Stunde','D',0,'Fin.Amt Rotenburg/Wü.','17.09.2012','40/201/05110');
INSERT INTO "konten" VALUES(249,249,249,'Mission unter Israel','D',0,'','','');
INSERT INTO "konten" VALUES(251,251,251,'Kirche und Judentum','D',0,'Stuttgart-Körperschaften','07.02.2014','99015/03670');
INSERT INTO "konten" VALUES(253,253,253,'Sonstige','D',0,'','','');
INSERT INTO "konten" VALUES(254,254,254,'Weltbibelhilfe','D',0,'Fin.Amt Stuttgart-Körperschaften','08.10.2012','99153/09016');
INSERT INTO "konten" VALUES(451,451,45,'Stromkosten','A',0,'','','');
INSERT INTO "konten" VALUES(452,452,45,'Müll','A',0,'','','');
CREATE TABLE [BankenAbschluss] ([KontoNr] INTEGER  NULL,[Buchungsjahr] INTEGER  NULL,[Anfangssaldo] INTEGER  NULL,[Abschlusssaldo] INTEGER  NULL);
INSERT INTO "BankenAbschluss" VALUES(110,2022,1000,0);
INSERT INTO "BankenAbschluss" VALUES(120,2022,11000,0);
INSERT INTO "BankenAbschluss" VALUES(130,2022,10000,0);
INSERT INTO "BankenAbschluss" VALUES(121,2022,200000,0);
INSERT INTO "BankenAbschluss" VALUES(140,2022,1200000,0);
INSERT INTO "BankenAbschluss" VALUES(150,2022,1800000,0);
INSERT INTO "BankenAbschluss" VALUES(160,2022,400000,0);
INSERT INTO "BankenAbschluss" VALUES(170,2022,-600000,0);
CREATE TABLE [journal] ([LaufendeNr] INTEGER DEFAULT '''''''''''''''1''''''''''''''' PRIMARY KEY AUTOINCREMENT NULL,[Belegnummer] VARCHAR(100)  NULL,[Datum] DATE  NULL,[BankNr] INTEGER  NULL,[Konto_nach] INTEGER  NULL,[PersonenID] INTEGER  NULL,[Betrag] INTEGER  NULL,[Buchungstext] VARCHAR(200)  NULL,[Bemerkung] VARCHAR(200)  NULL,[BuchungsJahr] INTEGER  NULL,[Aufwandsspende] TEXT  NULL);
INSERT INTO "journal" VALUES(1,'1','2022-01-10',110,231,100,4000,'Spende Mission','keine',2022,'Ja');
INSERT INTO "journal" VALUES(2,'2','2022-01-10',120,85,111,5000,'Spende Gesangbücher','',2022,'Nein');
INSERT INTO "journal" VALUES(3,'3','2022-01-10',120,121,0,-1000,'Umbuchung','',2022,'Nein');
INSERT INTO "journal" VALUES(4,'4','2022-01-10',110,23,0,2400,'Einzahlung Kollekte','',2022,'Nein');
INSERT INTO "journal" VALUES(5,'5','2022-01-10',120,84,110,2000,'Spende','',2022,'Nein');
INSERT INTO "journal" VALUES(6,'6','2022-01-11',121,88,100,1500,'Spende Gemeinde','',2022,'Nein');
INSERT INTO "journal" VALUES(7,'7','2022-01-11',121,231,0,-2000,'Weiterleitung an Mission','',2022,'Nein');
INSERT INTO "journal" VALUES(8,'8','2022-02-24',110,451,0,-800,'Vertr-Kontonr.15474246','',2022,'Nein');
INSERT INTO "journal" VALUES(9,'9','2022-02-24',120,231,99,12500,'Spende Mission','',2022,'Nein');
INSERT INTO "journal" VALUES(10,'10','2022-02-24',120,84,99,100000,'Gemeindebeitrag','',2022,'Nein');
INSERT INTO "journal" VALUES(12,'12','2022-02-24',120,170,0,-40000,'Tilgung Kredit von Gemeinde B','',2022,'Nein');
INSERT INTO "journal" VALUES(13,'13','2022-02-24',120,71,0,-10000,'Zinsen Kredit Gemeinde B','',2022,'Nein');
INSERT INTO "journal" VALUES(14,'14','2022-02-24',120,160,0,30000,'Rückzahlung (Tilgung) Kredit Gemeinde A','',2022,'Nein');
INSERT INTO "journal" VALUES(15,'15','2022-02-24',120,81,0,10000,'Rückzahlung (Zinsen) Kredit Gemeinde A','',2022,'Nein');
CREATE TABLE [Init] ([Passwort] VARCHAR(25)  NULL,[Buchungsjahr] INTEGER  NULL,[Version] VARCHAR(10)  NULL,[GemeindeName] VARCHAR(100)  NULL,[GemeindeStrasse] VARCHAR(100)  NULL,[GemeindePLZ] VARCHAR(5)  NULL,[GemeindeOrt] VARCHAR(100)  NULL,[GemeindeTel] VARCHAR(30)  NULL,[RendantName] VARCHAR(100)  NULL,[RendantStrasse] VARCHAR(100)  NULL,[RendantPLZ] VARCHAR(5)  NULL,[RendantOrt] VARCHAR(100)  NULL,[RendantTel] VARCHAR(30)  NULL,[RendantEMail] VARCHAR(100)  NULL,[Finanzamt] VARCHAR(100)  NULL,[FinanzamtVom] VARCHAR(100)  NULL,[FinanzamtNr] VARCHAR(100)  NULL);
INSERT INTO "Init" VALUES('GE_Buch',2022,'3.0','Mustergemeinde','Musterstraße 66','12345','Musterstadt','01234/789','Max Martin Meier','Hauptstr. 12','65432','Irgendwo','01234/88777','a@b.de','Dillenburg','21.12.2021','1526-ttd-9687576');
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('journal',15);
COMMIT;
