#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

#DEFINE ENTER chr(10)+chr(13)

/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | JALT103  | Autor |    Pedro Almeida                              |*
*+------------+------------------------------------------------------------------+*
*|Data        | 24.02.2025                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Job para Atualizar do Status no SICOB					         |*
**********************************************************************************/
User Function JALT103(aParam)

	StartJob("u_ALT103",GetEnvServer(),.F., aParam)

Return

/*************************************************************************************************************
*+----------------------------------------------------------------------------------------------------------+*
*|Funcao      | ALT103  | Autor |    Pedro Almeida                               							|*
*+------------+---------------------------------------------------------------------------------------------+*
*|Data        | 24.02.2025                                                       							|*
*+------------+---------------------------------------------------------------------------------------------+*
*|Descricao   | Verifica pedidos no Status 104 que os clientes não possuem divida e Atualiza para o 103     |*
*************************************************************************************************************/
User Function ALT103(aParam)

	Local cQuery1 := ''
	Local cFil := ""
	Local cEmp := ""
	Local cNum
	Local cStatus

	//Verifica se o aParam não é nulo
	If ValType(aParam) == 'U'
		cFil := cFilAnt
		cEmp := cEmpAnt
	Else
		cEmp := aParam[1]
		cFil := aParam[2]
	EndIf

	RpcSetEnv(cEmp,cFil)

  	cQuery1 := " SELECT C5_CONDPAG,C5_NUM,C5_YSTATUS,C5_CLIENTE, C5_YSTATUS,C5_EMISSAO,SC5.R_E_C_N_O_ AS REGISTRO,A1_GPEMP	"
  	cQuery1 += " FROM "+RetSqlName("SC5")+" SC5	"
  	cQuery1 += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON C5_FILIAL = A1_FILIAL AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
  	cQuery1 += " WHERE C5_YSTATUS = '104' AND A1_GPEMP = ''	"
  	cQuery1 += " AND SC5.D_E_L_E_T_ = ''	"
  	cQuery1 += " AND NOT EXISTS(SELECT E1_NUM,E1_VALOR,E1_SALDO  	"
  	cQuery1 += " FROM "+RetSqlName("SE1")+" SE1 WHERE E1_FILIAL = C5_FILIAL AND E1_CLIENTE = C5_CLIENTE AND SE1.D_E_L_E_T_ = ''	"
  	cQuery1 += " 	AND E1_SALDO <> 0 	"
  	cQuery1 += " 	AND E1_TIPO IN ('NF','NDC') 	"
  	cQuery1 += " 	AND E1_VENCREA < CONVERT(date, GETDATE())  )	"
  	cQuery1 += " ORDER BY SC5.C5_CLIENTE,C5_NUM	"

	MPSysOpenQuery(cQuery1,"QR1")
	
	dbSelectArea('SC5')
	SC5->(dbSetOrder(1))
	//Enquanto tiver pedidos no com os parametros filtrados
	While !QR1->(Eof())
		cNum := Alltrim(QR1->C5_NUM)
		cStatus := Alltrim(QR1->C5_YSTATUS)

		//Posiciona no registro, roda o rastro para o status atual e depois roda o rastro para o rastro novo
        SC5->(DbGoTo(QR1->REGISTRO))
        U_RST_PED(cNum,cStatus,"AUTOMATICO")
        	if SC5->(RecLock("SC5",.f.))
        	  	 SC5->C5_YSTATUS="103" 
        	   SC5->(MsUnLock())
        	endif
        U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")
		U_LogPed("ALT103",cNum,"","Pedido "+Alltrim(cNum)+" movido para o status 103 pois o cliente nao possui titulos pendentes, Protheus - Filial 10 " ,date(),time(),.t.)
        QR1->(DbSkip())
    Enddo

	QR1->(dbCloseArea())
	RpcClearEnv()
Return

/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | JAlt104D  | Autor |    Pedro Almeida                             |*
*+------------+------------------------------------------------------------------+*
*|Data        | 24.02.2025                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Job para Atualizar do Status 104, Clientes Inadimp e Portador Dev|*
**********************************************************************************/
User Function JAlt104D(aParam)

	StartJob("u_ALT104DV",GetEnvServer(),.F., aParam)
	
Return

