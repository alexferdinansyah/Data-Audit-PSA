QueryFileWebAkses=GetFromFile("WebAKSes_tempTable_Migrate.txt")
LogMigrate(QueryFileWebAkses)
wscript.echo QueryFileWebAkses
set rs= oConDW.execute(QueryFileWebAkses)
	LogMigrate("WebAKSes_tempTable_Migrate.txt")

'CREATE TEBLE WEBAKSES_KZ001_20181130
On Error Resume Next
QueryInsertWebAkses = "CREATE TABLE WEBAKSES_KZ001_20181130 AS" & QueryFileWebAkses 
wscript.echo QueryInsertWebAkses
LogMigrate(QueryInsertWebAkses)
oConDW.execute(QueryInsertWebAkses)

If Err.Number = 0 Then
	LogMigrate("Create and Insert Web Akses success!")
	wscript.echo "Create and Insert Web Akses success"
Else
	wscript.echo "error Create and Insert Web Akses success"
	LogMigrate(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
end if	

logMigrate("script selesai")
wscript.echo LogToTableMigrate(procstart1, procend1, "test", "DI_AUDIT_PSA02Migrate", "Success", 1, "Success")



