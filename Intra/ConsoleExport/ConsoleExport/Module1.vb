'Imports Oracle.DataAccess.Client
Imports System.IO
Imports OfficeOpenXml
Imports System.Timers
Imports System.Globalization
Imports OfficeOpenXml.Style
Imports System.Data.Odbc

Module Module1

    Public Function connectionString()
        Dim sr = System.IO.File.ReadAllLines("D:\Script\includes\DBProvider.inc")
        Dim connstring = Array.Find(sr, Function(x) (x.StartsWith("ConsoleDW")))
        Dim arrString As Array = connstring.Split("""")
        oradb = arrString(1)
        Return oradb
    End Function

    Dim lastbursayday, sreTable As String
    Dim oradb As String = connectionString()
    Dim conn As New OdbcConnection(oradb) ' Visual Basic
    Public folder As String = "D:\intra\DAC\Download\"
    Dim template = folder & "template.xlsx"
    Dim package As New ExcelPackage
    Dim datatype As String = ""
    Dim dateDr As String = ""
    Dim dateSampai As String = ""
    Dim periode As String = ""
    Dim kodemember As String = ""
    Dim docment As String = ""
    Dim periodeCA() As String

    Sub Main()
        Log("Main")
        'Dim clArgs() As String = Environment.GetCommandLineArgs()
        'Log("argumen : " & clArgs.Length)
        Dim clArgs(4) As String
        clArgs(0) = ""
        clArgs(1) = "2"
        clArgs(2) = "2019-05-20"
        'clArgs(2) = "2014-07-22"
        'clArgs(2) = "2019-02-01/2019-04-01"
        'clArgs(2) = "2010-10-23/2011-01-23" '09-05-2018' and '09-06-2018'
        clArgs(3) = "CC001"
        '      ' clArgs(3) = "9X000PBS700196"
        'clArgs(3) = "ASII"
        '      'Jika tipe 1, maka CorporateAction_CS002_20010120_20010222_2019313165342.xlsx
        ''Jika tipe 2, maka TransaksiBursa_CS002_20010120_2019313165342.xlsx
        '      'Jika tipe 3, maka WEBAKSes_CS002_20010120_2019313165342.xlsx
        clArgs(4) = "WEBAKSes_CC001_20190520_2019313165342.xlsx"
        Console.WriteLine("Checking param")
        datatype = clArgs(1)
        periode = clArgs(2)
        'tipedata 2, 2012-05-22, suppose 22-05-2012
        If clArgs(2).Contains("/") Then
            periodeCA = clArgs(2).Split("/")
            dateDr = periodeCA(0)
            Dim periodeChangeFormat = dateDr.Split("-")
            dateDr = periodeChangeFormat(2) & "-" & periodeChangeFormat(1) & "-" & periodeChangeFormat(0)
            dateSampai = periodeCA(1)
            periodeChangeFormat = dateSampai.Split("-")
            dateSampai = periodeChangeFormat(2) & "-" & periodeChangeFormat(1) & "-" & periodeChangeFormat(0)
        End If
        If datatype = "3" Then
            Dim periodeChangeFormat = clArgs(2).Split("-")
            periode = periodeChangeFormat(2) & "-" & periodeChangeFormat(1) & "-" & periodeChangeFormat(0)
        Else
            Dim periodeChangeFormat = periode.Split("-")
            periode = periodeChangeFormat(2) & "-" & MonthName(periodeChangeFormat(1), 3).ToUpper & "-" & periodeChangeFormat(0)
        End If
        kodemember = clArgs(3)
        'Console.WriteLine(datatype & " " & clArgs(2) & " " & kodemember)
        Log("Check Connection")

        Dim new_file = "D:\intra\DAC\Download\" & clArgs(4)
        Dim File = New FileInfo(template)
        Dim NewFile = New FileInfo(new_file)

        Dim query As String = ""

        If connect() Then
            Try
                Using package As New ExcelPackage(File)
                    package.Load(New FileStream(template, FileMode.Open))
                    'stringLog = stringLog & " executing file.. "
                    Dim SA_DSC_MEM As String = ""
                    Dim SRE As Integer = 0
                    Dim SID As Integer = 0

                    'kodemember = id_mem, periode itu date_pay
                    Log(datatype & " " & kodemember & " " & periode)
                    If datatype = "1" Then
                        'CA
                        'search from di_audit_psa01_dac
                        query = "select * from di_audit_psa01_dac where id_mem='" & kodemember &
                            "' and PAY_DATE between  TO_DATE('" & dateDr & "', 'DD-MM-YYYY') and TO_DATE('" & dateSampai & "', 'DD-MM-YYYY')"
                    ElseIf datatype = "2" Then
                        'Web AKSes
                        'search from di_audit_psa02_dac
                        query = "select * from di_audit_psa02_dac where CREATE_DATE = '" & periode &
                            "' and substr(rekening_efek, 1, 5) = '" & kodemember & "'"
                    Else
                        'Transaki Bursa
                        'search from di_audit_psa03_dac
                        query = "select * from di_audit_psa03_dac where tradedate= TO_DATE('" & periode & "', 'DD-MM-YYYY') and (sell_code = substr('" & kodemember & "', 1, 2) or buy_code = substr('" & kodemember & "', 1, 2))"
                    End If

                    Dim Command As New OdbcCommand(query, conn)
                    Dim reader As OdbcDataReader
                    Log("reading query : " & query)
                    reader = Command.ExecuteReader()
                    Log("done read query")
                    Dim row As Int32 = 2
                    Dim start_process As String = Date.UtcNow.Day & "/" & Date.UtcNow.Month & "/" & Date.UtcNow.Year
                    Dim process_failed_desc As String = ""
                    Dim no As Integer = 1
                    'BEGIN HEADER
                    If datatype = "1" Then
                        package.Workbook.Worksheets("Sheet1").Cells("A1").Value = "NO"
                        package.Workbook.Worksheets("Sheet1").Cells("B1").Value = "SECURITIES CODE"
                        package.Workbook.Worksheets("Sheet1").Cells("C1").Value = "SECURITIES NAME"
                        package.Workbook.Worksheets("Sheet1").Cells("D1").Value = "CA TYPE"
                        package.Workbook.Worksheets("Sheet1").Cells("E1").Value = "DESCRIPTION"
                        package.Workbook.Worksheets("Sheet1").Cells("F1").Value = "RECORD DATE"
                        package.Workbook.Worksheets("Sheet1").Cells("G1").Value = "PAYMENT DATE"
                        package.Workbook.Worksheets("Sheet1").Cells("H1").Value = "SECURITIES REGISTER ID"
                        package.Workbook.Worksheets("Sheet1").Cells("I1").Value = "ACCOUNT NUMBER"
                        package.Workbook.Worksheets("Sheet1").Cells("J1").Value = "ACCOUNT DESCRIPTION"
                        package.Workbook.Worksheets("Sheet1").Cells("K1").Value = "ID MEMBER"
                        package.Workbook.Worksheets("Sheet1").Cells("L1").Value = "GROSS AMOUNT"
                        package.Workbook.Worksheets("Sheet1").Cells("M1").Value = "TAX AMOUNT"
                        package.Workbook.Worksheets("Sheet1").Cells("N1").Value = "NETT AMOUNT"

                    ElseIf datatype = "2" Then
                        package.Workbook.Worksheets("Sheet1").Cells("A1").Value = "NO"
                        package.Workbook.Worksheets("Sheet1").Cells("B1").Value = "ID ACCOUNT"
                        package.Workbook.Worksheets("Sheet1").Cells("C1").Value = "SID"
                        package.Workbook.Worksheets("Sheet1").Cells("D1").Value = "FULL NAME"
                        package.Workbook.Worksheets("Sheet1").Cells("E1").Value = "BIRTH DATE"
                        package.Workbook.Worksheets("Sheet1").Cells("F1").Value = "ID CARD"
                        package.Workbook.Worksheets("Sheet1").Cells("G1").Value = "NPWP"
                        package.Workbook.Worksheets("Sheet1").Cells("H1").Value = "PASSPORT"
                        package.Workbook.Worksheets("Sheet1").Cells("I1").Value = "EMAIL"
                        package.Workbook.Worksheets("Sheet1").Cells("J1").Value = "MOBILE NUMBER"
                        package.Workbook.Worksheets("Sheet1").Cells("K1").Value = "DOMICILE"
                        package.Workbook.Worksheets("Sheet1").Cells("L1").Value = "NATIONALITY"
                        package.Workbook.Worksheets("Sheet1").Cells("M1").Value = "ADDRESS 1"
                        package.Workbook.Worksheets("Sheet1").Cells("N1").Value = "ADDRESS 2"
                        package.Workbook.Worksheets("Sheet1").Cells("O1").Value = "POSTAL CODE"
                        package.Workbook.Worksheets("Sheet1").Cells("P1").Value = "HOME PHONE"
                        package.Workbook.Worksheets("Sheet1").Cells("Q1").Value = "OTHER ADDRESS 1"
                        package.Workbook.Worksheets("Sheet1").Cells("R1").Value = "OTHER ADDRESS 2"
                        package.Workbook.Worksheets("Sheet1").Cells("S1").Value = "OTHER HOME PHONE"
                        package.Workbook.Worksheets("Sheet1").Cells("T1").Value = "CITY"
                        package.Workbook.Worksheets("Sheet1").Cells("U1").Value = "PROVINCE"
                        package.Workbook.Worksheets("Sheet1").Cells("V1").Value = "COUNTRY"
                        package.Workbook.Worksheets("Sheet1").Cells("W1").Value = "OTHER CITY"
                        package.Workbook.Worksheets("Sheet1").Cells("X1").Value = "CORR ADDRESS"
                        package.Workbook.Worksheets("Sheet1").Cells("Y1").Value = "CREATE DATE"
                        package.Workbook.Worksheets("Sheet1").Cells("Z1").Value = "CREATION STATUS"
                        package.Workbook.Worksheets("Sheet1").Cells("AA1").Value = "USERS STATUS"
                        package.Workbook.Worksheets("Sheet1").Cells("AB1").Value = "ACCOUNT STATUS"
                        package.Workbook.Worksheets("Sheet1").Cells("AC1").Value = "CREATOR/CROSSLINK"

                    Else
                        package.Workbook.Worksheets("Sheet1").Cells("A1").Value = "NO"
                        package.Workbook.Worksheets("Sheet1").Cells("B1").Value = "TRADE NUMBER"
                        package.Workbook.Worksheets("Sheet1").Cells("C1").Value = "TRANSACTION REFERENCE"
                        package.Workbook.Worksheets("Sheet1").Cells("D1").Value = "TRADE DATE"
                        package.Workbook.Worksheets("Sheet1").Cells("E1").Value = "SELLER CODE"
                        package.Workbook.Worksheets("Sheet1").Cells("F1").Value = "SELLER SID"
                        package.Workbook.Worksheets("Sheet1").Cells("G1").Value = "BUYER CODE"
                        package.Workbook.Worksheets("Sheet1").Cells("H1").Value = "BUYER SID"
                        package.Workbook.Worksheets("Sheet1").Cells("I1").Value = "SECURITY CODE"
                        package.Workbook.Worksheets("Sheet1").Cells("J1").Value = "QUANTITY"
                        package.Workbook.Worksheets("Sheet1").Cells("K1").Value = "PRICE"
                        package.Workbook.Worksheets("Sheet1").Cells("L1").Value = "MARKET VALUE"
                    End If
                    'END HEADER
                    While (reader.Read())
                        If datatype = "1" Then
                            'package.Workbook.Worksheets("Sheet1").Cells("A" & row).Value = "asha"
                            package.Workbook.Worksheets("Sheet1").Cells("A" & row).Value = no
                            package.Workbook.Worksheets("Sheet1").Cells("B" & row).Value = reader("SEC_CODE")
                            package.Workbook.Worksheets("Sheet1").Cells("C" & row).Value = reader("SEC_DSC")
                            package.Workbook.Worksheets("Sheet1").Cells("D" & row).Value = reader("TYP_CA")
                            package.Workbook.Worksheets("Sheet1").Cells("E" & row).Value = reader("CA_DSC")
                            package.Workbook.Worksheets("Sheet1").Cells("F" & row).Value = reader("REC_DATE")
                            package.Workbook.Worksheets("Sheet1").Cells("G" & row).Value = reader("PAY_DATE")
                            package.Workbook.Worksheets("Sheet1").Cells("H" & row).Value = reader("REG_ID")
                            package.Workbook.Worksheets("Sheet1").Cells("I" & row).Value = reader("ID_aCCT")
                            package.Workbook.Worksheets("Sheet1").Cells("J" & row).Value = reader("ACCT_DSC")
                            package.Workbook.Worksheets("Sheet1").Cells("K" & row).Value = reader("ID_MEM")
                            package.Workbook.Worksheets("Sheet1").Cells("L" & row).Value = reader("AMT_GROSS")
                            package.Workbook.Worksheets("Sheet1").Cells("M" & row).Value = reader("AMT_TAX")
                            package.Workbook.Worksheets("Sheet1").Cells("N" & row).Value = reader("AMT_NETT")

                            Dim modelRange = "A1:N" & row
                            Dim modelTable = package.Workbook.Worksheets("Sheet1").Cells(modelRange)
                            'Assign borders
                            modelTable.Style.Border.Top.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Left.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Right.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Bottom.Style = ExcelBorderStyle.Thin

                        ElseIf datatype = "2" Then
                            package.Workbook.Worksheets("Sheet1").Cells("A" & row).Value = no
                            package.Workbook.Worksheets("Sheet1").Cells("B" & row).Value = reader("REKENING_EFEK")
                            package.Workbook.Worksheets("Sheet1").Cells("C" & row).Value = reader("SID")
                            package.Workbook.Worksheets("Sheet1").Cells("D" & row).Value = reader("FULL_NAME")
                            package.Workbook.Worksheets("Sheet1").Cells("E" & row).Value = reader("BIRTH DATE")
                            package.Workbook.Worksheets("Sheet1").Cells("F" & row).Value = reader("NOMOR KTP")
                            package.Workbook.Worksheets("Sheet1").Cells("G" & row).Value = reader("NOMOR NPWP")
                            package.Workbook.Worksheets("Sheet1").Cells("H" & row).Value = reader("NOMOR PASSWORD")
                            package.Workbook.Worksheets("Sheet1").Cells("I" & row).Value = reader("EMAIL")
                            package.Workbook.Worksheets("Sheet1").Cells("J" & row).Value = reader("MOBILE PHONE")
                            package.Workbook.Worksheets("Sheet1").Cells("K" & row).Value = reader("LOC_ASING")
                            package.Workbook.Worksheets("Sheet1").Cells("L" & row).Value = reader("NATIONALITY")
                            package.Workbook.Worksheets("Sheet1").Cells("M" & row).Value = reader("ADDR1")
                            package.Workbook.Worksheets("Sheet1").Cells("N" & row).Value = reader("ADDR2")
                            package.Workbook.Worksheets("Sheet1").Cells("O" & row).Value = reader("POSTAL_CODE")
                            package.Workbook.Worksheets("Sheet1").Cells("P" & row).Value = reader("HOME PHONE")
                            package.Workbook.Worksheets("Sheet1").Cells("Q" & row).Value = reader("OTHER_ADDR1")
                            package.Workbook.Worksheets("Sheet1").Cells("R" & row).Value = reader("OTHER_ADDR2")
                            package.Workbook.Worksheets("Sheet1").Cells("S" & row).Value = reader("OTHER HOME PHONE")
                            package.Workbook.Worksheets("Sheet1").Cells("T" & row).Value = reader("CITY")
                            package.Workbook.Worksheets("Sheet1").Cells("U" & row).Value = reader("PROVINCE")
                            package.Workbook.Worksheets("Sheet1").Cells("V" & row).Value = reader("COUNTRY")
                            package.Workbook.Worksheets("Sheet1").Cells("W" & row).Value = reader("OTHER_CITY")
                            package.Workbook.Worksheets("Sheet1").Cells("X" & row).Value = reader("CORR_ADDR")
                            package.Workbook.Worksheets("Sheet1").Cells("Y" & row).Value = reader("CREATE_DATE")
                            package.Workbook.Worksheets("Sheet1").Cells("Z" & row).Value = reader("CREATION_STATUS")
                            package.Workbook.Worksheets("Sheet1").Cells("AA" & row).Value = reader("USER STATUS")
                            package.Workbook.Worksheets("Sheet1").Cells("AB" & row).Value = reader("ACCOUNT_STATUS")
                            package.Workbook.Worksheets("Sheet1").Cells("AC" & row).Value = reader("CREATOR_CROSSLINK")

                            Dim modelRange = "A1:AC" & row
                            Dim modelTable = package.Workbook.Worksheets("Sheet1").Cells(modelRange)
                            'Assign borders
                            modelTable.Style.Border.Top.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Left.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Right.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Bottom.Style = ExcelBorderStyle.Thin
                        Else
                            package.Workbook.Worksheets("Sheet1").Cells("A" & row).Value = no
                            package.Workbook.Worksheets("Sheet1").Cells("B" & row).Value = reader("TRADE_NO")
                            package.Workbook.Worksheets("Sheet1").Cells("C" & row).Value = reader("TRANSACTIONREF")
                            package.Workbook.Worksheets("Sheet1").Cells("D" & row).Value = reader("TRADEDATE")
                            package.Workbook.Worksheets("Sheet1").Cells("E" & row).Value = reader("SELL_CODE")
                            package.Workbook.Worksheets("Sheet1").Cells("F" & row).Value = reader("SELLER_SID")
                            package.Workbook.Worksheets("Sheet1").Cells("G" & row).Value = reader("BUY_CODE")
                            package.Workbook.Worksheets("Sheet1").Cells("H" & row).Value = reader("BUYER_SID")
                            package.Workbook.Worksheets("Sheet1").Cells("I" & row).Value = reader("SEC_CODE")
                            package.Workbook.Worksheets("Sheet1").Cells("J" & row).Value = reader("QUANTITY")
                            package.Workbook.Worksheets("Sheet1").Cells("K" & row).Value = reader("PRICE")
                            package.Workbook.Worksheets("Sheet1").Cells("L" & row).Value = reader("MARKET_VALUE")

                            Dim modelRange = "A1:L" & row
                            Dim modelTable = package.Workbook.Worksheets("Sheet1").Cells(modelRange)
                            'Assign borders
                            modelTable.Style.Border.Top.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Left.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Right.Style = ExcelBorderStyle.Thin
                            modelTable.Style.Border.Bottom.Style = ExcelBorderStyle.Thin

                        End If
                        If no = 1000000 Then
                            Exit While
                        End If
                        no = no + 1
                        row = row + 1
                        process_failed_desc = "Success"
                    End While

                    If reader.FieldCount = 0 Then
                        process_failed_desc = "Failed "
                    End If
                    reader.Close()
                    Dim end_process As String = Date.UtcNow.Day & "/" & Date.UtcNow.Month & "/" & Date.UtcNow.Year


                    'reader.SaveAs("D:\intra\DAC\Download\exportnew.xlsx")
                    Try
                        package.SaveAs(NewFile)
                        Log("Done Saving")
                        LogToTable(start_process, end_process, "export to excel", "export CA", process_failed_desc, 0, "N/A")
                    Catch ex As Exception
                        Console.WriteLine("error " & ex.Message)
                        Log("Failed to save " & ex.Message)
                    End Try
                End Using
            Catch ex As Exception
                'ErroLog = ErroLog & ex.Message
                'isAllSuccess = False
            End Try
            Console.WriteLine("Saved...")
            Log("File Export Saved")
            'End Using
        End If

        'Console.WriteLine("Done Trading Bursa Summary " & param)
        Console.WriteLine("Finish")
        Log("Export Finish")
        'Console.ReadLine()
    End Sub

    Public Function connect() As Boolean
        conn.Open()
        If conn.State = ConnectionState.Open Then
            'stringLog = stringLog & "Berhasil connect"
            Log("Connection Success!")
            Return True
        End If
        'isAllSuccess = False
        'ErroLog = ErroLog & "Koneksi Ke Database Gagal"
        'Log("Koneksi Gagal")
        Return False
    End Function

   
    'Public Function Logging(ByVal Messages As String) As Boolean
    '    'Dim logFile As String = "D:\script\DAC\Data NCD ke BI\Log\"
    '    Dim logFile As String = "D:\Script\Penelitian\TradingBursaSummary\Log\"
    '    Dim newlog = "logConsole_" & intMonth & "_" & intYear & ".txt"

    '    Dim file As StreamWriter
    '    file = My.Computer.FileSystem.OpenTextFileWriter(logFile & newlog, True)
    '    file.WriteLine(DateTime.Now.TimeOfDay.Hours & "" & DateTime.Now.TimeOfDay.Minutes & "" & DateTime.Now.TimeOfDay.Seconds & " : " & Messages)
    '    file.Close()
    '    Return True
    'End Function
    Public Function AddZeroForIntBelow10(ByVal p1 As String) As String
        Dim result = ""
        If Convert.ToInt32(p1) < 10 Then
            result = "1" & p1
        Else
            result = p1
        End If

        Return result
    End Function

    Function Log(ByVal Message)

        Dim Sekarang = Date.UtcNow.Year & Date.UtcNow.Month & Date.UtcNow.Day & "_" & Date.UtcNow.Hour & Date.UtcNow.Minute & Date.UtcNow.Second
        Dim ObjFile = CreateObject("Scripting.FileSystemObject")
        Dim nmfile = "log_DI_Audit_PSA01_" & Year(Now) & "_" & Month(Now) & "_" & Day(Now) & ".txt"
        Dim File3 = ObjFile.OpenTextFile("D:\intra\DAC\Log\" & nmfile, 8, True, 0)
        File3.writeline(Sekarang & " - " & Message & ".")
        File3.close()
        File3 = Nothing
        'Console.WriteLine("done loging")
        Log = True
    End Function
    Function LogToTable(ByVal start_process, ByVal end_process, ByVal last_process, ByVal process_name, ByVal process_failed_desc, ByVal email_flag, ByVal email_failed_desc)
        'Insert into LOG_DAC table (start, end, last_process, proc_name, proc_failed_dsc, email_flg, email_failed_dsc, lst_upt_ts)
        Dim QueryLog = "INSERT INTO LOG_DAC (PROC_START, PROC_END, LAST_PROCESS, PROC_NAME, PROC_FAILED_DSC, EMAIL_FLG, EMAIL_FAILED_DSC, LST_UPT_TS) VALUES " &
               " (to_date('" & start_process & "','dd-mm-yyyy hh24:mi:ss'), to_date('" & end_process & "','dd-mm-yyyy HH24:mi:ss'), 'Export Excel', 'Export CA', '" & process_failed_desc & "', 0, 'N/A', (SELECT to_char(systimestamp, 'YYYYMMDDHH24MISSFF3') FROM dual))"
        Log(QueryLog)
        'wscript.echo Query
        Dim errors = ""
        On Error Resume Next
        Dim Command As New OdbcCommand(QueryLog, conn)
        Dim reader As OdbcDataReader
        reader = Command.ExecuteReader()
        Console.WriteLine(Err.Number)
        Log(Err.Number)
        If Err.Number <> 0 Then
            LogToTable = Err.Description
            errors = Err.Description
            Err.Clear()
        Else
            LogToTable = "Log save in table log_DI_Audit_PSA01_"
        End If
        Log("Done Loging to Log_DataAuditPSA")
        Log(errors)
    End Function

End Module

