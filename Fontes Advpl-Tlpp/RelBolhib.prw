#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | RelBol  | Autor |      Pedro Almeida		                 	 |*
*+------------+------------------------------------------------------------------+*
*|Data        | 31.10.2023                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Relatório Boleto Hibrido MOD 2		                        	 |*
**********************************************************************************/

User function RelBol()
	Local aPergs := {}
	Local cFunname := Funname()
	Local oRelatorio
	PRIVATE cTitulo     := 'Relatório de Boletos Hibridos'
	PRIVATE cDescri     := " "
	
	aAdd(aPergs, {1, "De Filial  "      ,Space(2),"","","SM0","",50,.F.}) //MV_PAR 01
	aAdd(aPergs, {1, "Ate Filial "      ,Space(2),"","","SM0","",50,.F.}) //MV_PAR 02
	aAdd(aPergs, {1, "Data De"          ,Date()   , "", ".T.", "", ".T.", 80 , .F.}) //mvpar 03
	aAdd(aPergs, {1, "Data Até "        ,Date()   , "", ".T.", "", ".T.", 80 , .T.}) //mvpar 04
	aAdd(aPergs, {1, "Do titulo "       ,Space(TamSx3("E1_NUM")[1]) , "", ".T.", "", ".T.", 80 , .F.})//mvpar 05
	aAdd(aPergs, {1, "Até titulo"       ,Space(TamSx3("E1_NUM")[1]) , "", ".T.", "", ".T.", 80 , .T.})//mvpar 06

	If !Parambox(aPergs, "Informe os parâmetros")
		Return
	EndIf
	oRelatorio  := TReport():New(cFunName, cTitulo,, {|oRelatorio| PrintReport(oRelatorio)}, cDescri)

	oSection1   := TRSection():New(oRelatorio,  , {'ZBH'})

	TRCell():New(oSection1, "ZBH_FILIAL" , "ZBH","Filial",  	 PesqPict( "ZBH", "ZBH_FILIAL" ),      	TamSX3("ZBH_FILIAL" )  	[1]+5,/*lPixel*/,   {|| QERY->ZBH_FILIAL  },"LEFT",,,,,.T.)
	TRCell():New(oSection1, "ZBH_TITULO" , "ZBH","Titulo", 	  	 PesqPict( "ZBH", "ZBH_TITULO" ),     	TamSX3("ZBH_TITULO" )  	[1]+7,/*lPixel*/,   {|| QERY->ZBH_PREFIX + " " + QERY->ZBH_TITULO }, "LEFT",,,,,.T. )
	TRCell():New(oSection1, "ZBH_PARCEL" , "ZBH","Parcela", 	 PesqPict( "ZBH", "ZBH_PARCEL" ),	  	TamSX3("ZBH_PARCEL"	)   [1]+7,/*lPixel*/,   {|| QERY->ZBH_PARCEL  },"LEFT",,,,,.T.)
	TRCell():New(oSection1, "A1_NOME"  	 , "SA1","Cliente",   	 PesqPict( "SA1", "A1_NOME"    ),		TamSX3("A1_NOME"  	)   [1]+1,/*lPixel*/,   {|| QERY->A1_COD + "  " + ALLTRIM( QERY->A1_NOME)  },"LEFT",,,,,.T.)
	TRCell():New(oSection1, "E5_VALOR"   , "SE5","Val. Titulo",  PesqPict( "SE5", "E5_VALOR"   ),		TamSX3("E5_VALOR"	)	[1]+4,/*lPixel*/,   {|| QERY->E5_VALOR    },,,,,,.T.)
	TRCell():New(oSection1, "E5_VLJUROS" , "SE5","Juros",   	 PesqPict( "SE5", "E5_VLJUROS" ),		TamSX3("E5_VLJUROS"	)   [1]+4,/*lPixel*/,   {|| QERY->E5_VLJUROS  },,,,,,.T.)
	TRCell():New(oSection1, "E5_VLMULTA" , "SE5","Multa",   	 PesqPict( "SE5", "E5_VLMULTA" ),		TamSX3("E5_VLMULTA" )   [1]+4,/*lPixel*/,   {|| QERY->E5_VLMULTA  },,,,,,.T.)
	TRCell():New(oSection1, "E5_VLDESCO" , "SE5","Desconto",   	 PesqPict( "SE5", "E5_VLDESCO" ),		TamSX3("E5_VLDESCO" )   [1]+4,/*lPixel*/,   {|| QERY->E5_VLDESCO  },,,,,,.T.)
	TRCell():New(oSection1, "VALBX"      , "SE5","Val. Baixa",   PesqPict( "SE5", "E5_VALOR"   ),		TamSX3("E5_VALOR"	)   [1]+2,/*lPixel*/,   {|| QERY->E5_VALOR    },"CENTER",,,,,.T.)
	TRCell():New(oSection1, "ZBH_DATA"	 , "ZBH","Data Baixa",   PesqPict( "ZBH", "ZBH_DATA"   ),		TamSX3("ZBH_DATA"	)   [1]+4,/*lPixel*/,   {|| QERY->ZBH_DATA    },"CENTER",,,,,.T.)
	TRCell():New(oSection1, "ZBH_FLAGPG" , "ZBH","Status", 	 	 PesqPict( "ZBH", "ZBH_FLAGPG" ),		TamSX3("ZBH_FLAGPG"	)   [1]+10,/*lPixel*/,  {|| QERY->ZBH_FLAGPG  },"LEFT",,,,,.T.)
	TRCell():New(oSection1, "ZBH_TIPLIQ" , "ZBH","Liquid", 	 	 PesqPict( "ZBH", "ZBH_TIPLIQ" ),		TamSX3("ZBH_TIPLIQ"	)   [1]+10,/*lPixel*/,  {|| QERY->ZBH_TIPLIQ  },"LEFT",,,,,.T.)

	oRelatorio:PrintDialog()

