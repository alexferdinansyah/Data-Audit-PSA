QueryFilePSA02=GetFromFile("WebAKSes_Migrate.txt")
LogMigrate(QueryFilePSA02)
wscript.echo QueryFilePSA02
set rs= oConDW.execute(QueryFilePSA02)
	LogMigrate("WebAKSes_Migrate.txt")

'INSERT INTO TABLE DI_AUDIT_PSA02_DAC
On Error Resume Next
QueryInsertPSA02 = "INSERT INTO DI_AUDIT_PSA02_DAC(REKENING_EFEK, SID, FULL_NAME, ""BIRTH DATE"", ""NOMOR KTP"", ""NOMOR NPWP"", ""NOMOR PASSWORD"", EMAIL, ""MOBILE PHONE"", LOC_ASING, NATIONALITY, ADDR1, ADDR2, POSTAL_CODE, ""HOME PHONE"", OTHER_ADDR1, OTHER_ADDR2, OTHER_POSTAL_CODE, ""OTHER HOME PHONE"", CITY, PROVINCE, COUNTRY, OTHER_CITY, OTHER_PROVINCE, OTHER_COUNTRY, CORR_ADDR, CREATE_DATE, CREATION_STATUS, ""USER STATUS"", ACCOUNT_STATUS, CREATOR_CROSSLINK)"& QueryFilePSA02
wscript.echo QueryInsertPSA02
LogMigrate(QueryInsertPSA02)
oConDW.execute(QueryInsertPSA02)

If Err.Number = 0 Then
	LogMigrate("Insert DI_AUDIT_PSA02_DAC success!")
	wscript.echo "Insert  DI_AUDIT_PSA02_DAC success"
	QueryDrop = "drop table WEBAKSES_KZ001_20181130"
	oConDW.execute(QueryDrop)
	LogMigrate("drop table WEBAKSES_KZ001_20181130 success!")
	wscript.echo "Done success DROP TABLE WEBAKSES_KZ001_20181130"

Else
	wscript.echo "error Insert DI_AUDIT_PSA02_DAC"
	LogMigrate(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
end if	

logMigrate("script selesai")
wscript.echo LogToTableMigrate(procstart1, procend1, "test", "DI_AUDIT_PSA02Migrate", "Success", 1, "Success")



