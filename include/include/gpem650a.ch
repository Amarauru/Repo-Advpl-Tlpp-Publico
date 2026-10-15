#ifdef SPANISH
	#define STR0001 "Generacion de titulos"
	#define STR0002 "Este programa genera titulos en el  archivo  de  movimientos (RC1) a partir del registro de"
	#define STR0003 "definiciones (RC0). Tras generarlos, estaran disponibles para consultas e integracion con "
	#define STR0004 "el financiero.                           											   "
	#define STR0005 "Generando titulos - "
	#define STR0006 "Selecionando registros..."
	#define STR0007 "Confirma configuracion de los parametros?"
	#define STR0008 "¡Atenc.!"
	#define STR0009 "Generando archivo, espere..."
	#define STR0010 "Procesando..."
	#define STR0011 "No se genero(generaron) el (los) titulo(s): "
	#define STR0012 ". Ajuste el (los) tipo(s) y procese generacion nuevamente."
	#define STR0013 "Se debe ejecutar el programa para actualizacion de base del SIGAGPE - (RHUPDMOD)"
	#define STR0014 "Seleccione la actualizacion 'Ajustar Indices - RC1'."
#else
	#ifdef ENGLISH
		#define STR0001 "Bill´s Generation "
		#define STR0002 "This program will generate bills in the movements file (RC1) from the registration of"
		#define STR0003 "definitions (RC0). After generated they will be available for query and integration  "
		#define STR0004 "with the financial module.              											   "
		#define STR0005 "Generating Bills- "
		#define STR0006 "Selecting Files..."
		#define STR0007 "Confirm the parameters configuration?"
		#define STR0008 "Attention"
		#define STR0009 "Generating file. Wait..."
		#define STR0010 "Processing..."
		#define STR0011 "Bill(s) not generated: "
		#define STR0012 ". Correct the type(s) and generate again."
		#define STR0013 "The program to update SIGAGPE database (RHUPDMOD) must be executed."
		#define STR0014 "Select update 'Adjust Indexes - RC1.'"
	#else
		Static STR0001 := "Geracao de Titulos"
		Static STR0002 := "Este programa gera titulos no  arquivo  de  movimentos (RC1) a partir do cadastro de"
		Static STR0003 := "definicoes (RC0). Apos gerados, estarao disponiveis para consultas e integracao com "
		Static STR0004 := "o financeiro.                           											   "
		Static STR0005 := "Gerando Titulos - "
		Static STR0006 := "Selecionando Registros..."
		Static STR0007 := "Confirma configuraçäo dos parâmetros?"
		Static STR0008 := "Atencao!"
		Static STR0009 := "Gerando arquivo aguarde..."
		Static STR0010 := "Processando..."
		Static STR0011 := "Nao foi(ram) gerado(s) o(s) titulo(s): "
		Static STR0012 := ". Acerte o(s) tipo(s) e processe a geracao novamente."
		#define STR0013  "Deve ser executado o programa para atualização de base do SIGAGPE - (RHUPDMOD)"
		Static STR0014 := "Selecione a atualização 'Ajustar Indices - RC1'."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Criação De Títulos"
			STR0002 := "Este programa gera títulos no  ficheiro  de  movimentos (rc1) a partir do registo de"
			STR0003 := "Definicoes (rc0). após criados, estarão disponíveis para consultas e integração com "
			STR0004 := "O financeiro.                           											   "
			STR0005 := "A criar títulos - "
			STR0006 := "A Seleccionar Registos..."
			STR0007 := "Confirma configuração dos parâmetros?"
			STR0008 := "Atenção!"
			STR0009 := "A criar ficheiro aguarde..."
			STR0010 := "A processar..."
			STR0011 := "Não foi(ram) criado(s) o(s) título(s): "
			STR0012 := ". corrijir o(s) tipo(s) e processar a criação novamente."
			STR0014 := "Seleccione a actualização 'Ajustar Índices - RC1'."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Criação De Títulos"
			STR0002 := "Este programa gera títulos no  ficheiro  de  movimentos (rc1) a partir do registo de"
			STR0003 := "Definicoes (rc0). após criados, estarão disponíveis para consultas e integração com "
			STR0004 := "O financeiro.                           											   "
			STR0005 := "A criar títulos - "
			STR0006 := "A Seleccionar Registos..."
			STR0007 := "Confirma configuração dos parâmetros?"
			STR0008 := "Atenção!"
			STR0009 := "A criar ficheiro aguarde..."
			STR0010 := "A processar..."
			STR0011 := "Não foi(ram) criado(s) o(s) título(s): "
			STR0012 := ". corrijir o(s) tipo(s) e processar a criação novamente."
			STR0014 := "Seleccione a actualização 'Ajustar Índices - RC1'."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
