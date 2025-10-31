#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/***************************************************************************************************************************************************
*+------------------------------------------------------------------------------------------------------------------------------------------------+*
*|Funcao      | TelaRej  | Autor |    Pedro Almeida                                                                                               |*
*+------------+-----------------------------------------------------------------------------------------------------------------------------------+*
*|Data        | 07.11.2024                                                                                                                        |*
*+------------+-----------------------------------------------------------------------------------------------------------------------------------+*
*|Descricao   | Rotina para gerar o Browser de Liberação de Titulos Rejeitados                                                                    |*
*+------------+-----------------------------------------------------------------------------------------------------------------------------------+*/

User function TelaRej()
    Local aArea := FWGetArea()
    fMontaTela()
    
    FWRestArea(aArea)
Return
 
/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | fMontaTela  | Autor |    Pedro Almeida                           |*
*+------------+------------------------------------------------------------------+*
*|Data        | 07.11.2024                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Função que realiza a montagem do Browser                         |*
**********************************************************************************/
Static Function fMontaTela()

    Local aArea         := GetArea()
    Local aCampos := {}
    Local oTempTable := Nil
    Local aColunas := {}
    Local aSeek := {}
    Local cFontPad    := 'Tahoma'
    Local oFontGrid   := TFont():New(cFontPad,,-14)
    

    Private oDlgMark
    Private oPanGrid
    Private oMarkBrowse
    Private cAliasTmp := GetNextAlias()
    Private aRotina   := MenuDef()
    Private lImpAuto  := .F.

    //tamanho janela
    Private aTamanho := MsAdvSize()
    Private nJanLarg := aTamanho[5]
    Private nJanAltu := aTamanho[6]
      
    //Adiciona as colunas que serão criadas na Tabela temporária
    aAdd(aCampos, { 'OK', 'C', 2, 0}) //Flag para marcação
    aAdd(aCampos, { 'E1_PREFIXO'     , 'C', TamSx3("E1_PREFIXO")[1], 0})
    aAdd(aCampos, { 'E1_NUM'         , 'C', TamSx3("E1_NUM")[1]    , 0})
    aAdd(aCampos, { 'E1_PARCELA'     , 'C', TamSx3("E1_PARCELA")[1]    , 0})
    aAdd(aCampos, { 'E1_VENCTO'      , 'C', TamSx3("E1_VENCTO")[1]    , 0})
    aAdd(aCampos, { 'E1_CLIENTE'     , 'C', TamSx3("E1_CLIENTE")[1], 0})
    aAdd(aCampos, { 'E1_NOMCLI'      , 'C', TamSx3("E1_NOMCLI")[1] , 0})
    aAdd(aCampos, { 'E1_VALOR'       , 'N', TamSx3("E1_VALOR")[1]  , 2})
    aAdd(aCampos, { 'E1_SALDO'       , 'N', TamSx3("E1_SALDO")[1]  , 2})
    aAdd(aCampos, { 'E1_NUMBCO'      , 'C', TamSx3("E1_NUMBCO")[1]  , 0})
    aAdd(aCampos, { 'E1_AGEDEP'      , 'C', TamSx3("E1_AGEDEP")[1] , 0})
    aAdd(aCampos, { 'E1_PORTADO'     , 'C', TamSx3("E1_PORTADO")[1], 0})
    aAdd(aCampos, { 'E1_SITUACA'     , 'C', TamSx3("E1_SITUACA")[1], 0})
    aAdd(aCampos, { 'E1_HIST'        , 'C', TamSx3("E1_HIST")[1]   , 0})
    aAdd(aCampos, { 'E1_FLAGFA'      , 'C', TamSx3("E1_FLAGFA")[1] , 0})
    aAdd(aCampos, { 'E1_NUMBOR'      , 'C', TamSx3("E1_NUMBOR")[1] , 0})
    aAdd(aCampos, { 'Recno'          , 'N', 999999, 0})                 
 
    //criando e populando a tabela temporaria
    oTempTable:= FWTemporaryTable():New(cAliasTmp)
    oTempTable:SetFields( aCampos )
    oTempTable:AddIndex("01", {"E1_NUM"})
    oTempTable:AddIndex("02", {"E1_NUMBCO"})
  

    oTempTable:Create()  
   
    Processa({|| fPopula()}, 'Processando...')
    aAdd(aSeek,{"No. Titulo" ,{{"","C",TamSx3("E1_NUM")[1],0,"No. Titulo" ,"@!"}} } )
    aAdd(aSeek,{"Vencimento" ,{{"","C",TamSx3("E1_NUMBCO")[1],0,"Nosso Número" ,"@!"}} } )
    
    //Adiciona as colunas que serão exibidas no FWMarkBrowse
    aColunas := fCriaCols()
      
    //Criando a janela
    DEFINE MSDIALOG oDlgMark TITLE 'Re-geração de boletos' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
        oMarkBrowse := FWMarkBrowse():New()
        oMarkBrowse:SetAlias(cAliasTmp)                
        oMarkBrowse:SetDescription('Re-geração de boletos')
        oMarkBrowse:DisableFilter()
        oMarkBrowse:DisableConfig()
        oMarkBrowse:SetSeek(.T.,aSeek) //habilitando pesquisa
        oMarkBrowse:DisableSaveConfig()
        oMarkBrowse:SetFontBrowse(oFontGrid)
        oMarkBrowse:SetFieldMark('OK')
        oMarkBrowse:SetTemporary(.T.)
        oMarkBrowse:SetColumns(aColunas)
        oMarkBrowse:SetOwner(oPanGrid)
        oMarkBrowse:Activate()
    ACTIVATE MsDialog oDlgMark CENTERED
     
    //Deleta a temporária e desativa a tela de marcação

    
    oTempTable:Delete()
    oMarkBrowse:DeActivate()
     
    RestArea(aArea)
