#ifdef SPANISH
#else
	#ifdef ENGLISH
	#else
		#define STR0001 "Este programa irá imprimir o Razäo Contabil,"
		#define STR0002 "de acordo com os parametros solicitados pelo"
		#define STR0003 "usuário."
		#define STR0004 "Zebrado"
		#define STR0005 "Administracao"
		#define STR0006 "Emissao do Razao Contabil"
		#define STR0007 "RAZAO ANALITICO EM "
		#define STR0008 "RAZAO SINTETICO EM "
		#define STR0009 " DE "
		#define STR0010 " ATE "
		#define STR0011 "(ORCADO)"
		#define STR0012 "(GERENCIAL)"
		#define STR0013 "LOTE/SUB/DOC/LINHA  H I S T O R I C O                  C/PARTIDA         "
		#define STR0014 "CCUSTO "
		#define STR0015 "***** CANCELADO PELO OPERADOR *****"
		#define STR0016 "CONTA - "
		#define STR0017 "Selecionando Registros..."
		#define STR0018 "Criando Arquivo Temporário..."
		#define STR0019 "DATA"
		#define STR0020 "T o t a i s  d a  C o n t a  ==> "
		#define STR0021 "CONTA SEM MOVIMENTO NO PERIODO"
		#define STR0022 "A TRANSPORTAR :"
		#define STR0023 "DE TRANSPORTE :"
		#define STR0024 "DATA                                                                              DEBITO          CREDITO         SALDO ATUAL"
		#define STR0025 "T O T A L  G E R A L ==> "
		#define STR0026 "SEM MOVIMENTO NO PERIODO"
		#define STR0027 "Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. "
		#define STR0028 "Utilize como base o parametro MV_LDIARAB."
		#define STR0029 "         DEBITO          CREDITO         SALDO ATUAL"
		#define STR0030 "O plano gerencial nao esta disponivel nesse relatorio."
		#define STR0033 "SALDO ANTERIOR:"
		#define STR0034 "LOTE/SUB/DOC/LINHA"
		#define STR0035 "HISTORICO"	
		#define STR0036 "XPARTIDA"
		#define STR0037 "DEBITO"
		#define STR0038 "CREDITO"
		#define STR0039 "SALDO ATUAL"
		#define STR0040 "SEGOFI"
		#define STR0041 "CONTA"
		#define STR0042 "DESCRICAO"
		#define STR0043 "Conta"
		#define STR0044 "Lançamentos Contábeis"
		#define STR0045 "Totais"
		#define STR0046 "Complemento"
		#define STR0047 "Atenção"
		#define STR0048 "Nao existem dados para os parâmetros especificados."
	#endif
#endif

#IFDEF SPANISH
	Return Nil
#ENDIF

#IFDEF ENGLISH
	Return Nil
#ENDIF

#IFNDEF SPANISH
 #IFNDEF ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

	STR0024 := "DATA                                                                             DEBITO               CREDITO            SALDO ATUAL"
	STR0034 := "LOTE/SUB/DOC/LINHA"
	STR0035 := "HISTORICO"	
	STR0037 := "DEBITO"
	STR0038 := "CREDITO"
	Return Nil
 #ENDIF
#ENDIF
