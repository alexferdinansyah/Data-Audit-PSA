FullDate = Day(Date) & " " & MonthName(Month(Date)) & " " & Year(Date)
Subject = "Notifikasi Procedure Gagal Proses (1)"
Body = 	"Kepada Unit Penelitian," & vbLf &_
		vbLf &_
		"Dengan ini kami informasikan bahwa per tanggal " & FullDate & ", terkait eksekusi procedure untuk Data Audit PSA dinyatakan GAGAL," & vbLf &_
		vbLf &_ 
		"Dengan error sebagai berikut: " & ErrorLog & vbLf &_
		vbLf &_
		"Demikian informasi disampaikan." & vbLf &_
		vbLf &_
		vbLf &_
		"Terimakasih"

On Error Resume Next
wscript.echo SendEmail(GetEmailInsertFailed, "", Subject, Body)

wscript.echo "kirim email notifikasi"
If Err.Number <> 0 Then
'If Err.Number = 0 Then
    'error handling:
	Subject = "Email Notifikasi Gagal Kirim(1)" 
	Body = 	"Kepada Unit Penelitian," & vbLf &_
			vbLf &_
			"Dengan ini kami informasikan bahwa per tanggal " & FullDate & ", pengiriman email notifikasi terkait eksekusi prosedure untuk Data Audit PSA mengalami gangguan." & vbLf &_
			"Dengan pesan kesalahan sebagai berikut:"  & ErrDescription & vbLf &_
			vbLf &_
			"Harap menjadi perhatian. Demikian informasi disampaikan." & vbLf &_
			vbLf &_
			"Terimakasih" 
	wscript.echo SendEmail(GetEmailNotifFailed, "", Subject, Body)
	wscript.echo "gagal kirim email notifikasi"
	Err.Clear
	
	
End If