Include "D:\script\includes\DBProvider.inc"
'Include "D:\script\DAC\DataAuditPSA\DataAuditPSA.Log.vbs"

set oConDW = CreateObject("ADODB.Connection") 
wscript.echo strConDW
oConDW.open strConDW 
wscript.echo "connection status : " & oConDW


