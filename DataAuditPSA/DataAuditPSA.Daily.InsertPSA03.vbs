QueryFileTradeBursa=GetFromFile("Bursa.txt")
Log(QueryFileTradeBursa)
QueryFileTradeBursa = Replace(QueryFileTradeBursa, "SNAPDATE", SNAPDATE)
wscript.echo QueryFileTradeBursa
'set rs= oConDW.execute(QueryFileTradeBursa)
	Log("Bursa.txt")

	'INSERT INTO TABLE DI_AUDIT_PSA03_DAC
On Error Resume Next
QueryInsertTradeBursa = "INSERT INTO DI_AUDIT_PSA03_DAC "&_
"(TRADE_NO, TRANSACTIONREF, TRADEDATE, SELL_CODE,  "&_
"SELLER_SID, BUY_CODE, BUYER_SID, SEC_CODE, QUANTITY,  "&_
"PRICE, MARKET_VALUE, LST_UPD_TS)" & QueryFileTradeBursa 
wscript.echo QueryInsertTradeBursa
Log(QueryInsertTradeBursa)

'check duplicate data
dataexist = CheckTotal("DI_AUDIT_PSA03_DAC", "TRADEDATE", "WHERE TRADEDATE ='" & SNAPDATE & "' ")
'wscript.echo dataexist
if dataexist <> "0" then
	'delete data
	Log("Duplicate data is about to be deleted")
	wscript.echo "Duplicate data is about to be deleted"
	DeleteDuplicateData("DELETE FROM DI_AUDIT_PSA03_DAC WHERE TRADEDATE ='" & SNAPDATE & "' ")
end if

On Error Resume Next
oConDW.execute(QueryInsertTradeBursa)

If Err.Number = 0 Then
	Log("Insert success Trade Bursa!")
	wscript.echo "Done success Trade Bursa"
Else
	wscript.echo "error"
	Log(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
	errorMsg = errorMsg & " Insert into PSA03 : " & Err.Description
end if	

wscript.echo "DataAuditPSA.Daily.InsertPSA03"
wscript.echo "Run Date : " & Date & " - " & Time

'check rows inserted
rowinserted = CheckTotal("DI_AUDIT_PSA03_DAC", "TRADEDATE", "WHERE TRADEDATE = '" & SNAPDATE & "'")

Log("DataAuditPSA.Daily.InsertPSA03: " & rowinserted & " Inserted")