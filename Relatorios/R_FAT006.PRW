#include 'protheus.ch'
#INCLUDE "topconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "totvs.ch"

/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | R_FAT006  | Autor |    Pedro Almeida                             |*
*+------------+------------------------------------------------------------------+*
*|Data        | 26.11.2024                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Relatório do Faturamento para Frete                              |*
**********************************************************************************/
User Function R_FAT006()

Processa( {|| u_PFAT006()}, "Selecionando registros, Aguarde..." , "" , .T. ) //PHADA-22/07/2025

Return
User Function PFAT006()
	Local oExcel := FWMSEXCEL():New()
	Local cTitle       := "Relatório do Faturamento para Frete  "
	Local cWorkSheet 	:= "Relatório do Faturamento para Frete  "
	Local cMask        := ""
	Local nDefaultMask := 0
	Local cDefaultDir  := ""
	Local nOptions     := GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY
	Local cDir       := ""//"\system\"//GetSrvProfString("ROOTPATH","")+"\"
	Local cFile      := "Rel_Faturamento_Frete" + DToS(Date()) + ".xls"
	Local cQuery
	Local aPergs := {}
	Local nTotal := 0
	Local nAtual := 0



	aAdd(aPergs,{1,"Emissao de", Date(),,,"",,80,.F.})
	aAdd(aPergs,{1,"Emissao Ate",Date(),,,"",,80,.T.})
	If !parambox(aPergs,"Informe os parametros")
		Return
	EndIf

	oExcel:AddworkSheet(cWorkSheet)
	oExcel:AddTable (cWorkSheet,cTitle)

	cDir := cGetFile(cMask,cTitle,nDefaultMask,cDefaultDir,,nOptions)

	//Colunas
	oExcel:AddColumn(cWorkSheet,cTitle,"FILIAL"            	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"DOCUMENTO"         	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"SERIE"             	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"EMISSAO"           	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"VALOR_BRUTO"       	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"VALOR_MERCADORIA"  	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"VALOR_FRETE"       	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"TIPO_FRETE"        	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"UF"                	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"MUNICIPIO"         	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"CODIGO_CLIENTE"    	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"NOME_CLIENTE"      	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"ZERAFRETE"         	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"PERCENT_CLIENTE"	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"FRETEMIN"		 	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"REDESPACHO"		 	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"REGIAO"			 	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"COD_REPR"		 	,1,1)
	oExcel:AddColumn(cWorkSheet,cTitle,"REPRESENT"		 	,1,1)

	cQuery := " SELECT FILIAL=F2_FILIAL, DOCUMENTO=F2_DOC, SERIE=F2_SERIE,EMISSAO=F2_EMISSAO"																									+ chr(13)+chr(10)
	cQuery += " , VALOR_BRUTO=F2_VALBRUT,VALOR_MERCADORIA=F2_VALMERC,VALOR_FRETE= F2_FRETE,TIPO_FRETE= F2_TPFRETE "																				+ chr(13)+chr(10)
	cQuery += " ,UF= F2_EST,MUNICIPIO= A1_MUN,CODIGO_CLIENTE=A1_COD,NOME_CCLIENTE= A1_NOME,ZERAFRETE= A1_ZERAFRE "																				+ chr(13)+chr(10)
	cQuery += " , PERCENT_CLIENTE= IIF(A1_YPRCFRE>0,A1_YPRCFRE,IIF(C5_YREDESP<>'',IIF(ZZA_DESCRI='NORTE',4.5,6),ZZ3_PERCLI)) "																	+ chr(13)+chr(10)
	cQuery += " , IIF(A1_YFRTMIN>0,A1_YFRTMIN,IIF(C5_YREDESP<>'',148,ZZ3_FTRMIN)) FRETEMIN "																									+ chr(13)+chr(10)
	cQuery += " , IIF(C5_YREDESP<>'','SIM','NAO') REDESPACHO "																																	+ chr(13)+chr(10)
	cQuery += " , REGIAO=ZZA_DESCRI "																																							+ chr(13)+chr(10)
	cQuery += " , C5_VEND1 as COD_REPR "																																						+ chr(13)+chr(10)
	cQuery += " , A3_NREDUZ AS REPRESENT "																																						+ chr(13)+chr(10)
	cQuery += " FROM "+RetSqlName("SF2")+" SF2 "																																				+ chr(13)+chr(10)
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL=F2_FILIAL AND A1_COD=F2_CLIENTE AND SA1.D_E_L_E_T_='' "																		+ chr(13)+chr(10)
	cQuery += " LEFT  JOIN "+RetSqlName("ZZA")+" ZZA ON ZZA_FILIAL='"+xFilial("ZZA")+"' AND ZZA_ESTADO LIKE CONCAT('%',IIF(F2_EST='',A1_EST,F2_EST),'%') "										+ chr(13)+chr(10)
	cQuery += " LEFT  JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL=F2_FILIAL AND C5_NOTA=F2_DOC AND C5_SERIE=F2_SERIE AND SC5.D_E_L_E_T_='' "													+ chr(13)+chr(10)
	cQuery += " LEFT  JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL=C5_FILIAL AND A3_COD=C5_VEND1 AND SA3.D_E_L_E_T_='' "																			+ chr(13)+chr(10)
	cQuery += " LEFT  JOIN "+RetSqlName("SZ2")+" SZ2 ON Z2_FILIAL=F2_FILIAL AND Z2_UF=F2_EST AND Z2_MUN=A1_MUN AND SZ2.D_E_L_E_T_='' "															+ chr(13)+chr(10)
	cQuery += " LEFT JOIN ( "																																									+ chr(13)+chr(10)
	cQuery += " "																																												+ chr(13)+chr(10)
	cQuery += " 	SELECT DISTINCT ZZ3.ZZ3_TABELA, X5_CHAVE, ZZ3_PERCLI, ZZ3_FTRMIN "																											+ chr(13)+chr(10)
	cQuery += " 	FROM ( "																																									+ chr(13)+chr(10)
	cQuery += " 	SELECT ZZ3_TABELA, MAX(ZZ3_DTVIGO) ZZ3_DTVIGO "																																+ chr(13)+chr(10)
	cQuery += " 	FROM "+RetSqlName("ZZ3")+" ZZ3 "																																			+ chr(13)+chr(10)
	cQuery += " 	WHERE ZZ3.D_E_L_E_T_='' "																																					+ chr(13)+chr(10)
	cQuery += " 	AND ZZ3_FILIAL IN ('"+xFilial("ZZ3")+"') "																																	+ chr(13)+chr(10)
	cQuery += " 	AND ZZ3_TRANSP='000412' "																																					+ chr(13)+chr(10)
	cQuery += " 	AND ZZ3_TABELA NOT LIKE 'SPR%' "																																			+ chr(13)+chr(10)
	cQuery += " 	GROUP BY ZZ3_TABELA "																																						+ chr(13)+chr(10)
	cQuery += " 	) POL "																																										+ chr(13)+chr(10)
	cQuery += " 	INNER JOIN "+RetSqlName("ZZ3")+" ZZ3 ON POL.ZZ3_TABELA=ZZ3.ZZ3_TABELA AND POL.ZZ3_DTVIGO=ZZ3.ZZ3_DTVIGO AND ZZ3.D_E_L_E_T_='' AND ZZ3.ZZ3_FILIAL='"+xFilial("ZZ3")+"' "		+ chr(13)+chr(10)
	cQuery += " 	LEFT JOIN "+RetSqlName("SX5")+" SX5 ON SX5.D_E_L_E_T_='' AND X5_TABELA='#R' AND X5_FILIAL IN ('"+xFilial("SX5")+"') AND X5_DESCRI=SUBSTRING(ZZ3.ZZ3_TABELA,3,2) "			+ chr(13)+chr(10)
	cQuery += " "																																												+ chr(13)+chr(10)
	cQuery += " ) ZZ3 ON LEFT(ZZ3.ZZ3_TABELA,2)=A1_EST AND X5_CHAVE=Z2_YTIPO "																													+ chr(13)+chr(10)
	cQuery += " "																																												+ chr(13)+chr(10)
	cQuery += " WHERE SF2.D_E_L_E_T_='' "																																						+ chr(13)+chr(10)
	cQuery += " AND F2_FILIAL='"+xFilial("SF2")+"' "																																			+ chr(13)+chr(10)
	cQuery += " AND F2_EMISSAO BETWEEN  '"+dTos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"																											+ chr(13)+chr(10)
	cQuery += " AND F2_SERIE IN ('2','12','30') "																																								
	
	MpSysOpenQuery(cQuery,"QRY")

	dbSelectArea('QRY')
	Dbgotop()

	Count To nTotal
	ProcRegua(nTotal)

	Dbgotop()
	if QRY->(EOF())
		QRY->(DbCloseArea())
		MsgAlert("Não existem registros selecionados, verifique as datas informadas!!!","Atenção")
		Return
	Endif

	While !QRY->(Eof())
		nAtual++
		IncProc('Buscando Registros....' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

			oExcel:AddRow(cWorkSheet,cTitle,{QRY->FILIAL,;
				QRY->DOCUMENTO				 	,;
				QRY->SERIE			      		,;
				dToc(sTod(QRY->EMISSAO))		,;
				QRY->VALOR_BRUTO				,;
				QRY->VALOR_MERCADORIA			,;
				QRY->VALOR_FRETE			  	,;
				QRY->TIPO_FRETE				    ,;
				QRY->UF			  	  			,;
				QRY->MUNICIPIO		      	  	,;
				QRY->CODIGO_CLIENTE				,;
				QRY->NOME_CCLIENTE			  	,;
				QRY->ZERAFRETE				  	,;
				QRY->PERCENT_CLIENTE			,;
				QRY->FRETEMIN				    ,;
				QRY->REDESPACHO			  	    ,;
				QRY->REGIAO			  	        ,;
				QRY->COD_REPR				    ,;
				QRY->REPRESENT})
		QRY->(DbSkip())

	EndDo


	oExcel:Activate()
	oExcel:GetXMLFile(cDir+cFile)
	MsgInfo("Arquivo gerado em "+cDir+cFile)
Return