Return
 

//Função Estática para os botões do Browser
Static Function MenuDef()
    Local aRotina := {}
      
    //Criação das opções
    ADD OPTION aRotina TITLE 'Continuar'  ACTION 'u_LimpaRej()'     OPERATION 2 ACCESS 0

Return aRotina
 
//Função para popular a tabela temporaria
Static Function fPopula()
    Local cQuery := ''
    Local nTotal := 0
    Local nAtual := 0
    Local oSRetorna   
    Local oRadMenu1
    Local oSContinua
    Local oSRetorna     
    Local oDlg3
    Local cContinuaRel
    Private nRadMenu1 := 1
 
    DEFINE MSDIALOG oDlg3 TITLE "Seleção de títulos" FROM 000, 000  TO 200, 450 COLORS 0, 16777215 PIXEL

    @ 012, 048 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "Rejeitados","Prorrogados" SIZE 117, 043 OF oDlg3 COLOR 0, 16777215 PIXEL
    DEFINE SBUTTON oSRetorna FROM 077, 026 TYPE 02 OF oDlg3  ENABLE ACTION (cContinuaRel:="1",oDlg3:End())
    DEFINE SBUTTON oSContinua FROM 078, 155 TYPE 01 OF oDlg3 ENABLE ACTION (cContinuaRel:="2",oDlg3:End())
    oSRetorna:cToolTip  := "Cancela"
    oSContinua:cToolTip := "Confirma"

    ACTIVATE MSDIALOG oDlg3 CENTERED

    If cContinuaRel == "1"         
       Return
    EndIf
	
     //Retirada o E1_SITUACA='0' da filtragem
    cQuery := "  SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_NOMCLI, E1_VENCTO, E1_VALOR, E1_SALDO, E1_NUMBCO, E1_AGEDEP, E1_PORTADO, E1_SITUACA, E1_HIST, E1_FLAGFA, E1_NUMBOR, R_E_C_N_O_ FROM "+RetSqlName("SE1")+""
	cQuery += "  WHERE E1_FILIAL = '10'" 
    If nRadMenu1 == 1
       cQuery += "  AND E1_HIST LIKE '%03-ENTRADA REJEITADA%'" 
    else
       cQuery += "  AND E1_HIST LIKE '%PRORROGADO%'"
    endif
	cQuery += "  AND E1_SALDO <> 0    " 
	cQuery += "  AND E1_PORTADO <> 'COB'  " 
	cQuery += "  AND D_E_L_E_T_ = ''  " 
	cQuery += "  ORDER BY E1_EMISSAO, E1_PREFIXO, E1_NUM, E1_PARCELA
	MPSysOpenQuery(cQuery,"QRY")

    //Definindo o tamanho da régua
    DbSelectArea('QRY')
    Count to nTotal
    ProcRegua(nTotal)
    QRY->(DbGoTop())
 
    //Enquanto houver registros, adiciona na tabela temporária
    While ! QRY->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->OK := Space(2)
            (cAliasTmp)->E1_PREFIXO := QRY->E1_PREFIXO
            (cAliasTmp)->E1_NUM     := QRY->E1_NUM
            (cAliasTmp)->E1_PARCELA := QRY->E1_PARCELA
            (cAliasTmp)->E1_VENCTO  := QRY->E1_VENCTO
            (cAliasTmp)->E1_CLIENTE := QRY->E1_CLIENTE
            (cAliasTmp)->E1_NOMCLI  := QRY->E1_NOMCLI
            (cAliasTmp)->E1_VALOR   := QRY->E1_VALOR
            (cAliasTmp)->E1_SALDO   := QRY->E1_SALDO
            (cAliasTmp)->E1_NUMBCO  := QRY->E1_NUMBCO
            (cAliasTmp)->E1_AGEDEP  := QRY->E1_AGEDEP  
            (cAliasTmp)->E1_PORTADO := QRY->E1_PORTADO
            (cAliasTmp)->E1_SITUACA := QRY->E1_SITUACA
            (cAliasTmp)->E1_HIST    := QRY->E1_HIST  
            (cAliasTmp)->E1_FLAGFA  := QRY->E1_FLAGFA 
            (cAliasTmp)->E1_NUMBOR  := QRY->E1_NUMBOR 
            (cAliasTmp)->Recno      := QRY->R_E_C_N_O_ 
        (cAliasTmp)->(MsUnlock())
 
        QRY->(DbSkip())
    EndDo
    QRY->(DbCloseArea())
    (cAliasTmp)->(DbGoTop())
