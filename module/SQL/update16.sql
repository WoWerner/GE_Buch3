BEGIN TRANSACTION;
alter table Init add column [Finanzamt] VARCHAR(100) NULL ;        
alter table Init add column [FinanzamtVom] VARCHAR(100) NULL;      
alter table Init add column [FinanzamtNr] VARCHAR(100) NULL  ;     
alter table SachKonten add column [Finanzamt] VARCHAR(100) NULL;   
alter table SachKonten add column [FinanzamtVom] VARCHAR(100) NULL;
alter table SachKonten add column [FinanzamtNr] VARCHAR(100) NULL ;
Update Version set version = "1.6";
COMMIT;                                