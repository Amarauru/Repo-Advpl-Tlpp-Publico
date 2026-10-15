#ifdef SPANISH
	#define STR0001 "Este programa imprime el balance aux. de verificacion Modelo 1 (132 Colunas), la"
	#define STR0002 "cuenta se imprime y se limita a 20 caracteres y su descripcion, a 30 "
	#define STR0003 "Balance aux. de verificacion."
	Static  STR0004 :=  "|  CODIGO                     |      D E S C R I P C I O N                      |    SALDO ANTERIOR             |     DEBITO       |      CREDITO      |    MOVIMIENTO DEL PERIODO     |         SALDO ACTUAL              |"
	Static  STR0005 :=  "|  CODIGO               |   D  E  S  C  R  I  P C I O N    |   SALDO ANTERIOR  |     CARGO    |      ABONO     |   SALDO ATUAL     |"
	#define STR0006 "BALANCE AUX. DE VERIFICACION ANALITICA DE"
	#define STR0007 " A  "
	#define STR0008 " EN "
	#define STR0009 "BALANCE AUX. DE VERIFICACION SINTETICA DE "
	#define STR0010 "***** ANULADO POR EL OPERADOR *****"
	#define STR0011 "T O T A L  D E L  P E R I O D O: "
	#define STR0012 "Seleccionando registros..."
	#define STR0013 "A Rayas"
	#define STR0014 "Administracion"
	#define STR0015 "Creando archivo temporal..."
	Static  STR0016 :=  "los valores impreson son saldo anterior, debito, credito y saldo actual del periodo."
	#define STR0017 "BALANCE AUX.DE VERIFICACION DE "
	#define STR0018 " (PRESUP.)"
	#define STR0019 " (DE GESTION)"
	#define STR0020 "T O T A L  D E L  G R U P O ("
	#define STR0021 "DIV."
	#define STR0022 "|  CODIGO                     |      D E S C R I P C I O N                      |        SALDO ANTERIOR             |           DEBITO             |            CREDITO                |         SALDO ATUAL               |"
	#define STR0023 "Microsiga Software S/A"
	#define STR0024 "Hora Termino: "
	#define STR0025 "Por favor rellenar los parametros Grupos Ingresos/Gastos y Fecha Sld Ant. Ingresos/Gastos o"
	#define STR0026 "dejar el parametro Ignora Sl Ant.Cob/Des = No "
	#define STR0027 "Plan de cuentas"
	#define STR0028 "Cta. "
	#define STR0029 "Descripc."
	#define STR0030 "Saldo anterior"
	Static  STR0031 :=  "Debito"
	Static  STR0032 :=  "Credito"
	#define STR0033 "Movimto. del periodo"
	#define STR0034 "Saldo act. "
	#define STR0035 "Ignora Sl Ant.Cob/Des"
#else
	#ifdef ENGLISH
		#define STR0001 "This program will print the Trial Balance Model 1 (132 Columns). There is a"
		#define STR0002 "maximum of 20 characters to the account and 30 characters to the description."
		#define STR0003 "Trial Balance."
		Static  STR0004 :=  "|  CODE                       |      D E S C R I P T I O N                      |   PREVIOUS BALANCE            |     DEBIT        |      CREDIT       |  MOVEMENT OF THE PERIOD       |       CURRENT BALANCE             |"
		Static  STR0005 :=  "|    ACCOUNT CODE       |   D  E  S  C  R  I  P  T  .    | PREVIOWS BALANCE  |      DEBIT     |      CREDIT    |  CURRENT BALANCE  |"
		#define STR0006 "DETAILED TRIAL BALANCE OF "
		#define STR0007 " UNTIL "
		#define STR0008 " IN "
		#define STR0009 "SUMMARIZED TRIAL BALANCE OF "
		#define STR0010 "***** CANCELLED BY THE OPERATOR *****"
		#define STR0011 "T O T A L S  O F  T H E  P E R I O D: "
		#define STR0012 "Selecting Records..."
		#define STR0013 "Z.Form"
		#define STR0014 "Management"
		#define STR0015 "Creating Temporary File..."
		Static  STR0016 :=  "Printed values: previous balance, debit, credit and current balance of the period."
		#define STR0017 "TRIAL BALANCE OF "
		#define STR0018 " (BUDGETED)"
		#define STR0019 " (MANAGERIAL)"
		#define STR0020 "T O T A L S  -  G R O U P ("
		#define STR0021 "DIV."
		#define STR0022 "|  CODE                       |      D E S C R I P T I O N                      |       PREVIOUS BALANCE            |           DEBIT              |            CREDIT                 |      CURRENT BALANCE              |"
		#define STR0023 "Microsiga Software S/A"
		#define STR0024 "End time: "
		#define STR0025 "Please, fill out the parameters Groups Incomes/Expenses& Date Prv Blnc Incomes/Expenses or "
		#define STR0026 "leave the parameter Ignor Prv.BlnInc/Exp = No  "
		#define STR0027 "Chart of accts."
		#define STR0028 "Acct."
		#define STR0029 "Descript."
		#define STR0030 "Previous blnce"
		Static  STR0031 :=  "Debit "
		Static  STR0032 :=  "Credit "
		#define STR0033 "Period movements    "
		#define STR0034 "Curr. Blnce"
		#define STR0035 "Ignor Prev.BlnRec/Des"
	#else
		#define STR0001 "Este programa ira imprimir o Balancete de Verificacao Modelo 1 (132 Colunas), a"
		#define STR0002 "conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"
		#define STR0003 "Balancete Auxiliar de Verificacao"
		Static  STR0004 :=  "|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR             |     DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
		Static  STR0005 :=  "|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
		#define STR0006 "BALANCETE DE VERIFICACAO ANALITICO DE "
		#define STR0007 " ATE "
		#define STR0008 " EM "
		#define STR0009 "BALANCETE DE VERIFICACAO SINTETICO DE "
		#define STR0010 "***** CANCELADO PELO OPERADOR *****"
		#define STR0011 "T O T A I S  D O  P E R I O D O: "
		#define STR0012 "Selecionando Registros..."
		#define STR0013 "Zebrado"
		#define STR0014 "Administracao"
		#define STR0015 "Criando Arquivo Temporario..."
		Static  STR0016 :=  "os valores impressos sao saldo anterior, debito, credito e saldo atual do periodo."
		#define STR0017 "BALANCETE DE VERIFICACAO DE "
		#define STR0018 " (ORCADO)"
		#define STR0019 " (GERENCIAL)"
		#define STR0020 "T O T A I S  D O  G R U P O ("
		#define STR0021 "DIV."
		#define STR0022 "|  CODIGO                     |      D E S C R I C A O                          |        SALDO ANTERIOR             |           DEBITO             |            CREDITO                |         SALDO ATUAL               |"
		#define STR0023 "Microsiga Software S/A"
		#define STR0024 "Hora Termino: "
		#define STR0025 "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou"
		#define STR0026 "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
		#define STR0027 "Plano de contas"
		#define STR0028 "Conta"
		#define STR0029 "Descricao"
		#define STR0030 "Saldo anterior"
		Static  STR0031 :=  "Débito"
		Static  STR0032 :=  "Crédito"
		#define STR0033 "Movimento do periodo"
		#define STR0034 "Saldo atual"
		#define STR0035 "Ignora Sl Ant.Rec/Des"
	#endif
