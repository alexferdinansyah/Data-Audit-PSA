QueryFileWebAKSes_tempTable=GetFromFile("WebAKSes_tempTable.txt")
Log(QueryFileWebAKSes_tempTable)
QueryFileWebAKSes_tempTable = Replace(QueryFileWebAKSes_tempTable, "SNAPDATE", SNAPDATE)
QueryFileWebAKSes_tempTable = Replace(QueryFileWebAKSes_tempTable, "CURRENTDATE", CURRENTDATE)
wscript.echo QueryFileWebAKSes_tempTable
'set rs= oConDW.execute(QueryFileWebAKSes_tempTable)
	Log("WebAKSes_tempTable.txt")

	'INSERT INTO TABLE WebAKSes_tempTable 
On Error Resume Next
wscript.echo "SELECT COUNT(TABLE_NAME) AS DUPLICATE FROM ALL_TABLES WHERE TABLE_NAME='WEBAKSES_" & CURRENTDATE & "'"

Set duplicate = oConDW.execute("SELECT COUNT(TABLE_NAME) AS DUPLICATE FROM ALL_TABLES WHERE TABLE_NAME='WEBAKSES_" & CURRENTDATE & "'")

if CInt(duplicate("DUPLICATE")) > 0 then
	oConDW.execute("DROP TABLE WEBAKSES_" & CURRENTDATE)
end if

QueryInsertWebAKSes_tempTable = "CREATE TABLE WEBAKSES_" & CURRENTDATE & " AS "& QueryFileWebAKSes_tempTable 
wscript.echo QueryInsertWebAKSes_tempTable
Log(QueryInsertWebAKSes_tempTable)
oConDW.execute(QueryInsertWebAKSes_tempTable)

If Err.Number = 0 Then
	Log("Insert success WebAKSes_tempTable!")
	wscript.echo "Done success WebAKSes_tempTable"
Else
	wscript.echo "error"
	Log(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
	errorMsg = errorMsg & " Insert into PSA02_temptable : " & Err.Description
end if	