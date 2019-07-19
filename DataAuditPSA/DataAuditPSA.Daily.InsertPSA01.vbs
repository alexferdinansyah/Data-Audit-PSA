'Write Insert Query DI AUDIT PSA01
QueryFile=GetFromFile("CA.txt")
Log(QueryFile)
QueryFile = Replace(QueryFile, "SNAPDATE", SNAPDATE)
wscript.echo QueryFile
'set rs= oConDW.execute(QueryFile)
	Log("CA.txt")

	'INSERT INTO TABLE DI_AUDIT_PSA01_DAC

On Error Resume Next
QueryInsert = "INSERT INTO DI_AUDIT_PSA01_DAC "&_
"(SEC_CODE,SEC_DSC, TYP_CA, CA_DSC, REC_DATE, PAY_DATE, "&_
" REG_ID, ID_ACCT, ACCT_DSC, ID_MEM, AMT_GROSS, AMT_TAX, AMT_NETT)" & QueryFile
wscript.echo QueryInsert
Log(QueryInsert)

'check duplicate data
dataexist = CheckTotal("DI_AUDIT_PSA01_DAC", "PAY_DATE", "WHERE PAY_DATE ='" & SNAPDATE & "' ")
'wscript.echo dataexist
if dataexist <> "0" then
	'delete data
	Log("Duplicate data is about to be deleted")
	wscript.echo "Duplicate data is about to be deleted"
	DeleteDuplicateData("DELETE FROM DI_AUDIT_PSA01_DAC WHERE PAY_DATE ='" & SNAPDATE & "' ")
end if

On Error Resume Next
oConDW.execute(QueryInsert)

If Err.Number = 0 Then
	Log("Insert success PSA01!")
	wscript.echo "Done success PSA01"
Else
	Log("insert Failed")
	wscript.echo "error"
	Log(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
	errorMsg = errorMsg & " Insert into PSA01 : " & Err.Description
end if	

wscript.echo "DataAuditPSA.Daily.InsertPSA01"
wscript.echo "Run Date : " & Date & " - " & Time

'check rows inserted
rowinserted = CheckTotal("DI_AUDIT_PSA01_DAC", "PAY_DATE", "WHERE PAY_DATE = '" & SNAPDATE & "'")

Log("DataAuditPSA.Daily.InsertPSA01: " & rowinserted & " Inserted")
