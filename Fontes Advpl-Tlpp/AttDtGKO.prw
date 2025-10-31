#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"



/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | ENTDTGKO  | Autor |    Pedro Almeida                             |*
*+------------+------------------------------------------------------------------+*
*|Data        | 20.03.2025                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Chamada do job que traz as datas de entrega do pedido            |*
**********************************************************************************/
User Function ENTDTGKO(aParam)

	StartJob("u_AttGKO",GetEnvServer(),.F., aParam)


Return

/************************************************************************************************************
*+----------------------------------------------------------------------------------------------------------+*
*|Funcao      | AttGKO  | Autor |    Pedro Almeida                               							|*
*+------------+---------------------------------------------------------------------------------------------+*
*|Data        |  20.03.2025                                                       							|*
*+------------+---------------------------------------------------------------------------------------------+*
*|Descricao   | Traz do GKO a data de entrega do pedido, baseado na ocorrência 822 (Entregue Normalmente)   |*
************************************************************************************************************/
User Function AttGKO(aParam)

	Local cQuery1 := ''
	Local cFil := ""
	Local cEmp := ""
	Local cNum
    Local cDbLink 
    Local dData   

	//Verifica se o aParam não é nulo
	If ValType(aParam) == 'U'
		cFil := cFilAnt
		cEmp := cEmpAnt
	Else
		cEmp := aParam[1]
		cFil := aParam[2]  //Campo ZAL_DTENT Data, tamanho 8, Data Entrega, Data de Entrega do Pedido / Parametro para trazer a data de entrega FA_DTGKO
	EndIf

	RpcSetEnv(cEmp,cFil)

	cDbLink := GetMv("FA_GKODB",,"GKOSCF") // trocar para "GKOSCF_TST" na dev
	dData   := GetMv("FA_DTGKO",,sTod("20250101"))
    
   	cQuery1 := " SELECT IDTIPOOCORRENCIA,DTOCORRENCIA,ZAL_PEDIDO,C5_NOTA,C5_SERIE,C5_CLIENTE,C5_EMISSAO,ZAL.R_E_C_N_O_ AS REGISTROS_ZAL,ZAL_DTENT DATA_ENTREGA "
    cQuery1 += " FROM "+RetSqlName("SC5")+" SC5"
    cQuery1 += " INNER JOIN "+RetSqlName("ZAL")+" ZAL ON ZAL_FILIAL = C5_FILIAL AND ZAL_PEDIDO = C5_NUM AND ZAL.D_E_L_E_T_ = ''"
    cQuery1 += " INNER JOIN "+cDbLink+".GKOSCF.FMNOTA NOTA ON SUBSTRING(C5_NOTA,2,8)=NOTA.CDNOTA AND C5_SERIE=NOTA.CDSERIE"
    cQuery1 += " INNER JOIN "+cDbLink+".GKOSCF.FMOCORRE FMOCORRE ON FMOCORRE.IDMOVIMENTO = IDNOTA "
    cQuery1 += " WHERE C5_FILIAL = '10' AND SC5.D_E_L_E_T_ = '' AND C5_DTCANC = '' AND ZAL_DTENT = '' "
    cQuery1 += " AND FMOCORRE.IDTIPOOCORRENCIA = '822' "
    cQuery1 += " AND C5_EMISSAO >= '"+dToS(dData)+"' " 

	MPSysOpenQuery(cQuery1,"QRP")
	
	dbSelectArea('ZAL')
	ZAL->(dbSetOrder(1))
	//Enquanto tiver pedidos com os parametros filtrados
	While !QRP->(Eof())
		cNum := Alltrim(QRP->ZAL_PEDIDO)

        ZAL->(DbGoTo(QRP->REGISTROS_ZAL))
        	if ZAL->(RecLock("ZAL",.f.))
        	  	 ZAL->ZAL_DTENT :=  QRP->DTOCORRENCIA
        	   ZAL->(MsUnLock())
			U_LogPed("AttGKO",cNum,"","Adicionado Data de Entrega "+cValtoChar(Alltrim(QRP->DTOCORRENCIA))+" do Pedido - "+Alltrim(cNum)+" vindo do GKO para o Protheus,Filial 10 e Tabela ZAL090 " ,date(),time(),.t.)
        	endif
        QRP->(DbSkip())
    Enddo

	QRP->(dbCloseArea())
	RpcClearEnv()
Return
