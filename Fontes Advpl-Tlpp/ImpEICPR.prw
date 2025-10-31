#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'Topconn.ch'

/*
+-----------------+---------+-----------------------------------------------------------------------------------------------------------------------
| TAG             | Mantis  | Analista e Descrição da Rotina
+-----------------+---------+-----------------------------------------------------------------------------------------------------------------------
|PHADA 19/12/2024 |         | Pedro Almeida - Rotina de importação via csv para Solicitação de Importação (EIC)
+-----------------+---------+-----------------------------------------------------------------------------------------------------------------------
*/
User Function ImpEICPR(nRadio)

	Local nPos
	Local cLinha := ''
	Local aLinha := {}
	Local aItens := {}
	Private oTI:=TI():New()

	lRet:=oTI:ImpCsv(.f.)

	If !lRet
		return
	endif

	For nPos:=2 to Len(oTI:aCsv)
		cLinha  := StrTran(oTI:aCsv[nPos],"",'')
		aLinha  := Separa(cLinha,';',.f.)
		aadd(aItens,aLinha)
	Next

	If Len(aItens) > 0
		Processa({|| Preenche(aItens,nRadio)}, "Processando linhas...")
	endif

	GETDREFRESH()

Return

Static Function Preenche(aItens,nRadio)

	Local aArea := GetArea()
	Local nx
	Local aCodigos := {}
	Local cErro := ''
	Local nTotal := Len(aItens)
	
	ProcRegua(nTotal)

	Do Case
		//Caso seja quantidade padrão
	Case nRadio == 1

		DbSelectArea('TRB')
		For nx := 1 to Len(aItens)
		
			If !Empty(TRB->W1_COD_I)
				oMSSelect:AddLine()
			EndIf
			//verificando se o produto já foi posto no grid (Não foi possivel verificar pelo aCOLS).
			If Len(aCodigos) > 0
				if aScan(aCodigos, {|x|x == Alltrim(aItens[nx][1])}) <> 0
					Alert("Produto "+Alltrim(aItens[nx][1])+" já foi posto.","Atencao")
					Loop
				Endif
			Endif

			If !SB1->(DBSEEK(xFilial("SB1")+Alltrim(aItens[nx][1])))
				cErro +="Produto "+Alltrim(aItens[nx][1])+" da linha "+cValToChar(nx)+" não foi encontrado no cadastro" + chr(13)+chr(10)
				Loop
			Endif
			
			If !Alltrim(Posicione("SB1",1,xFilial("sb1")+ Alltrim(aItens[nx][1]),"B1_PROC")) == Alltrim(SW0->W0_FABR)
				cErro +="Produto "+Alltrim(aItens[nx][1])+" da linha "+cValToChar(nx)+" não está amarrado ao Fornecedor do Cabecalho" + chr(13)+chr(10)
				Loop
			Endif

			TRB->(RECLOCK("TRB",.F.))
				TRB->W1_COD_I :=  Alltrim(aItens[nx][1])
				TRB->W1_QTDE:= Val(aItens[nx][2])
			TRB->(MSUNLOCK())

			//Validações para o campo acionar os gatilhos
			M->W1_COD_I := TRB->W1_COD_I
			U_V_ITEM_SI("SW1")
			U_RDVALID("W1_COD_I")
			If ExistTrigger("W1_COD_I")
				RunTrigger(2, nx,,"W1_COD_I" )
				EvalTrigger()
			Endif

			M->W1_QTDE := TRB->W1_QTDE
			U_RDVALID("W1_QTDE")
			If ExistTrigger("W1_QTDE")
				RunTrigger(2, nx,,"W1_QTDE" )
				EvalTrigger()
			Endif

			IncProc("Importando linha " + cValToChar(nx) + " de " + cValToChar(nTotal) + "...")
		Next
			oMSSelect:AddLine()
		//Caso seja quantidade por caixa
	Case nRadio == 2

		DbSelectArea('TRB')
		For nx := 1 to Len(aItens)

			If !Empty(TRB->W1_COD_I)
				oMSSelect:AddLine()
			EndIf
			//Verificando se o produto já foi posto no grid (Não foi possivel verificar pelo aCOLS).
			If Len(aCodigos) > 0
				if aScan(aCodigos, {|x|x == Alltrim(aItens[nx][1])}) <> 0
					Alert("Produto "+Alltrim(aItens[nx][1])+" já foi posto.","Atencao")
					Loop
				Endif
			Endif

			If !SB1->(DBSEEK(xFilial("SB1")+Alltrim(aItens[nx][1])))
				cErro +="Produto "+Alltrim(aItens[nx][1])+" da linha "+cValToChar(nx)+" não foi encontrado no cadastro" + chr(13)+chr(10)
				Loop
			Endif

			If !Alltrim(Posicione("SB1",1,xFilial("sb1")+ Alltrim(aItens[nx][1]),"B1_PROC")) == Alltrim(M->W0_FABR)
				cErro +="Produto "+Alltrim(aItens[nx][1])+" da linha "+cValToChar(nx)+" não está amarrado ao Fornecedor do Cabecalho" + chr(13)+chr(10)
				Loop
			Endif

			TRB->(RECLOCK("TRB",.F.))
				TRB->W1_COD_I :=  Alltrim(aItens[nx][1])
				TRB->W1_QTD_CX:= Val(aItens[nx][2])
			TRB->(MSUNLOCK())

			//Validações para o campo acionar os gatilhos
			M->W1_COD_I := TRB->W1_COD_I
			U_V_ITEM_SI("SW1")
			U_RDVALID("W1_COD_I")
			If ExistTrigger("W1_COD_I")
				RunTrigger(2, nx,,"W1_COD_I" )
				EvalTrigger()
			Endif

			M->W1_QTD_CX := TRB->W1_QTD_CX
			U_RDVALID("W1_QTD_CX")
			If ExistTrigger("W1_QTD_CX")
				RunTrigger(2, nx,,"W1_QTD_CX" )
				EvalTrigger()
			Endif
			aadd(aCodigos,aItens[nx][1])
			IncProc("Importando linha " + cValToChar(nx) + " de " + cValToChar(nTotal) + "...") 
		Next
		oMSSelect:AddLine()
		//Caso seja quantidade por duzia
	Case nRadio == 3

		DbSelectArea('TRB')
		For nx := 1 to Len(aItens)

			If !Empty(TRB->W1_COD_I)
				oMSSelect:AddLine()
			EndIf
			//Verificando se o produto já foi posto no grid (Não foi possivel verificar pelo aCOLS).
			If Len(aCodigos) > 0
				if aScan(aCodigos, {|x|x == Alltrim(aItens[nx][1])}) <> 0
					Alert("Produto "+Alltrim(aItens[nx][1])+" já foi posto.","Atencao")
					Loop
				endif
			Endif

			IF !SB1->(DBSEEK(xFilial("SB1")+Alltrim(aItens[nx][1])))
				cErro +="Produto "+Alltrim(aItens[nx][1])+" da linha "+cValToChar(nx)+" não foi encontrado no cadastro"+ chr(13)+chr(10)
				Loop
			Endif

			If !Alltrim(Posicione("SB1",1,xFilial("sb1")+ Alltrim(aItens[nx][1]),"B1_PROC")) == Alltrim(SW0->W0_FABR)
				cErro +="Produto "+Alltrim(aItens[nx][1])+" da linha "+cValToChar(nx)+" não está amarrado ao Fornecedor do Cabecalho" + chr(13)+chr(10)
				Loop
			Endif

			TRB->(RECLOCK("TRB",.F.))
				TRB->W1_COD_I :=  Alltrim(aItens[nx][1])
				TRB->W1_QTD_DZ:= Val(aItens[nx][2])
			TRB->(MSUNLOCK())

			//Validações para o campo acionar os gatilhos
			M->W1_COD_I := TRB->W1_COD_I
			U_V_ITEM_SI("SW1")
			U_RDVALID("W1_COD_I")
			If ExistTrigger("W1_COD_I")
				RunTrigger(2, nx,,"W1_COD_I" )
				EvalTrigger()
			Endif

			M->W1_QTD_DZ := TRB->W1_QTD_DZ
			U_RdValid("W1_QTD_DZ")
			If ExistTrigger("W1_QTD_DZ")
				RunTrigger(2, nx,,"W1_QTD_DZ" )
				EvalTrigger()
			Endif

			IncProc("Importando linha " + cValToChar(nx) + " de " + cValToChar(nTotal) + "...")
		Next
			oMSSelect:AddLine()
	End
	oMSSelect:Refresh()
	RestArea(aArea)
	//se houver erro, chama função para exibir o log.
	If !Empty(cErro)
		u_LogProd(cErro)
	Endif
Return


User Function LogProd(cMsg, cTitulo, nTipo, lEdit)
	Local lRetMens := .F.
	Local oDlgMens
	Local oBtnOk, cTxtConf := ""
	Local oFntTxt := TFont():New("Lucida Console",,-015,,.F.,,,,,.F.,.F.)
	Default cMsg    := "..."
	Default cTitulo := "Log Produtos não encontrados"
	Default nTipo   := 1 // 1=Ok; 2= Confirmar e Cancelar
	Default lEdit   := .F.

	cTxtConf:='&Ok'
	//Criando a janela centralizada com os botões
	DEFINE MSDIALOG oDlgMens TITLE cTitulo FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL
	//Get com o Log
	@ 002, 004 GET oMsg VAR cMsg OF oDlgMens MULTILINE SIZE 191, 121 FONT oFntTxt COLORS 0, 16777215 HSCROLL PIXEL
	If !lEdit
		oMsg:lReadOnly := .T.
	EndIf
	@ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 019 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
	ACTIVATE MSDIALOG oDlgMens CENTERED

Return lRetMens
