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
Dirfile="D:\script\DAC\DataAuditPSA\"
errorMsg = ""
ErrorLog = ""
ErrDescription = ""
SNAPDATE = GetLastBursaDay()
CURRENTDATE = QueryDate()

'cekduplicatcreate_date
tanggal = Day(Date) & "-" & LEFT(MonthName(Month(Date)), 3) & "-" & Year(Date)
'AddZeroForIntBelow10(Month(Now) - 1)
tanggal = Year(Now) & "" & tanggal
wscript.echo tanggal


Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Daily.InsertWebAKSes_tempTable.vbs")
REM Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Daily.InsertPSA01.vbs")
Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Daily.InsertPSA02.vbs")
REM Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Daily.InsertPSA03.vbs")
'Include ("D:\script\DAC\DataAuditPSA\REMARK_DataAuditPSA.Daily.InsertPSA02.vbs")

if errorMsg <> "" then
	'Send Email
	log("Send Email")
	Include ("D:\script\DAC\DataAuditPSA\DataAuditPSA.Daily.EmailInsertFailed.vbs")
	'Tambahkan data di table email
end if


'memanggil fungsi log
log("script selesai")
'logToTable (start_process, end_process, last_process, process_name, process_failed_desc, email_flag, email_failed_desc)
wscript.echo LogToTable(procstart1, procend1, "test", "DI_AUDIT_PSA01", "Success", 1, "Success")
'SendEmail(MailTo, MailCC, Subject, Body)
'wscript.echo SendEmail ("husna@dac-solution.com","","Test","test Body")

