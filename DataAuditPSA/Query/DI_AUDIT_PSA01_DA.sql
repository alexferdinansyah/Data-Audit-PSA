--------------------------------------------------------
--  File created - Senin-Maret-25-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table DI_AUDIT_PSA01
--------------------------------------------------------

  CREATE TABLE "REPORTINTRA"."DI_AUDIT_PSA01" 
   (	"CA_DSC" VARCHAR2(4000 BYTE), 
	"CODE_TAX_PAY_METH" NUMBER(5,0), 
	"DAT_ANN" DATE, 
	"DAT_END_INT_PER" DATE, 
	"DAT_EX" DATE, 
	"DAT_FIRST_INT_PER" DATE, 
	"DAT_INST_DEAD" DATE, 
	"DAT_INT_RATE" DATE, 
	"DAT_NEW_RED" DATE, 
	"DAT_PAY" DATE, 
	"DAT_REC" DATE, 
	"DAT_START_PER" DATE, 
	"ID_CA_CAPCO" CHAR(40 BYTE), 
	"LST_UPD_TS" CHAR(17 BYTE), 
	"MIN_DENM" NUMBER(32,6), 
	"NEW_INT_RATE" NUMBER(5,2), 
	"NUM_INT_PER" NUMBER(38,0), 
	"PERC_INT_RATE" NUMBER(5,2), 
	"PERC_PRE" NUMBER(5,2), 
	"PERC_RED" NUMBER(23,20), 
	"PERC_RED_PRI" NUMBER(5,2), 
	"TYP_CA" NUMBER(5,0), 
	"FLG_TAX" NUMBER(1,0), 
	"INS_ID_INS_CAPCO" CHAR(40 BYTE), 
	"ACCT_ID_ACCT_CAPCO_PROCEED" CHAR(40 BYTE), 
	"ACCT_ID_ACCT_CAPCO_TAX" CHAR(40 BYTE), 
	"CODE_STA" NUMBER(5,0), 
	"ID_CAE_CAPCO" CHAR(40 BYTE), 
	"LASTUPDATE" CHAR(17 BYTE), 
	"ACCT_ID_ACCT_CAPCO" CHAR(40 BYTE), 
	"ACCT_ID_ACCT_CAPCO_SRC" CHAR(40 BYTE), 
	"AMT_GROSS" NUMBER(32,6), 
	"AMT_TAX" NUMBER(32,6), 
	"AMT_NET" NUMBER(32,6)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "REPORTINTRA" ;
--------------------------------------------------------
--  Constraints for Table DI_AUDIT_PSA01
--------------------------------------------------------

  ALTER TABLE "REPORTINTRA"."DI_AUDIT_PSA01" MODIFY ("DAT_ANN" NOT NULL ENABLE);
 
  ALTER TABLE "REPORTINTRA"."DI_AUDIT_PSA01" MODIFY ("ID_CA_CAPCO" NOT NULL ENABLE);
 
  ALTER TABLE "REPORTINTRA"."DI_AUDIT_PSA01" MODIFY ("CODE_STA" NOT NULL ENABLE);
 
  ALTER TABLE "REPORTINTRA"."DI_AUDIT_PSA01" MODIFY ("ID_CAE_CAPCO" NOT NULL ENABLE);