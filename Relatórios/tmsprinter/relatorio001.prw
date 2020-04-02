//https://www.blogadvpl.com/imprimindo-etiqueta-com-codigo-de-barras-usando-o-tmsprinter/#more-280
#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"   
 
User Function REST002()
    Local oReport
    Private cPerg := 'REST002'
 
    CriaSx1(cPerg)
    Pergunte(cPerg,.T.)
    Processa({ || xPrintRel(),OemToAnsi('Gerando o relatório.')}, OemToAnsi('Aguarde...'))
Return  
 
Static Function xPrintRel()  
 
    Local nX        := 0
    Local nQtdPag   := 0
 
    Private oPrint
    Private cAlias          := getNextAlias() //cria um alias temporário
    Private oFont06     := TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
    Private oFont06n    := TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
    Private oFont08     := TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
    Private oFont08n    := TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
    Private oFont10     := TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
    Private oFont10n    := TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
    Private oFont12     := TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
    Private oFont12n    := TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
    Private oFont14     := TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
    Private oFont14n    := TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
    Private oFont26     := TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
    Private oFont26n    := TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
    Private nLin        := 0 
 
    BeginSql Alias cAlias
        SELECT
            B1_COD,
            B1_DESC
        FROM
            %table:SB1%
        WHERE
                B1_FILIAL = %xFilial:SB1%
            AND B1_COD   >= %exp:mv_par01%
            AND B1_COD    '*'
        ORDER BY
            B1_COD
        EndSql     
 
    (cAlias)->(dbGoTop())
 
    oPrint := TMSPrinter():New(OemToAnsi('Etiqueta de produto'))
    oPrint:SetPortrait()  
 
    //1cm +/- 117,5 px 
 
    nQtdPag := (mv_par03 % 2)
    iif(nQtdPag = 0, nQtdPag := Int(mv_par03/2), nQtdPag := Int(mv_par03/2) + 1)
 
    While !(cAlias)->(Eof())
        For nX := 1 to nQtdPag
            oPrint:StartPage()  
 
            nLin  := 0010
            oPrint:Say(nLin,0010,OemToAnsi('CI: ' + alltrim((cAlias)->B1_COD)),oFont10n,,,,0)
            oPrint:Say(nLin,0570,DtoC(dDataBase),oFont10,,,,1)
            oPrint:Say(nLin,0610,OemToAnsi('CI: ' + alltrim((cAlias)->B1_COD)),oFont10n,,,,0)
            oPrint:Say(nLin,1170,DtoC(dDataBase),oFont10,,,,1)          
 
            nLin += 0030
            oPrint:Say(nLin,0299,OemToAnsi(SubStr(alltrim((cAlias)->B1_DESC),1,30)),oFont10,,,,2)
            oPrint:Say(nLin,0887,OemToAnsi(SubStr(alltrim((cAlias)->B1_DESC),1,30)),oFont10,,,,2) 
 
            MSBAR('CODE128',0.7,0.8,alltrim((cAlias)->B1_COD),oPrint,.F.,,.T.,0.013,0.7,,,,.F.)
            MSBAR('CODE128',0.7,5.8,alltrim((cAlias)->B1_COD),oPrint,.F.,,.T.,0.013,0.7,,,,.F.) 
 
            oPrint:EndPage()
        Next nX
        (cAlias)->(dbSkip())
    enddo               
 
    (cAlias)->(dbCloseArea())
 
    oPrint:Preview()
    oPrint:end()
Return          
 
Static Function CriaSx1(cPerg)
    PutSx1(cPerg,"01","Do Código Interno?"  ,"Do Código Interno?" ,"Do Código Interno?" ,"mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
    PutSx1(cPerg,"02","Até Código Interno?" ,"Até Código Interno?","Até Código Interno?","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
    PutSx1(cPerg,"03","Qtde Etiquetas"      ,"Qtde Etiquetas"     ,"Qtde Etiquetas"     ,"mv_ch3","N",05,0,0,"G","",""   ,"","","mv_par03")
return