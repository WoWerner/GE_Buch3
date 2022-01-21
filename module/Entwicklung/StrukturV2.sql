CREATE TABLE [Banken] (
[BankNr] INTEGER PRIMARY KEY AUTOINCREMENT NULL,
[Bank] VARCHAR(100) NULL,
[Konto] VARCHAR(100) NULL,
[Kontostand] INTEGER NULL,
[SortPos] INTEGER NULL,
[Statistik] INTEGER NULL);

CREATE TABLE [BankenAbschluss] (
[BankNr] INTEGER NULL,
[Buchungsjahr] INTEGER NULL,
[Anfangssaldo] INTEGER NULL,
[Abschlusssaldo] INTEGER NULL);

CREATE TABLE [Init] (
[GemeindeName] VARCHAR(100) NULL,
[GemeindeStrasse] VARCHAR(100) NULL,
[GemeindePLZ] VARCHAR(5) NULL,
[GemeindeOrt] VARCHAR(100) NULL,
[GemeindeTel] VARCHAR(30) NULL,
[RendantName] VARCHAR(100) NULL,
[RendantStrasse] VARCHAR(100) NULL,
[RendantPLZ] VARCHAR(5) NULL,
[RendantOrt] VARCHAR(100) NULL,
[RendantTel] VARCHAR(30) NULL,
[RendantEMail] VARCHAR(100) NULL,
[Passwort] VARCHAR(100) NULL,
[Buchungsjahr] INTEGER NULL, 
[Finanzamt] VARCHAR(100) NULL, 
[FinanzamtVom] VARCHAR(100) NULL, 
[FinanzamtNr] VARCHAR(100) NULL);

CREATE TABLE [Journal] (
[LaufendeNr] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
[Datum] DATE NULL,
[SachkontoNr] INTEGER NULL,
[BankNr] INTEGER NULL,
[PersonenID] INTEGER NULL,
[Betrag] INTEGER NULL,
[Buchungstext] VARCHAR(200) NULL,
[Belegnummer] VARCHAR(100) NULL,
[BuchungsJahr] INTEGER NULL, 
[Bemerkung] VARCHAR(200) NULL, 
[Faelligkeit] DATE NULL, 
[ResN1] INTEGER NULL, 
[ResS1] VARCHAR(200) NULL, 
[ResD1] DATE NULL);

CREATE TABLE [Personen] (
[PersonenID] INTEGER PRIMARY KEY NULL,
[BriefAnrede] VARCHAR(20) NULL,
[Titel] VARCHAR(20) NULL,
[Vorname] VARCHAR(100) NULL,
[Vorname2] VARCHAR(100) NULL,
[Nachname] VARCHAR(100) NULL,
[Strasse] VARCHAR(100) NULL,
[Land] VARCHAR(3) NULL,
[PLZ] VARCHAR(5) NULL,
[Ort] VARCHAR(100) NULL,
[Ortsteil] VARCHAR(100) NULL,
[TelPrivat] VARCHAR(20) NULL,
[TelDienst] VARCHAR(20) NULL,
[TelMobil] VARCHAR(20) NULL,
[eMail] VARCHAR(100) NULL,
[LetzterBetrag] INTEGER NULL,
[GE_KartID] INTEGER NULL, 
[Geburtstag] DATE NULL, 
[Abgang] BOOLEAN NULL, 
[Notiz] TEXT NULL, 
[Gemeindeglied] BOOLEAN DEFAULT TRUE);

CREATE TABLE [SachKonten] (
[SachkontoNr] INTEGER PRIMARY KEY NULL, 
[Sachkonto] VARCHAR (100) NULL, 
[LetzterBetrag] INTEGER NULL, 
[SortPos] INTEGER NULL, 
[Kontotype] VARCHAR(2) NULL, 
[Statistik] INTEGER NULL, 
[Finanzamt] VARCHAR(100) NULL, 
[FinanzamtVom] VARCHAR(100) NULL, 
[FinanzamtNr] VARCHAR(100) NULL);

CREATE TABLE [Version] (
[Version] VARCHAR(10) NULL
);