Return
 

//Função para criar as colunas do browser 
Static Function fCriaCols()
    Local nAtual       := 0 
    Local aColunas := {}
    Local aEstrut  := {}
    Local oColumn
     
    //parâmetros da estrutura
    //[1] - Campo da Tabela Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    
    aAdd(aEstrut, { 'E1_PREFIXO', 'Prefixo', 'C'     , TamSx3("E1_PREFIXO")[1], 0, ''})
    aAdd(aEstrut, { 'E1_NUM'    , 'Nº Titulo', 'C'   , TamSx3("E1_NUM")[1]    , 0,''}) 
    aAdd(aEstrut, { 'E1_PARCELA', 'Parcela', 'C'     , TamSx3("E1_PARCELA")[1]    , 0,''}) 
    aAdd(aEstrut, { 'E1_VENCTO' , 'Vencimento', 'C'  , TamSx3("E1_VENCTO")[1]    , 0,''}) 
    aAdd(aEstrut, { 'E1_CLIENTE', 'Cod Cliente', 'C' , TamSx3("E1_CLIENTE")[1], 0,''}) 
    aAdd(aEstrut, { 'E1_NOMCLI' , 'Nome Cliente', 'C', TamSx3("E1_NOMCLI")[1] , 0,''}) 
    aAdd(aEstrut, { 'E1_VALOR'  , 'Valor', 'N'       , TamSx3("E1_VALOR")[1]  , TamSx3("E1_VALOR")[2],PesqPict("SE1", "E1_VALOR")})  
    aAdd(aEstrut, { 'E1_SALDO'  , 'Saldo', 'N'       , TamSx3("E1_SALDO")[1]  , TamSx3("E1_SALDO")[2],PesqPict("SE1", "E1_SALDO")})  
    aAdd(aEstrut, { 'E1_NUMBCO' , 'Nosso Número', 'C', TamSx3("E1_NUMBCO")[1] ,  0, ''})      
    aAdd(aEstrut, { 'E1_AGEDEP' , 'Agencia', 'C'     , TamSx3("E1_AGEDEP")[1] ,  0, ''})      
    aAdd(aEstrut, { 'E1_PORTADO', 'Portado', 'C'     , TamSx3("E1_PORTADO")[1],  0, ''})      
    aAdd(aEstrut, { 'E1_SITUACA', 'Situacao', 'C'    , TamSx3("E1_SITUACA")[1],  0, ''})      
    aAdd(aEstrut, { 'E1_FLAGFA' , 'Banco', 'C'       , TamSx3("E1_FLAGFA")[1] ,  0, ''})      
    aAdd(aEstrut, { 'E1_HIST'   , 'Historico', 'C'   , TamSx3("E1_HIST")[1]   , 0,''})        
    aAdd(aEstrut, { 'E1_NUMBOR' , 'Bordero', 'C'     , TamSx3("E1_NUMBOR")[1]   , 0,''})        

    //percorrendo a estrutura, criando e adicionando a coluna
    For nAtual := 1 To Len(aEstrut)
        
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
        oColumn:SetTitle(aEstrut[nAtual][2])
        oColumn:SetType(aEstrut[nAtual][3])
        oColumn:SetSize(aEstrut[nAtual][4])
        oColumn:SetDecimal(aEstrut[nAtual][5])
        oColumn:SetPicture(aEstrut[nAtual][6])
 
        aAdd(aColunas, oColumn)
    Next