#endif

#IFDEF SPANISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

		If cPaisLoc == "ALL"
			STR0004 := "|  CODIGO                     |      D E S C R I P C I O N                      |    SALDO ANTERIOR             |     DEBITO       |      CREDITO      |    MOVIMIENTO DEL PERIODO     |         SALDO ACTUAL              |"
			STR0005 := "|  CODIGO               |   D  E  S  C  R  I  P C I O N    |   SALDO ANTERIOR  |     CARGO    |      ABONO     |   SALDO ATUAL     |"
			STR0016 := "los valores impreson son saldo anterior, debito, credito y saldo actual del periodo."
			STR0031 := "Debito"
			STR0032 := "Credito"
		ElseIf cPaisLoc == "MEX"
			STR0004 := "|  CODIGO                     |      D E S C R I P C I O N                      |    SALDO ANTERIOR             |     CARGO       |      ABONO      |    MOVIMIENTO DEL PERIODO     |         SALDO ACTUAL              |"
			STR0005 := "|  CODIGO               |     D E S C R I P C I O N      |   SALDO ANTERIOR  |      CARGO     |       ABONO    |   SALDO ACTUAL    |"
			STR0016 := "los valores impreson son saldo anterior, cargo, abono y saldo actual del periodo.  "
			STR0031 := "Debito"
			STR0032 := "Credito"
		EndIf
	Return Nil
#ENDIF

#IFDEF ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

		If cPaisLoc == "ALL"
			STR0004 := "|  CODE                       |      D E S C R I P T I O N                      |   PREVIOUS BALANCE            |     DEBIT        |      CREDIT       |  MOVEMENT OF THE PERIOD       |       CURRENT BALANCE             |"
			STR0005 := "|    ACCOUNT CODE       |   D  E  S  C  R  I  P  T  .    | PREVIOWS BALANCE  |      DEBIT     |      CREDIT    |  CURRENT BALANCE  |"
			STR0016 := "Printed values: previous balance, debit, credit and current balance of the period."
			STR0031 := "Debit "
			STR0032 := "Credit "
		ElseIf cPaisLoc == "MEX"
			STR0004 := "|  CODE                       |      D E S C R I P T I O N                      |   PREVIOUS BALANCE            |     DEBIT        |      CREDIT       |  MOVEMENT OF THE PERIOD       |       CURRENT BALANCE             |"
			STR0005 := "|    ACCOUNT CODE       |   D  E  S  C  R  I  P  T  .    | PREVIOWS BALANCE  |      DEBIT     |      CREDIT    |  CURRENT BALANCE  |"
			STR0016 := "Printed values: previous balance, debit, credit and current balance of the period."
			STR0031 := "Debit "
			STR0032 := "Credit "
		EndIf
	Return Nil
#ENDIF

#IFNDEF SPANISH
 #IFNDEF ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

		If cPaisLoc == "ALL"
			STR0004 := "|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR             |     DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
			STR0005 := "|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
			STR0016 := "os valores impressos sao saldo anterior, debito, credito e saldo atual do periodo."
			STR0031 := "Débito"
			STR0032 := "Crédito"
		ElseIf cPaisLoc == "MEX"
			STR0004 := "|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR             |     DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
			STR0005 := "|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
			STR0016 := "os valores impressos sao saldo anterior, debito, credito e saldo atual do periodo."
			STR0031 := "Débito"
			STR0032 := "Crédito"
		EndIf
	Return Nil
 #ENDIF
#ENDIF
