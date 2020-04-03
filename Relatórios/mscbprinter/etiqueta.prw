//https://www.blogadvpl.com/funcao-mscbprinter/
#include "rwmake.ch" 
User Function Etiqueta()
    // Declaração de  variáveis utilizadas no programa
 
    SetPrvt("CPERG,CCOMBO,AITENS,VQETIQ,cCidade,nCount,VNFISCAL,VNR")
    SetPrvt("cPed,VCLIENTE,cCliEnt,cSerie,nLin,nCol,lPrim,cEndEnt,VQtdEmb")
    SetPrvt("VCONF,cNome,cEntrega,cNomeTra, VDTAVAL,VSAIR,_CPORTA,_SALIAS,AREGS")
    SetPrvt("I,J,qQetiq")
 
    cCombo   := "S4M"
    aItens   := {"ELTRON","S4M","ZEBRA"}
    VNFISCAL := Space(9)
    VProduto :=""
    cPed   := Space(6)
    VCliente :=Space(30)
    cEndEnt := Space(30)
    VQtdEmb := ""
    cNomeTra    := Space(30)
    VSair    := .f.
    VQetiq   := 1
    Vcont := 0
 
    While vSair == .f.
       @ 003,001 TO 355,450 DIALOG oDlg1   TITLE "Impressão de Etiquetas -Expedição"
       @ 135,045 BUTTON "_Imprimir"        SIZE 30,20 ACTION Impetiq()
       @ 135,128 BUTTON "_Sair"            SIZE 30,20 ACTION sair()
       @ 005,003 To 030,200
       @ 014,015 Say "Volumes:"
       @ 014,085 Get VQetiq                     SIZE 30,20 Pict "9999"
       @ 042,015 Say "Nota Fiscal:"
       @ 042,065 Get VNFISCAL                   SIZE 50,20 Picture "@!" F3 "SF2" VALID FillDSF2(VNFISCAL)
       @ 058,015 Say "Pedido:"
       @ 058,065 Get cPed                       SIZE 50,20
       @ 074,015 Say "Transportadora:"
       @ 074,065 Get cNomeTra                    SIZE 100,20
       @ 090,015 Say "Cliente:"
       @ 090,065 Get cNome                   SIZE 100,20
       @ 106,015 Say "Endereco:"
       @ 106,065 Get cEntrega                    SIZE 100,20
       @ 122,090 ComboBox cCombo Items aItens   SIZE 30,50 
 
       ACTIVATE DIALOG oDlg1 CENTERED
    EndDo
 
RETURN
 
Static Function Impetiq()
*************************
    If cCombo =="ELTRON"
       _cPorta := "ELTRON"
    ElseIf cCombo =="S4M"
       _cPorta := "S4M"
    ElseIf cCombo =="ZEBRA"
       _cPorta := "LPT3"
    EndIf
 
    MSCBPRINTER("S4M","LPT1",,,.F.,,,,,,.T.)
    for nCount :=1 to VQetiq
        MSCBBEGIN(1,4)
        MSCBSAY(08,10,"NF."+ VNFISCAL+"  PV.: "+cPed,"N","F","002,002")
        MSCBSAY(08,15,"Cliente: "+cNome,"N","F","002,002")
        MSCBSAY(08,20,"End: "+cEntrega,"N","F","002,002")
        MSCBSAY(08,25,"Cidade.: "+cCidade,"N","F","002,002")
        MSCBSAY(08,30,"Trans: "+cNomeTra ,"N","F","002,002")
        MSCBSAY(08,35,"Volumes: "+Alltrim(STR(nCount))+" de " +Alltrim(STR(VQetiq)) ,"N","F","002,002")
        MSCBEND()
    Next(nCount)
    MSCBCLOSEPRINTER()
Return          
 
Static Function Sair()
**********************
    Close(oDlg1)
    vSair := .t.
 
Return
 
Static Function FillDSF2(_cDoc)
    SF2->(dbsetorder(1))
    SF2->(dbseek(xfilial("SF2") + _cDoc ))
    cCliente:= SF2->F2_cliente
    cSerie  := SF2->F2_serie
    cPed := posicione("SC9",6,xfilial("SC9")+cSerie+_cDoc,"C9_PEDIDO")
    cNome       := posicione("SA1",1,xfilial("SA1")+SF2->F2_cliente+SF2->F2_loja,"A1_Nreduz")
    cEntrega      := posicione("SA1",1,xfilial("SA1")+SF2->F2_cliente+SF2->F2_loja,"A1_END")
    cNomeTra      := posicione("SA4",1,xfilial("SA4")+SF2->F2_transp,"A4_NOME")
    cCidade       := posicione("SA1",1,xfilial("SA1")+SF2->F2_cliente+SF2->F2_loja,"A1_MUN")
return()