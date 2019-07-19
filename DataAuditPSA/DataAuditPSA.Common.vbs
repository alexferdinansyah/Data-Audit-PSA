Function CheckTotal(TABLE, COL, WHERE)
	Query = "SELECT COUNT(" & COL & ") AS Total FROM " & TABLE & " " & WHERE
	Log(Query)
	Set Result = oConDW.execute(Query)
	CheckTotal = Result("Total")
End Function

Function AddZeroForIntBelow10(number)
	if number < 10 then
		AddZeroForIntBelow10 = "0" & number
	end if
End Function

Function DropTable(TABLE)
	Set dup = oConDW.execute("select count(table_name) as DUPLICATE from all_tables where table_name = '" & TABLE & "'")
	if CInt(dup("DUPLICATE")) <> 0 then
		delete = "DROP TABLE REPORTINTRA." & TABLE
		oConDW.execute(delete)
	end if
	DropTable = TRUE
End Function

Function Log(Message)
	Sekarang = Year(Date) & Month(Date) & Day(Date) & "_" & Hour(Time) & Minute(Time) & Second(Time)
	Set ObjFile = CreateObject("Scripting.FileSystemObject")
	nmfile = "log_DI_AUDIT_PSA01_" & Year(Now) & "_" & Month(Now)& "_" &  Day(Now) & ".txt"
	set File3 = ObjFile.OpenTextFile("D:\script\DAC\DataAuditPSA\Log\" & nmfile,8,true,0)
	File3.writeline Sekarang & " - " & Message & "." 
	File3.close
	set File3=Nothing
	wscript.echo "done loging"
End Function

Function LogMigrate(Message)
	Sekarang = Year(Date) & Month(Date) & Day(Date) & "_" & Hour(Time) & Minute(Time) & Second(Time)
	Set ObjFile = CreateObject("Scripting.FileSystemObject")
	nmfile = "log_DI_AUDIT_PSA01_Migrate" & Year(Now) & "_" & Month(Now)& "_" &  Day(Now) & ".txt"
	set File3 = ObjFile.OpenTextFile("D:\script\DAC\DataAuditPSA\Log\" & nmfile,8,true,0)
	File3.writeline Sekarang & " - " & Message & "." 
	File3.close
	set File3=Nothing
	wscript.echo "done loging"
End Function

Function LogToTable(start_process, end_process, last_process, process_name, process_failed_desc, email_flag, email_failed_desc)
	'Insert into LOG_DAC table (start, end, last_process, proc_name, proc_failed_dsc, email_flg, email_failed_dsc, lst_upt_ts)
	Query = "INSERT INTO LOG_DAC (PROC_START, PROC_END, LAST_PROCESS, PROC_NAME, PROC_FAILED_DSC, EMAIL_FLG, EMAIL_FAILED_DSC, LST_UPT_TS) " &_
			"VALUES " &_
			"(to_date('" & start_process & "','dd-mon-yyyy hh24:mi:ss'), to_date('" & end_process & "','dd-mon-yyyy HH24:mi:ss'), '" & last_process & "', '" & process_name & "', '" & process_failed_desc & "', " & email_flag & ", '" & email_failed_desc & "', (SELECT to_char(systimestamp, 'YYYYMMDDHH24MISSFF3') FROM dual))"
	Log(Query)
	errors = ""
	On Error Resume Next
	oConDW.execute(Query)
	wscript.echo Err.Number
	if Err.Number <> 0 then
		LogToTable = Err.Description
		errors = Err.Description
		Err.Clear
	else
		LogToTable = "Log save in table Log_DataAuditPSA"
	end if
	Log("Done Loging to Log_DataAuditPSA01")
	Log(errors)
End Function

Function LogToTableMigrate(start_process, end_process, last_process, process_name, process_failed_desc, email_flag, email_failed_desc)
	'Insert into LOG_DAC table (start, end, last_process, proc_name, proc_failed_dsc, email_flg, email_failed_dsc, lst_upt_ts)
	Query = "INSERT INTO LOG_DAC (PROC_START, PROC_END, LAST_PROCESS, PROC_NAME, PROC_FAILED_DSC, EMAIL_FLG, EMAIL_FAILED_DSC, LST_UPT_TS) " &_
			"VALUES " &_
			"(to_date('" & start_process & "','dd-mon-yyyy hh24:mi:ss'), to_date('" & end_process & "','dd-mon-yyyy HH24:mi:ss'), '" & last_process & "', '" & process_name & "', '" & process_failed_desc & "', " & email_flag & ", '" & email_failed_desc & "', (SELECT to_char(systimestamp, 'YYYYMMDDHH24MISSFF3') FROM dual))"
	Log(Query)
	errors = ""
	On Error Resume Next
	oConDW.execute(Query)
	wscript.echo Err.Number
	if Err.Number <> 0 then
		LogToTable = Err.Description
		errors = Err.Description
		Err.Clear
	else
		LogToTable = "Log save in table Log_DataAuditPSAMigrate"
	end if
	Log("Done Loging to Log_DataAuditPSA01Migrate")
	Log(errors)
End Function

Function CheckDuplicateDateInTable(Query)
	Set Check = oConDW.execute(Query)
	IF NOT Check.eof THEN
		CheckDuplicateDateInTable = TRUE
	ELSE
		CheckDuplicateDateInTable = FALSE
	END IF
End Function

Function DeleteDuplicateData(Query)
	Set Check = oConDW.execute(Query)
	Log(Query)
	DeleteDuplicateData = TRUE
	wscript.echo "Duplicate data deleted"
End Function

Function isInsertSuccess(Query)
	Set Check = oConDW.execute(Query)
	IF NOT Check.eof THEN
		isInsertSuccess = TRUE
	ELSE
		isInsertSuccess = FALSE
	END IF
End Function

'Function callingConsoleApp()
	'Set WshShell = WScript.CreateObject("WScript.Shell")
	'wscript.echo "calling console app"
	'On Error Resume Next
	''WshShell.Run """D:\script\DAC\DataAuditPSA\Release_Prod\ConsoleExport.exe """, 1, true
	'WshShell.Run """D:\script\DAC\DataAuditPSA\ConsoleExport1\ConsoleExport1\bin\Debug\ConsoleExport1.exe """, 1, true
	''wscript.echo """D:\script\DAC\DataAuditPSA\ConsoleExport\ConsoleExport\bin\Debug\ConsoleExport.exe """
	'If Err.Number <> 0 Then
		''error handling:
		'WScript.Echo Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description
		'Err.Clear
	'End If
'End Function

Function SendEmail(MailTo, MailCC, Subject, Body)
	Set objEmail = CreateObject("CDO.Message")
	
	objEmail.From 		= "report_adm@ksei.co.id"
	objEmail.To 		= MailTo
	If MailCC <> "" Then
		objEmail.Cc		= MailCC
	End If
	objEmail.Subject 	= Subject
	objEmail.Textbody 	= Body
	
	Set emailConfig = objEmail.Configuration
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") 		= "smtp.gmail.com"
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") 	= 465
	emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") 			= 1'2
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") 	= 1
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpusessl") 		= true
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendusername") 		= MailFrom
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendpassword") 		= MailFromPass
	emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory")	= "C:\inetpub\mailroot\Pickup"
	emailConfig.Fields.Update
	
	objEmail.AddAttachment "D:\script\DAC\DataAuditPSA\DI_AUDIT_PSA01.xlsx"
	objEmail.Send
	
	SendEmail = "Email Send.."
End Function

Function GetFromFile(FileName)	
	wscript.echo "script Filename " & FileName
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.OpenTextFile(Dirfile & "Query\" & FileName, 1)	
	strSQL = objFile.ReadAll
	Log(strSQL)
    GetFromFile = strSQL
	
End Function

 Function GetFromFile(FileName)
	 wscript.echo "script Filename " & FileName
	 Set objFSO = CreateObject("Scripting.FileSystemObject")
	 Set objFile = objFSO.OpenTextFile(Dirfile & "Query\" & FileName, 1)	
	 strSQL = objFile.ReadAll
	 strSQL = Replace(strSQL,"STARTYEAR",startyear)
	 strSQL = Replace(strSQL,"ENDYEAR",endyear)
	 logMigrate(strSQL)
     GetFromFile = strSQL
	 wscript.echo "berhasil"
 End Function

Function GetEmailToFailedSendNotifFailedInsertTransaksi()
	Emails = ""
	Set Data = CreateObject("ADODB.Recordset")
	'Data.open "SELECT EMAIL FROM DEMOGRAFI_INVESTOR_EMAILTO", oConDW
	Data.open "SELECT EMAIL FROM EMAILS WHERE SCRIPT_NAME='NCDToBI.SendEmailTransaksiNCDInsertFailed.vbs' AND EMAIL_SUBJECT='Notifikasi Kegagalan pengiriman email notifikasi Transfer Data – Penyelesaian Transaksi NCD' AND TO_CC_BCC=TO'", oConDW	
	Do While Not Data.EOF
		Emails = Emails & Data("EMAIL") & ","
		Data.MoveNext
	Loop
	GetEmailToFailedSendNotifFailedInsertTransaksi = Emails
End Function

Function isBursaDay(Dates)
	Datess = CDate(Dates) + 1
	Set Row = oConDW.execute("SELECT GET_LAST_BUS_DAY('" & Day(Datess) & "-" & MonthName(Month(Datess)) & "-" & Year(Datess) & "') AS TODAY FROM DUAL")
	If CDate(Dates) = CDate(Row("TODAY")) Then
		isBursaDay = TRUE
	Else
		isBursaDay = FALSE
	End If
End Function

Function FirstBursaDay(Bulan, Tahun)
	Hari = 1
	Dates = 0
	Do While Hari <> Day(DateSerial(Tahun,Bulan+1,0))
		If isBursaDay(DateSerial(Tahun, Bulan, Hari)) Then
			Dates = Hari
			Hari = Day(DateSerial(Tahun,Bulan+1,-1))
		End If
		Hari = Hari + 1
	Loop
	FirstBursaDay = DateSerial(Tahun, Bulan, Dates)
End Function

Function isFirstBursaDay()
	If FirstBursaDay(Month(Date), Year(Date)) = Date Then
	'If TRUE Then 
		isFirstBursaDay = TRUE
	Else
		isFirstBursaDay = FALSE
	End If
End Function

Function GetLastBursaDay()
	'GetLastBursaDay = "27-FEB-2018"
	Set Row = oConDW.execute("SELECT GET_LAST_BUS_DAY('" & Day(Date) & "-" & MonthName(Month(Date)) & "-" & Year(Date) & "') AS TODAY FROM DUAL")
	GetLastBursaDay = Day(Row("TODAY")) & "-" & Left(MonthName(Month(Row("TODAY"))), 3) & "-" & Year(Row("TODAY"))
End Function

Function QueryDate()
	dt = CDate(GetLastBursaDay)
	y = Year(dt)
	m = Month(dt)
	If m < 10 Then
		m = "0" & m
	End If
	d = Day(dt)
	If d < 10 Then
		d = "0" & d
	End If
	QueryDate = y & "" & m & "" & d
End Function

Function GetLastBursaDayLastMonth(Dt)
	'GetLastBursaDay = "27-FEB-2018"
	Set Row = oConDW.execute("SELECT GET_LAST_BUS_DAY('" & Day(Dt) & "-" & MonthName(Month(Dt)) & "-" & Year(Dt) & "') AS TODAY FROM DUAL")
	wscript.echo "SELECT GET_LAST_BUS_DAY('" & Day(Dt) & "-" & MonthName(Month(Dt)) & "-" & Year(Dt) & "') AS TODAY FROM DUAL"
	GetLastBursaDayLastMonth = Day(Row("TODAY")) & "-" & Left(MonthName(Month(Row("TODAY"))), 3) & "-" & Year(Row("TODAY"))
End Function

Function SendEmailWithAttach(MailTo, MailCC, Subject, Body, Attach)
	Set objEmail = CreateObject("CDO.Message")
	
	objEmail.From 		= "report_adm@ksei.co.id"
	objEmail.To 		= MailTo
	If MailCC <> "" Then
		objEmail.Cc		= MailCC
	End If
	objEmail.Subject 	= Subject
	objEmail.Textbody 	= Body
	
	Set emailConfig = objEmail.Configuration
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") 		= "smtp.gmail.com"
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") 	= 465
	emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") 			= 1'2
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") 	= 1
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpusessl") 		= true
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendusername") 		= MailFrom
	'emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/sendpassword") 		= MailFromPass
	emailConfig.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory")	= "C:\inetpub\mailroot\Pickup"
	emailConfig.Fields.Update
	
	multipleAttach = InStr(Attach, ";")
	IF multipleAttach > 0 THEN
		xx = Split(Attach, ";")
		for each x in xx
			'wscript.echo x
			objEmail.AddAttachment x
		next
	ELSE
		wscript.echo "No Mmultiple Attachment"
		objEmail.AddAttachment Attach
	END IF
	
	objEmail.Send
	
	SendEmailWithAttach = "Email with attachment Send.."
End Function

Function GetEmailNotifFailed()
	Emails = ""
	Set Data = CreateObject("ADODB.Recordset")
	'Data.open "SELECT EMAIL FROM DEMOGRAFI_INVESTOR_EMAILTO", oConDW
	Data.open "SELECT EMAIL FROM EMAILS WHERE SCRIPT_NAME='DataAuditPSA.Daily.EmailInsertFailed.vbs' AND EMAIL_SUBJECT='Email Notifikasi Gagal Kirim(1)'", oConDW	
	Do While Not Data.EOF
		Emails = Emails & Data("EMAIL") & ","
		Data.MoveNext
	Loop
	GetEmailNotifFailed = Emails
End Function

Function GetEmailNotifSuccess()
	Emails = ""
	Set Data = CreateObject("ADODB.Recordset")
	'Data.open "SELECT EMAIL FROM DEMOGRAFI_INVESTOR_EMAILTO", oConDW
	Data.open "SELECT EMAIL FROM EMAILS WHERE SCRIPT_NAME='TradingBursaSummary.SendEmailNotifSuccess.vbs' AND EMAIL_SUBJECT='Status Penyimpanan Data Statistik Trading Bursa Summary, dan Per-Provinsi dan Per-Kota, Per-Hari dan Bulan Per-Partisipan OK' AND TO_CC_BCC=TO'", oConDW	
	Do While Not Data.EOF
		Emails = Emails & Data("EMAIL") & ","
		Data.MoveNext
	Loop
	GetEmailToFailedAttach = Emails
End Function
Function GetEmailInsertSuccess()
	Emails = ""
	Set Data = CreateObject("ADODB.Recordset")
	Data.open "SELECT EMAIL FROM EMAILS WHERE SCRIPT_NAME='DataBulananCeBM.SendEmailInsertSuccess.vbs' AND EMAIL_SUBJECT='Status Penyimpanan Data Bulanan terkait Settlement CeBM (C-BEST dan S-INVEST) OK'", oConDW	
	Do While Not Data.EOF
		Emails = Emails & Data("EMAIL") & ","
		Data.MoveNext
	Loop
	GetEmailInsertSuccess = Emails
End Function

Function GetEmailInsertFailed()
	Emails = ""
	Set Data = CreateObject("ADODB.Recordset")
	Data.open "SELECT EMAIL FROM EMAILS WHERE SCRIPT_NAME='DataAuditPSA.Daily.EmailInsertFailed.vbs' AND EMAIL_SUBJECT='Notifikasi Procedure Gagal Proses (1)'", oConDW	
	Do While Not Data.EOF
		Emails = Emails & Data("EMAIL") & ","
		Data.MoveNext
	Loop
	GetEmailInsertFailed = Emails
End Function

Function SNAPDATEyyyymmdd()
strCurrentDate = myDateFormat(Date)	
SNAPDATEyyyymmdd = strCurrentDate	
End Function
Function myDateFormat(myDate)
    d = WhatEver(Day(myDate))
    m = WhatEver(Month(myDate))    
    y = Year(myDate)
    myDateFormat= yyyy & "" & mm & "" & dd
End Function

Function WhatEver(num)
    If(Len(num)=1) Then
        WhatEver="0"&num
    Else
        WhatEver=num
    End If
End Function