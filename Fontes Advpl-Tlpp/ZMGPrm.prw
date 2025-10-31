
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "FWEDITPANEL.CH"
#INCLUDE "FWMBROWSE.CH"



User Function ZMGPrm()
	Local oBrowse := NIL

 	if !U_VerifZBR("ZZ",cUserName)
        FWAlertError("Acesso negado! ZBR - ZZ","ATENCAO")
        Return
    Endif 
	
	//Private aRotina := MenuDef() 
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZMG')      // Alias da tabela utilizada
	oBrowse:SetDescription("Controle de Parametros por Tipo")
	oBrowse:DisableDetails()
	oBrowse:SetMenuDef('ZMGPrm')
    oBrowse:Activate()

Return


Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION 'PesqBrw' 				OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION 'VIEWDEF.ZMGPrm'		OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	  ACTION 'VIEWDEF.ZMGPrm'		OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Carga" 	  ACTION 'u_ImportaParametros'	OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" 	  ACTION 'VIEWDEF.ZMGPrm'		OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	  ACTION 'VIEWDEF.ZMGPrm'		OPERATION 5	ACCESS 0
					
Return aRotina


Static Function ModelDef()
	Local oModel   := Nil
	Local oStPai   := FWFormStruct( 1, 'ZMG')
	oModel := MPFormModel():New("MZMGPrm", /*{|oModel| MDM5VlPre( oModel ) }bPre*/, /*{|oModel| MDMVlPos( oModel ) }/*bPos*/,/*{||ComplZZ3( Self ) }bCommit*/,/*bCancel*/)

	oModel:AddFields('ZMGMASTER',/*cOwner*/,oStPai)
	oModel:SetDescription("Controle de Parametros por Tipo")
	oModel:GetModel( 'ZMGMASTER' ):SetDescription("Controle de Parametros por Tipo")
	oModel:SetPrimaryKey({'ZMG_FILIAL','ZMG_TIPO','ZMG_DPT'})

Return oModel


Static Function ViewDef()
	Local oView     := Nil
	Local oModel    := FWLoadModel('ZMGPrm')
	Local oStPai 	:= FWFormStruct( 2, 'ZMG')

	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	//Adicionando os campos do cabe?alho
	oView:AddField('VIEW_ZMG', oStPai ,'ZMGMASTER')
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('TELA',100)
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZMG','TELA')

	If Type( 'oView' ) != "U"
        oView:Refresh( 'VIEW_ZMG')
    EndIf
Return oView

