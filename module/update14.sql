BEGIN TRANSACTION;
alter table Journal add column [Bemerkung] VARCHAR(200) NULL;
alter table Journal add column [Faelligkeit] DATE NULL ;    
alter table Journal add column [ResN1] INTEGER NULL;        
alter table Journal add column [ResS1] VARCHAR(200) NULL ,; 
alter table Journal add column [ResD1] DATE NULL;           
Update Version set version = "1.4" ;
COMMIT;                        