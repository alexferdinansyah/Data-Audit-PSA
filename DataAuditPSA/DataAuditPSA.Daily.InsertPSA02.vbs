QueryFilePSA02=GetFromFile("WebAKSes.txt")
Log(QueryFilePSA02)
QueryFilePSA02 = Replace(QueryFilePSA02, "SNAPDATE", SNAPDATE)
QueryFilePSA02 = Replace(QueryFilePSA02, "CURRENTDATE", CURRENTDATE)

wscript.echo QueryFilePSA02
'set rs= oConDW.execute(QueryFilePSA02)
	Log("WebAKSes.txt")

	'INSERT INTO TABLE DI_AUDIT_PSA02_DAC

On Error Resume Next
QueryTruncateTable = "truncate table DI_AUDIT_PSA02_DAC"
wscript.echo QueryTruncateTable
Log(QueryTruncateTable)
oConDW.execute(QueryTruncateTable)

QueryInsertPSA02 = "INSERT INTO DI_AUDIT_PSA02_DAC(REKENING_EFEK, SID, FULL_NAME, ""BIRTH DATE"", ""NOMOR KTP"", ""NOMOR NPWP"", ""NOMOR PASSWORD"", EMAIL, ""MOBILE PHONE"", LOC_ASING, NATIONALITY, ADDR1, ADDR2, POSTAL_CODE, ""HOME PHONE"", OTHER_ADDR1, OTHER_ADDR2, OTHER_POSTAL_CODE, ""OTHER HOME PHONE"", CITY, PROVINCE, COUNTRY, OTHER_CITY, OTHER_PROVINCE, OTHER_COUNTRY, CORR_ADDR, CREATE_DATE, CREATION_STATUS, ""USER STATUS"", ACCOUNT_STATUS, CREATOR_CROSSLINK)"& QueryFilePSA02
wscript.echo QueryInsertPSA02

'function cek duplicat
dataexist = CheckTotal("DI_AUDIT_PSA02_DAC", "CREATE_DATE", "WHERE CREATE_DATE = '" & Day(Date) & "-" & LEFT(MonthName(Month(Date)), 3) & "-" & Year(Date) & "' ")
if dataexist <> "0" then
	'delete data
	Log("Duplicate data DI_AUDIT_PSA02 is about to be deleted")
	DeleteDuplicateData("DELETE FROM DI_AUDIT_PSA02_DAC WHERE CREATE_DATE = '" & Day(Date) & "-" & LEFT(MonthName(Month(Date)), 3) & "-" & Year(Date) & "' ")
end if


Log(QueryInsertPSA02)
oConDW.execute(QueryInsertPSA02)




If Err.Number = 0 Then
	Log("Insert success PSA02!")
	wscript.echo "Done success PSA02"
	QueryDrop = "DROP TABLE WEBAKSES_" & CURRENTDATE
	Log(QueryDrop)
	oConDW.execute(QueryDrop)
	Log("Done Drop table WEBAKSES!")
	wscript.echo "Done success DROP TABLE WEBAKSES"
	
Else
	wscript.echo "error"
	Log(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
	errorMsg = errorMsg & " Insert into PSA02 : " & Err.Description
end if	