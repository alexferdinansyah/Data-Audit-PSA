<%
'Response.Write Request.Form("datatype") 
'Dim command
'Dim docname = ""
Dim d_today
d_today = Now
dim oShell : set oShell = Server.CreateObject("WScript.Shell")
const ShowWindow = 1, WaitUntilFinished = true
if Request.Form("datatype") = 1 then
	periodeDariArray= Request.Form("DateDari")
	periodeSampaiArray= Request.Form("DateSampai")
	periodeSampaiArray = (Replace(periodeDariArray,"-","")) & "-" & Replace(periodeSampaiArray,"-","")
	
	periodeTodayArray =Year(now()) & "" & Month(now()) & "" & Day(now()) & "" & Hour(now()) & "" & Minute(now()) & "" & Second(now())
	
	command = "D:\intra\DAC\ConsoleExport\ConsoleExport\bin\Release\ConsoleExport.exe 1 " & Request.Form("DateDari") & "/" & Request.Form("DateSampai") & " " & Request.Form("memName") & " " & "CorporateAction" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx"
elseif Request.Form("datatype") = 2 then
	periodeSampaiArray=Request.Form("Date2")
	periodeSampaiArray =(Replace(periodeSampaiArray,"-",""))
	periodeTodayArray =Year(now()) & "" & Month(now()) & "" & Day(now()) & "" & Hour(now()) & "" & Minute(now()) & "" & Second(now())
	command = "D:\intra\DAC\ConsoleExport\ConsoleExport\bin\Release\ConsoleExport.exe " & Request.Form("datatype") & " " & Request.Form("Date2") & " " & Request.Form("memName") & " " & "WebAKSes" & "_"  & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx"
else
	periodeSampaiArray=Request.Form("Date2")
	periodeSampaiArray =(Replace(periodeSampaiArray,"-",""))
	periodeTodayArray =Year(now()) & "" & Month(now()) & "" & Day(now()) & "" & Hour(now()) & "" & Minute(now()) & "" & Second(now())
	command = "D:\intra\DAC\ConsoleExport\ConsoleExport\bin\Release\ConsoleExport.exe " & Request.Form("datatype") & " " & Request.Form("Date2") & " " & Request.Form("memName") & " " & "TransaksiBursa" & "_"  & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx"
end if
'Response.Write command
oShell.Run command, ShowWindow, WaitUntilFinished
set oShell=nothing
%>

<HEAD>
	<TITLE>Download File</TITLE>
	</HEAD>
<BODY bgcolor="#DFDFFF">

<CENTER>

<P>
	<%
		function checkfile(file)
			dim fs
			set fs=Server.CreateObject("Scripting.FileSystemObject")
			if fs.FileExists(file) then
			  response.write("File " & file & " exists!")
			  checkfile = True
			else
			  response.write("File " & file & " does not exist!")
			  checkfile = False
			end if
			set fs=nothing
		end function
	%>
	
	<%
		if Request.Form("datatype") = 1 then
			'if checkfile("Download/CorporateAction" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx") then
	%>
		If the download does not start automatically click <A HREF="Download/<% response.write "CorporateAction" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx" %>" id="clickMe">HERE</A>]<br>
	<%
			' else
				' Dim msg
				' msg = "Data not found"
				' Response.Write("<script>alert(""" + msg + """)</script>")
			' end if
		elseif Request.Form("datatype") = 2 then
			'if checkfile("Download/WebAKSes" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx") then
	%>
		If the download does not start automatically click <A HREF="Download/<% response.write "WebAKSes" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx" %>" id="clickMe">HERE</A>]<br>
	<%
			' else
				' msg = "Data not found"
				' Response.Write("<script>alert(""" + msg + """)</script>")
			' end if
		else
			'if checkfile("Download/TransakiBursa" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx") then
	%>
		If the download does not start automatically click <A HREF="Download/<% response.write "TransaksiBursa" & "_" & Request.Form("memName") & "_" & periodeSampaiArray & "_" & periodeTodayArray & ".xlsx" %>" id="clickMe">HERE</A>]<br>
	<%
			' else
				' msg = "Data not found"
				' Response.Write("<script>alert(""" + msg + """)</script>")
			' end if
		end if
	%>
	<br>If it doesnt automatically back to form, click [<A HREF="Data_Audit_PSA.asp" id="clickMe"><<<<< Form Data Audit PSA</A>]
' </P>

<script type="text/javascript">
  document.getElementById("clickMe").click();
</script>
