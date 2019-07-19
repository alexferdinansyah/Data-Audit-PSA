<%
Set fso = Server.CreateObject("Scripting.FileSystemObject")
 Set f = fso.GetFile("D:\script\DAC\Doc\Data Demografi Investor_2018_7_2.xlsx")
 
 If Err.number=53 then 'If log file is not found
   response.write 0
 else
response.write 1
 end if

%>