/**********************************************************************************************************************************
*+-------------------------------------------------------------------------------------------------------------------------------+*
*|Funcao      | ALT104DV  | Autor |    Pedro Almeida                               								 				 |*
*+------------+------------------------------------------------------------------------------------------------------------------+*
*|Data        | 24.02.2025                                                       								 				 |*
*+------------+------------------------------------------------------------------------------------------------------------------+*
*|Descricao   | Verifica pedidos no Status 104, que os clientes possuem titulos vencidos, Portador Dev e Atualiza para o 103     |*
**********************************************************************************************************************************/
User Function ALT104DV(aParam)

	Local cQuery2 := ''
	Local cFil := ""
	Local cEmp := ""
	Local cNum
	Local cStatus

	//Verifica se o aParam não é nulo
	If ValType(aParam) == 'U'
		cFil := cFilAnt
		cEmp := cEmpAnt
	Else
		cEmp := aParam[1]
		cFil := aParam[2]
	EndIf

	RpcSetEnv(cEmp,cFil)

	cQuery2 := " SELECT C5_CONDPAG,C5_NUM,C5_YSTATUS,C5_CLIENTE, C5_YSTATUS,C5_EMISSAO,SC5.R_E_C_N_O_ AS REGISTRO "
	cQuery2 += " FROM "+RetSqlName("SC5")+" SC5 "
	cQuery2 += " INNER JOIN SA1090 SA1 ON A1_FILIAL = C5_FILIAL AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = '' "
	cQuery2 += " WHERE C5_YSTATUS = '104' "
	cQuery2 += " AND SC5.D_E_L_E_T_ = '' "
	cQuery2 += " AND  A1_GPEMP = '' "
	cQuery2 += " AND EXISTS(SELECT E1_NUM,E1_VALOR,E1_SALDO   "
	cQuery2 += " FROM "+RetSqlName("SE1")+" SE1 WHERE E1_FILIAL = C5_FILIAL AND E1_CLIENTE = C5_CLIENTE AND SE1.D_E_L_E_T_ = '' "
	cQuery2 += " AND E1_PORTADO = 'DEV' "
	cQuery2 += " AND E1_SALDO <> 0  "
	cQuery2 += " AND E1_TIPO IN ('NF','NDC')  "
	cQuery2 += " AND E1_VENCREA < CONVERT(date, GETDATE()) ) " 
    cQuery2 += " AND NOT EXISTS (  "
    cQuery2 += " SELECT 1  "
    cQuery2 += " FROM "+RetSqlName("SE1")+" SE1  "
    cQuery2 += " WHERE SE1.E1_FILIAL = '10'   "
    cQuery2 += " AND SE1.E1_CLIENTE = SC5.C5_CLIENTE  "
    cQuery2 += " AND SE1.D_E_L_E_T_ = '' "
    cQuery2 += " AND SE1.E1_PORTADO <> 'DEV'  "
    cQuery2 += " AND SE1.E1_SALDO <> 0  "
    cQuery2 += " AND E1_TIPO IN ('NF','NDC') "
    cQuery2 += " AND E1_VENCREA < CONVERT(date, GETDATE()) )  "
	cQuery2 += " ORDER BY SC5.C5_CLIENTE,C5_NUM " 

	MPSysOpenQuery(cQuery2,"QR2")
	
	dbSelectArea('SC5')
	SC5->(dbSetOrder(1))
	//Enquanto tiver pedidos com os parametros filtrados
	While !QR2->(Eof())
		cNum := Alltrim(QR2->C5_NUM)
		cStatus := Alltrim(QR2->C5_YSTATUS)

		//Posiciona no registro, roda o rastro para o status atual e depois roda o rastro para o rastro novo
        SC5->(DbGoTo(QR2->REGISTRO))
        U_RST_PED(cNum,cStatus,"AUTOMATICO")
        	if SC5->(RecLock("SC5",.f.))
        	  	 SC5->C5_YSTATUS="103" 
        	   SC5->(MsUnLock())
        	endif
        U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")
        QR2->(DbSkip())
    Enddo

	QR2->(dbCloseArea())
	RpcClearEnv()
Return

/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | JCANCV10  | Autor |    Pedro Almeida                             |*
*+------------+------------------------------------------------------------------+*
*|Data        | 24.02.2025                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Job para cancelar os pedidos no 104 que estão vencidos há 10 dias|*
**********************************************************************************/
User Function JCANCV10(aParam)

	StartJob("u_CANCV10",GetEnvServer(),.F., aParam)

Return