Return

Static Function PrintReport(oRelatorio)
	Local oSection1 := oRelatorio:section(1)
	Local nTotBx    := 0
	local nTotjr := 0
	local ntotdc := 0
	local nTotbxt := 0
	local nTotMlt := 0

	BeginSql Alias "QERY"
	   SELECT ZBH_FILIAL, 
          	ZBH_TITULO, 
          	ZBH_PREFIX,
          	A1_NOME,
          	A1_COD,
          	ZBH_PARCEL,
          	E1_VALOR,  
          	ZBH_DATA,  
          	ZBH_FLAGPG, 
          	ZBH_TIPLIQ, E1_JUROS, ZBH_IDCNAB,E1_DESCONT,E1_IDCNAB,E5_VALOR,E5_ARQCNAB,E5_VLMULTA,E5_VLJUROS,E5_VLDESCO
       FROM %table:ZBH% ZBH

       LEFT OUTER JOIN %table:SE1% E1 ON 
       E1_FILIAL = ZBH_FILIAL 
       AND E1_NUM = ZBH_TITULO  
       AND E1_PREFIXO = ZBH_PREFIX  
       AND E1_PARCELA = ZBH_PARCEL 
       AND E1_IDCNAB = ZBH_IDCNAB 
       AND E1.D_E_L_E_T_ = ' ' 
       INNER JOIN %table:SA1% A1 ON
       A1_COD =    E1_CLIENTE  
       AND A1_LOJA =   E1_LOJA 
       AND A1.D_E_L_E_T_ = ' ' 

       INNER JOIN %table:SE5% E5 ON
	     E1_FILIAL = E5_FILIAL
	   AND E1_PREFIXO = E5_PREFIXO 
	   AND E1_NUM = E5_NUMERO  
	   AND E1_PARCELA = E5_PARCELA  
	   AND E5.D_E_L_E_T_ = ' '

       WHERE ZBH.D_E_L_E_T_ = ' ' 
       AND ZBH_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
       AND ZBH_DATA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
       AND ZBH_TITULO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
       AND ZBH_FLAGPG = 'B'
       AND ZBH_ACAO LIKE 'Baixa%'
      AND E5_TIPODOC <> 'JR'
       
	   GROUP BY ZBH_FILIAL,  
           ZBH_TITULO,  
           ZBH_PREFIX,
           A1_NOME,
           A1_COD,  
           ZBH_PARCEL,  
           E1_VALOR,    
           ZBH_DATA,    
           ZBH_FLAGPG,  
           ZBH_TIPLIQ,E1_JUROS,ZBH_IDCNAB,E1_IDCNAB,E1_DESCONT,E5_VALOR,E5_ARQCNAB,E5_VLMULTA,E5_VLJUROS,E5_VLDESCO,ZBH.R_E_C_N_O_   
       ORDER BY ZBH_FILIAL, ZBH_FLAGPG, ZBH_TITULO, ZBH_PARCEL,A1_NOME,A1_COD,ZBH_DATA, ZBH.R_E_C_N_O_
	EndSql


	oSection1:Init()
	Do While !oRelatorio:Cancel() .AND. QERY->(!Eof())
		oSection1:Cell('ZBH_FILIAL'):SetValue(QERY->ZBH_FILIAL)
		oSection1:Cell('ZBH_TITULO'):SetValue(QERY->ZBH_PREFIX + " " + QERY->ZBH_TITULO)
		oSection1:Cell('ZBH_PARCEL'):SetValue(QERY->ZBH_PARCEL)
		oSection1:Cell('A1_NOME'):SetValue(QERY->A1_COD + "  " + ALLTRIM( QERY->A1_NOME))
		oSection1:Cell('E5_VALOR'):SetValue(QERY->E5_VALOR)
		oSection1:Cell('E5_VLJUROS'):SetValue(QERY->E5_VLJUROS)
		oSection1:Cell('E5_VLMULTA'):SetValue(QERY->E5_VLMULTA)
		oSection1:Cell('E5_VLDESCO'):SetValue(QERY->E5_VLDESCO)
		oSection1:Cell('VALBX'):SetValue(QERY->E5_VALOR + QERY->E5_VLJUROS + QERY->E5_VLMULTA  - QERY->E5_VLDESCO)
		oSection1:Cell('ZBH_DATA'):SetValue(STOD(QERY->ZBH_DATA))
		oSection1:Cell('ZBH_FLAGPG'):SetValue(QERY->ZBH_FLAGPG)
		oSection1:Cell('ZBH_TIPLIQ'):SetValue(X3Combo("ZBH_TIPLIQ", "61"))
		oSection1:Printline()
		oRelatorio:SkipLine()
		nTotBx 	+= QERY->E5_VALOR
		nTotjr 	+= QERY->E5_VLJUROS
		nTotMlt += QERY->E5_VLMULTA
		ntotdc 	+= QERY->E5_VLDESCO
		nTotbxt += QERY->E5_VALOR
		
		QERY->(DbSkip())
	Enddo

	oRelatorio:SkipLine()
	oRelatorio:ThinLine()
	oSection1:Cell('ZBH_FILIAL'):SetValue('')
	oSection1:Cell('ZBH_TITULO'):SetValue('T O T A L')
	oSection1:Cell('ZBH_PARCEL'):SetValue('')
	oSection1:Cell('A1_NOME'):SetValue('')
	oSection1:Cell('E5_VALOR'):SetValue(nTotBx)
	oSection1:Cell('E5_VLJUROS'):SetValue(nTotjr)
	oSection1:Cell('E5_VLMULTA'):SetValue(nTotMlt)
	oSection1:Cell('E5_VLDESCO'):SetValue(ntotdc)
	oSection1:Cell('VALBX'):SetValue(nTotbxt + nTotjr + nTotMlt - ntotdc) 
	oSection1:Cell('ZBH_DATA'):SetValue('')
	oSection1:Cell('ZBH_FLAGPG'):SetValue('')
	oSection1:Cell('ZBH_TIPLIQ'):SetValue('')
	oSection1:Printline()
	oSection1:Finish()

	QERY->(DbCloseArea())
Return
