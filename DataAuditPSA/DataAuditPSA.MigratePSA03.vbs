QueryFileBursa=GetFromFile("Trade_Bursa.txt")
LogMigrate(QueryFileBursa)
wscript.echo QueryFileBursa
set rs= oConDW.execute(QueryFileBursa)
	LogMigrate("Trade_Bursa.txt")

'INSERT INTO TABLE DI_AUDIT_PSA03_DAC
On Error Resume Next
QueryInsertBursa = "INSERT INTO DI_AUDIT_PSA03_DAC "&_
"(TRADE_NO, TRANSACTIONREF, TRADEDATE, SELL_CODE, SELLER_SID, BUY_CODE, "&_
" BUYER_SID, SEC_CODE, QUANTITY, PRICE, MARKET_VALUE, LST_UPD_TS)" & QueryFileBursa 
wscript.echo QueryInsertBursa
LogMigrate(QueryInsertBursa)
oConDW.execute(QueryInsertBursa)

If Err.Number = 0 Then
	LogMigrate("Insert Bursa success!")
	wscript.echo "Done Bursa success"
Else
	wscript.echo "error Insert Bursa"
	LogMigrate(Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description & " inserting")
end if	

logMigrate("script selesai")
wscript.echo LogToTableMigrate(procstart1, procend1, "test", "DI_AUDIT_PSA03Migrate", "Success", 1, "Success")



