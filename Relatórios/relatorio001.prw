//https://www.blogadvpl.com/imprindo-relatorios-com-treport-sem-utilizacao-do-metodo-setvalue/
#Include 'Protheus.ch'
User Function EX01992()
	Local oReport := nil
  	Local nI := 0
  	Private cPerg := Padr("EX01992",10)
  	Private cTitulo := ""
  	Private oFnt10N := TFont():New("Courier New", Nil, 10, Nil, .T., Nil, Nil, Nil, .F., .F.)
  	CriaPerg(cPerg)
  	If !(Pergunte(cPerg,.T.))
    	Return
  	Endif
  	oReport := RptDef(cPerg)
  	oReport:PrintDialog()
Return

Static Function RptDef(cName)
  	Local oReport := Nil
  	Local oSection1:= Nil
  	cTitulo := "Invoices Free"
  	oReport := TReport():New(cName,"Relatório de Invoices Free" ,Nil,{|oReport| ReportPrint(oReport)},"Este programa tem o objetivo de imprimir o Relatório de Invoices Free, de acordo com os parametros informados pelo usuário.")
  	oReport:SetPortrait()
 	oReport:SetLandsCape(.F.)
  	oReport:nEnvironment:= 2 //cliente
  	oReport:SetTotalInLine(.F.)
  	oSection1:= TRSection():New(oReport, "Registros", {"SW9","SW8","SC7","SC1"}, Nil, .F., .T.)
  	oSection1:SetHeaderPage()
  	TRCell():New(oSection1,"W9_INVOICE" ,"TMP", RetTitle("W9_INVOICE") ,PesqPict("SW9","W9_INVOICE") ,010)
  	TRCell():New(oSection1,"W9_DT_EMIS" ,"TMP", RetTitle("W9_DT_EMIS") ,,,,{|| STOD( Tmp->W9_DT_EMIS)})
  	TRCell():New(oSection1,"W9_COND_PA" ,"TMP", RetTitle("W9_COND_PA") ,PesqPict("SW9","W9_COND_PA") ,010)
  	TRCell():New(oSection1,"W8_HAWB" ,"TMP", RetTitle("W8_HAWB") ,PesqPict("SW8","W8_HAWB") ,010)
  	TRCell():New(oSection1,"W8_INVOICE" ,"TMP", RetTitle("W8_INVOICE") ,PesqPict("SW8","W8_INVOICE") ,017)
  	TRCell():New(oSection1,"W8_COD_I" ,"TMP", RetTitle("W8_COD_I") ,PesqPict("SW8","W8_COD_I") ,020)
  	TRCell():New(oSection1,"W8_QTDE" ,"TMP", RetTitle("W8_QTDE") ,PesqPict("SW8","W8_QTDE") ,030)
  	TRCell():New(oSection1,"W8_PO_NUM" ,"TMP", RetTitle("W8_PO_NUM") ,PesqPict("SW8","W8_PO_NUM") ,015)
  	TRCell():New(oSection1,"W8_POSICAO" ,"TMP", RetTitle("W8_POSICAO") ,PesqPict("SW8","W8_POSICAO") ,013)
  	TRCell():New(oSection1,"C7_CC" ,"TMP", RetTitle("C7_CC") ,PesqPict("SC7","C7_CC") ,013)
  	TRCell():New(oSection1,"C1_OBS" ,"TMP", RetTitle("C1_OBS") ,PesqPict("SC1","C1_OBS") ,013)
Return(oReport)

Static Function ReportPrint(oReport)
  	Local oSection1 := oReport:Section(1)
  	Pergunte(cPerg,.F.)
  	IF SELECT("TMP") # 0
    	TMP->( dbCloseArea() )
  	ENDIF
  	
	BeginSql Alias "TMP" //Query
		SELECT W9_INVOICE, W9_DT_EMIS, W9_COND_PA, W8_HAWB, W8_INVOICE, W8_COD_I, W8_QTDE, W8_PO_NUM, W8_POSICAO, C7_CC, C1_OBS
		FROM %Table:SW9% SW9
		INNER JOIN %Table:SW8% SW8 ON W8_FILIAL = %xFilial:SW8% AND W8_HAWB = W9_HAWB AND W8_INVOICE = W9_INVOICE AND W8_FORN = W9_FORN AND W8_FORLOJ = W9_FORLOJ AND SW8.%NotDel%
		INNER JOIN %Table:SC7% SC7 ON C7_FILIAL = %xFilial:SC7% AND W8_PO_NUM = C7_PO_EIC AND W8_POSICAO = C7_ITEM AND SC7.%NotDel%
		INNER JOIN %Table:SC1% SC1 ON C1_FILIAL = %xFilial:SC1% AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND SC1.%NotDel%
		WHERE SW9.%NotDel% AND W9_FILIAL = %xFilial:SW9%
		AND W8_HAWB BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND W8_INVOICE BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND W9_COND_PA = %Exp:mv_par05%
		AND W9_DT_EMIS BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
		ORDER BY W9_INVOICE, W9_DT_EMIS, W9_COND_PA, W8_HAWB, W8_INVOICE, W8_COD_I, W8_QTDE, W8_PO_NUM, W8_POSICAO, C7_CC, C1_OBS
  	EndSql
	dbSelectArea("TMP")
	TMP->(dbGoTop())
	oReport:SetMeter(TMP->(LastRec()))
	
	oSection1:Init()
	While TMP->(!Eof())
		If oReport:Cancel()
		  Exit
		EndIf
		oReport:IncMeter()
	/*Aqui normalmente colocariamos o SETVALUE, mas não é necessário, o componente se
	encarrega de imprimir as colunas já definidas inicialmente no fonte ou as novas
	colunas que forem inseridas quando personalizar o relatório
	*/
		oSection1:Printline()
		oReport:ThinLine()
		dbSelectArea("TMP")
		TMP->(dbSkip())
	EndDo
	TMP->(dbCloseArea())
	oSection1:Finish()
Return
Static Function CriaPerg(cPerg)
  putSx1(cPerg, "01", "Processo de ?" , "", "", "mv_ch1", "C", tamSx3("W8_HAWB")[1] , 0, 0, "G", "", "" , "", "", "mv_par01")
  putSx1(cPerg, "02", "Processo até?" , "", "", "mv_ch2", "C", tamSx3("W8_HAWB")[1] , 0, 0, "G", "", "" , "", "", "mv_par02")
  putSx1(cPerg, "03", "Invoice de ?" , "", "", "mv_ch3", "C", tamSx3("W8_INVOICE")[1] , 0, 0, "G", "", "" , "", "", "mv_par03")
  putSx1(cPerg, "04", "Invoice até?" , "", "", "mv_ch4", "C", tamSx3("W8_INVOICE")[1] , 0, 0, "G", "", "" , "", "", "mv_par04")
  putSx1(cPerg, "05", "Cond. Pagto?" , "", "", "mv_ch5", "C", tamSx3("W9_COND_PA")[1] , 0, 0, "G", "", "SY6" , "", "", "mv_par05")
  putSx1(cPerg, "06", "Emissao Invoice de?" , "", "", "mv_ch6", "D", tamSx3("W9_DT_EMIS")[1] , 0, 0, "G", "", "" , "", "", "mv_par06")
  putSx1(cPerg, "07", "Emissao Invoice ate?", "", "", "mv_ch7", "D", tamSx3("W9_DT_EMIS")[1] , 0, 0, "G", "", "" , "", "", "mv_par07")
Return
