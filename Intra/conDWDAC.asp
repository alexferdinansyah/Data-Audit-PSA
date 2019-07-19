<%
	set con=createobject("adodb.connection")
	set conStringIntranet=createobject("adodb.connection")
	'con.open "reportintra","reportintra","password"
	con.open "Provider=MSDAORA.1;Password=password;User ID=reportintra;Data Source=kseiware;Persist Security Info=True"
	conStringIntranet.open="Provider=MSDAORA.1;Password=password;User ID=intranet;Data Source=KSEISTPD;Persist Security Info=True"
%>