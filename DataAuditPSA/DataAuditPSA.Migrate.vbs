Function Include(vbsFile)
	wscript.echo vbsFile
    Dim fso, f, s
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set f = fso.OpenTextFile(vbsFile)
    s = f.ReadAll()
    f.Close 
    ExecuteGlobal s
End Function

procstart1 = Day(Date) & "-" & Left(MonthName(Month(Date)), 3) & "-" & Year(Date) & ":" & Time
procend1 = Day(Date) & "-" & Left(MonthName(Month(Date)), 3) & "-" & Year(Date) & ":" & Time

Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Connection.vbs")
Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Common.vbs")

startyear = (0)
endyear = (1)
Dirfile = "D:\script\DAC\DataAuditPSA\"


REM Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.MigrateWebAKSes_tempTable.vbs")
REM Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.MigratePSA02.vbs")
REM Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.MigratePSA03.vbs")


wscript.echo "tes"
QueryFile=GetFromFile("CA_Migrate.txt")
LogMigrate(QueryFile)
wscript.echo QueryFile
'set rs= oConDW.execute(QueryFile)
	LogMigrate("CA_Migrate.txt")
wscript.echo QueryFile	
'INSERT INTO TABLE DI _AUDIT_PSA01_DAC
On Error Resume Next
QueryInsert = "INSERT INTO DI_AUDIT_PSA01_DAC "&_
"(SEC_CODE, SEC_DSC, TYP_CA, CA_DSC, REC_DATE, PAY_DATE, "&_
" REG_ID, ID_ACCT, ACCT_DSC, ID_MEM, AMT_GROSS, AMT_TAX, AMT_NETT)" & QueryFile 
wscript.echo QueryInsert
LogMigrate(QueryInsert)
oConDW.execute(QueryInsert)

If Err.Number = 0 Then
	 LogMigrate("Insert PSA01 success!")
	 wscript.echo "Done success"
 Else
	 wscript.echo "error"
	 LogMigrate(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
	 end if	
	
logMigrate("script selesai")
wscript.echo LogToTableMigrate(procstart1, procend1, "test", "DI_AUDIT_PSA03Migrate", "Success", 1, "Success")








