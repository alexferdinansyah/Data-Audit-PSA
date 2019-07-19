Function LogMigrate(Message)
	Sekarang = Year(Date) & Month(Date) & Day(Date) & "_" & Hour(Time) & Minute(Time) & Second(Time)
	Set ObjFile = CreateObject("Scripting.FileSystemObject")
	nmfile = "Log_DI_Audit_PSA01_Migrate" & Year(Now) & "_" & Month(Now)& "_" &  Day(Now) & ".txt"
	set File3 = ObjFile.OpenTextFile("D:\script\DAC\DataAuditPSA\Log\" & nmfile,8,true,0)
	File3.writeline Sekarang & " - " & Message & "." 
	File3.close
	set File3=Nothing
	wscript.echo "done loging"
End Function

Function LogToTableMigrate(start_process, end_process, last_process, process_name, process_failed_desc, email_flag, email_failed_desc)
	'Insert into LOG_DAC table (start, end, last_process, proc_name, proc_failed_dsc, email_flg, email_failed_dsc, lst_upt_ts)
	QueryLog = "INSERT INTO LOG_DAC (PROC_START, PROC_END, LAST_PROCESS, PROC_NAME, PROC_FAILED_DSC, EMAIL_FLG, EMAIL_FAILED_DSC, LST_UPT_TS) " &_
			"VALUES " &_
			"(to_date('" & start_process & "','dd-mon-yyyy hh24:mi:ss'), to_date('" & end_process & "','dd-mon-yyyy HH24:mi:ss'), '" & last_process & "', '" & process_name & "', '" & process_failed_desc & "', " & email_flag & ", '" & email_failed_desc & "', (SELECT to_char(systimestamp, 'YYYYMMDDHH24MISSFF3') FROM dual))"
	Log(QueryLog)
	'wscript.echo Query
	errors = ""
	On Error Resume Next
	oConDW.execute(Query)
	wscript.echo Err.Number
	if Err.Number <> 0 then
		LogToTable = Err.Description
		errors = Err.Description
		Err.Clear
	else
		LogToTable = "Log save in table Log_DIAuditPSA01Migrate"
	end if
	Log("Done Loging to Log_DataAuditPSAMigrate")
	Log(errors)
End Function