Return aColunas
 

//função que vai ser chamada ao clicar em continuar
User Function LimpaRej()
    Processa({|| fProcessa()}, 'Processando...')
Return
 

/**********************************************************************************
*+--------------------------------------------------------------------------------+*
*|Funcao      | TelaRej  | Autor |    Pedro Almeida                               |
*+------------+-------------------------------------------------------------------+*
*|Data        | 07.11.2024                                                        |*
*+------------+-------------------------------------------------------------------+*
*|Descricao   | Função para processamento dos dados e lógicas de negócio aplicadas|*
**********************************************************************************/
Static Function fProcessa()

    Local aArea     := FWGetArea()
    Local cMarca    := oMarkBrowse:Mark()
    Local nAtual    := 0
    Local nTotal    := 0
    Local nTotMarc  := 0
    Local aPergs    := {}
    Local cBcoTit   := ""
	Local cAgeTit   := ""
	Local cCtaTit   := ""
    Local _cTipo    := ""
    Local _cCliente := ""
    Local _cLojacli := ""
    Local _cPrefixo := ""
    Local _cNum     := ""
    Local _cParcela  := ""
    //Local lLibera   := .T.
    Local aTitulos  := {}
    Local i         := 0

    aAdd(aPergs,{1,"Banco",space(TamSx3("E1_FLAGFA")[1]),PesqPict("SA6","A6_COD"),,"SA6",,80,.T.}) 

    If ParamBox(aPergs, "Informe o Banco")
        //Caso Seja Cancelado a Operação na confirmação, Já limpa a área e Retorna
        //if !MsgYesNo("Confirmar alteração dos Titulos selecionados com o Banco " +Alltrim((cAliasTmp)->E1_FLAGFA) +" para: " +Alltrim(MV_PAR01)+ "?","Atenção!")
        //    FWAlertInfo("Operação Cancelada", "Atenção")
        //    FWRestArea(aArea)
        //    Return
        //endif
    Else
        Alert("Operação Cancelada")
        FWRestArea(aArea)
        Return
    EndIf
    
    //Pergunta se deseja reimprimir os boletos dos títulos que foram rejeitados e tiveram seus dados limpos, se dado ok cria boletos novos para o banco novo informado
    If MsgYesNo( OemToAnsi( "Deseja realizar a impressao do(s) novos boleto(s)?" ) )
	
       lImpAuto := .T.

       SEE->( DbSetOrder(1) )
	   SEE->( DbGoTop() )
	   SEE->(Dbseek(xFilial("SEE")+ALLTRIM(MV_PAR01),.t.))
	   While SEE->(!EOF()) .AND. SEE->EE_FILIAL == xFilial("SEE") .AND. SEE->EE_CODIGO == alltrim(MV_PAR01)
		   IF SEE->EE_YBOLETO .AND. SEE->EE_FILIAL == xFILIAL("SEE")
               cBcoTit := SEE->EE_CODIGO
	           cAgeTit := SEE->EE_AGENCIA
	           cCtaTit := SEE->EE_CONTA
		       EXIT
		   ENDIF
		   SEE->( DbSkip() )
	   end
    
    Endif

    //Define o tamanho da régua
    DbSelectArea(cAliasTmp)
    (cAliasTmp)->(DbGoTop())
    Count To nTotal
    ProcRegua(nTotal)
     
    //Posiciona no inicio da tabela temporaria
    (cAliasTmp)->(DbGoTop())

    
    //o programa vai percorrer os registros procurando os marcados, já tendo a informação da alteração do banco, e estando posicionados pelo RECNO
    While ! (cAliasTmp)->(EoF())
        
        SE1->(DbgoTo((cAliasTmp)->Recno))
        nAtual++

        _cCliente:=SE1->E1_CLIENTE
        _cLojacli:=SE1->E1_LOJA
        _cPrefixo:=SE1->E1_PREFIXO
        _cNum    :=SE1->E1_NUM
        _cTipo   :=SE1->E1_TIPO
        _cParcela:=SE1->E1_PARCELA
                
        IncProc('Analisando registros ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
        
        //Caso esteja marcado
        If oMarkBrowse:IsMark(cMarca) 
            
           
           //Deixado o processo igual para rejeitado e prorrogado
           //lLibera  := .T.
            
           /* If ALLTRIM(SE1->E1_HIST)<>'PRORROGADO' 
                //Varrer todos títulos referente a nota para checar se existe algum não rejeitado, se existir não processa
                dbSelectArea("SE1")
                dbSetOrder(2)
                Dbseek(xFilial("SE1")+_cCliente+_cLojacli+_cPrefixo+_cNum)
            
                While !EOF() .and. E1_CLIENTE==_cCliente .and. E1_LOJA==_cLojaCli .and. E1_PREFIXO==_cPrefixo .and. E1_NUM==_cNum .and. E1_TIPO==_cTipo 
                    if substr(E1_HIST,1,20)<>'03-ENTRADA REJEITADA' .and. Ascan(aTitulos,{|x| x[1]+x[2] == _cPrefixo+_cNum})=0
                        Alert("A parcela "+E1_PARCELA+" do título: "+E1_NUM+" não está como rejeitada, verificar! Se foi acatada terá de ser baixado do banco antes de poder liberar as demais rejeitadas!")
                        lLibera:=.F.
                        Exit
                    EndIF
                    dbskip()
                EndDo

                //Apenas se todas as parcelas estão rejeitadas pode ser realizada a limpeza dos dados 
                If lLibera

                    dbSelectArea("SE1")
                    dbSetOrder(2)
                    Dbseek(xFilial("SE1")+_cCliente+_cLojacli+_cPrefixo+_cNum)
                
                    nTotMarc++
                    
                    Begin Transaction
                    
                        //Se tiver borderô é deletado o registro
                        DbSelectArea("SEA")
                        DbSetOrder(1)
                        if Dbseek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM)
                        While !eof() .and. SE1->E1_NUM=EA_NUM .and. SE1->E1_NUMBOR=EA_NUMBOR 
                            RecLock("SEA",.F.)
                            DbDelete()
                            SEA->(MsUnlock())
                        end 
                        Endif

                        DbSelectArea("SE1")
                        While !EOF() .and. E1_CLIENTE==_cCliente .and. E1_LOJA==_cLojaCli .and. E1_PREFIXO==_cPrefixo .and. E1_NUM==_cNum .and. E1_TIPO==_cTipo 
                            RecLock("SE1",.F.)
                            SE1->E1_NUMBOR     := ""
                            SE1->E1_NUMBCO     := ""
                            SE1->E1_INFBOL     := ""
                            SE1->E1_DATABOR    := Ctod("")
                            SE1->E1_SITUACA    := '0'
                            SE1->E1_HIST       := ""
                            SE1->E1_OCORREN    := "" 
                            SE1->E1_FLAGFA     := ' '+ALLTRIM(MV_PAR01)
                            SE1->E1_CONTA      := "" 
                            SE1->E1_AGEDEP     := "" 
                            SE1->E1_PORTADO    := ""
                            SE1->E1_CODBAR     := ""
                            SE1->E1_IDCNAB     := ""
                            SE1->E1_MSEXP      := ""
                            SE1->(MsUnlock())

                            dbskip()
                        Enddo    
                    
                        Aadd(aTitulos,{_cPrefixo,_cNum})

                    End Transaction
            
                Endif

            Else*/
                
                dbSelectArea("SE1")
                dbSetOrder(2)
                If Dbseek(xFilial("SE1")+_cCliente+_cLojacli+_cPrefixo+_cNum+_cParcela)
                       
                   nTotMarc++
                    
                   Begin Transaction
                        
                   DbSelectArea("SEA")
                   DbSetOrder(1)
                   if Dbseek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
                      RecLock("SEA",.F.)
                      DbDelete()
                      SEA->(MsUnlock())
                   Endif

                   DbSelectArea("SE1")
                   RecLock("SE1",.F.)
                   SE1->E1_NUMBOR     := ""
                   SE1->E1_NUMBCO     := ""
                   SE1->E1_INFBOL     := ""
                   SE1->E1_DATABOR    := Ctod("")
                   SE1->E1_SITUACA    := '0'
                   SE1->E1_HIST       := ""
                   SE1->E1_OCORREN    := "" 
                   SE1->E1_FLAGFA     := ' '+ALLTRIM(MV_PAR01)
                   SE1->E1_CONTA      := "" 
                   SE1->E1_AGEDEP     := "" 
                   SE1->E1_PORTADO    := ""
                   SE1->E1_CODBAR     := ""
                   SE1->E1_IDCNAB     := ""
                   SE1->E1_MSEXP      := ""
                   SE1->(MsUnlock())
                    
                   Aadd(aTitulos,{_cPrefixo,_cNum,_cParcela})
                   End Transaction
                Endif
            //Endif   
        Endif
        
        (cAliasTmp)->(DbSkip())

    EndDo

    oDlgMark:End()
    FWRestArea(aArea)

    IF lImpAuto
       
       For i:=1 to len(aTitulos)

	      U_P_FIR009(aTitulos[i][1],aTitulos[i][2],aTitulos[i][2],cBcoTit,1,cAgeTit,cCtaTit,,,,.T.,aTitulos[i][3])
	               
       Next

    Endif
    
    //Mostra a mensagem de término do processo e caso queria fecha a dialog
    FWAlertInfo('Dos [' + cValToChar(nTotal) + '] Titulos Rejeitados encontrados, foram liberados [' + cValToChar(nTotMarc) + '] Titulos e alterados para o banco destino '+Alltrim(MV_PAR01)+' .', 'Atenção')

Return