/*****************************************************************************************************************
*+---------------------------------------------------------------------------------------------------------------+*
*|Funcao      | CANCV10  | Autor |    Pedro Almeida                               								 |*
*+------------+--------------------------------------------------------------------------------------------------+*
*|Data        | 24.02.2025                                                       								 |*
*+------------+--------------------------------------------------------------------------------------------------+*
*|Descricao   | Verifica pedidos no Status 104 que estão vencidos há x dias e não tem data de negociação         |*
******************************************************************************************************************/
User Function CANCV10(aParam)

	Local cQuery3 := ''
	Local cFil := ""
	Local cEmp := ""
	Local cNum
	Local cStatus
	Local nDias
	Local dDataNeg
	Local nDiasNeg

	//Verifica se o aParam não é nulo
	If ValType(aParam) == 'U'
		cFil := cFilAnt
		cEmp := cEmpAnt
	Else	
		cEmp := aParam[1]
		cFil := aParam[2]
	EndIf
	
	RpcSetEnv(cEmp,cFil)

	cQuery3 := " SELECT ZZT_FILIAL AS FILIAL, ZZT_NUM AS PEDIDO,ZZT_STATUS AS STATUS, ZZT_DT_INI AS DATA_ENTRADA,ZZT_DT_FIM AS DATA_FINAL  "
	cQuery3 += " FROM "+RetSqlName("ZZT")+" ZZT  "
	cQuery3 += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON ZZT_FILIAL = C5_FILIAL AND ZZT_NUM = C5_NUM AND SC5.D_E_L_E_T_  = '' "
	cQuery3 += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON C5_FILIAL = A1_FILIAL AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery3 += " WHERE ZZT_FILIAL = '10' AND ZZT_STATUS = '104' AND ZZT_DT_FIM = '' AND ZZT.D_E_L_E_T_  = '' AND A1_GPEMP = '' "
	cQuery3 += " ORDER BY DATA_ENTRADA DESC  "

	MPSysOpenQuery(cQuery3,"QR3")

	nDiasNeg := GetMV("FA_DIASNG",,15)  //Parametro para a quantidade de dias definidos no cancelamento

	dbSelectArea('SC5')
	SC5->(dbSetOrder(1))
	//Enquanto tiver pedidos no com os parametros filtrados
	While !QR3->(Eof())
		cNum := Alltrim(QR3->PEDIDO)
		cStatus := Alltrim(QR3->STATUS)
		
        If SC5->(DbSeek(QR3->FILIAL+QR3->PEDIDO))

			nDias := DateWorkDay(DataValida(sTod(QR3->DATA_ENTRADA)), DataValida(Date() , .T.), .F.,.F.,.F. )

			dDataNeg := Posicione("ZAL",1,xFilial("ZAL")+QR3->PEDIDO,"ZAL_DTNEG")

			//passou dos dias definidos no status 104 e a Data de Negociação está vazio? Cancela
			Do Case 
			Case nDias > nDiasNeg .And. Empty(dDataNeg)
		
				U_RST_PED(cNum,cStatus,"AUTOMATICO")
        		if SC5->(RecLock("SC5",.f.))
        	  		 SC5->C5_YSTATUS="012" 
        	  	   SC5->(MsUnLock())
        		endif
        		U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")

				oPedi:=PedidoFA():Create()
      			oPedi:cPedido := cNum
	  			oPedi:AlteraPedido('22','002') 
      			FreeObj(oPedi)

				U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")
        		if SC5->(RecLock("SC5",.f.))
        	  		 SC5->C5_YSTATUS="007" 
        	  	   SC5->(MsUnLock())
        		endif
        		U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")

				U_LogPed("CANCV10",cNum,"","Pedido Cancelado com "+cValtoChar(nDiasNeg)+" dias no crédito e sem Dt de negociacao - "+Alltrim(cNum)+" no Protheus, Filial 10 " ,date(),time(),.t.)
				
				//passou dos dias definidos no status 104, a data de negociação está preenchida mas a data de negociação é menor que a data atual? Cancela
			Case nDias > nDiasNeg .And. !Empty(dDataNeg) .and. dDataNeg < DataValida(Date(),.T.)
			
				U_RST_PED(cNum,cStatus,"AUTOMATICO")
        		if SC5->(RecLock("SC5",.f.))
        	  		 SC5->C5_YSTATUS="012" 
        	  	   SC5->(MsUnLock())
        		endif
        		U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")

				oPedi:=PedidoFA():Create()
      			oPedi:cPedido := cNum
	  			oPedi:AlteraPedido('22','002') 
      			FreeObj(oPedi)

				U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")
        		if SC5->(RecLock("SC5",.f.))
        	  		 SC5->C5_YSTATUS="007" 
        	  	   SC5->(MsUnLock())
        		endif
        		U_RST_PED(cNum,SC5->C5_YSTATUS,"AUTOMATICO")

				U_LogPed("CANCV10",cNum,"","Pedido Cancelado com "+cValtoChar(nDiasNeg)+" dias no crédito e com Dt de negociacao vencida - "+Alltrim(cNum)+" no Protheus, Filial 10 " ,date(),time(),.t.)
			EndCase
		Endif
		QR3->(DbSkip())
    Enddo

	QR3->(dbCloseArea())
	RpcClearEnv()
Return
