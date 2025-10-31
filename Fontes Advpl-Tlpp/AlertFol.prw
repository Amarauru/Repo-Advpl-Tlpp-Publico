#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/**********************************************************************************
*+-------------------------------------------------------------------------------+*
*|Funcao      | AlertFol| Autor |    Pedro Almeida	                             |*
*+------------+------------------------------------------------------------------+*
*|Data        | 12.12.2023                                                       |*
*+------------+------------------------------------------------------------------+*
*|Descricao   | Disparo de Email para Códigos de Verbas Excedentes               |*
**********************************************************************************/

User Function AlertFol(aParam)
	Local cQuery    := ""
	Local cBody     := ""

	Local cCor      := ""
	Local cMat
	Local cQry      := GetNextAlias()

	Do Case
	Case cEmpAnt == '01'
		If cEmpAnt+cFilAnt $ cSom
			cSubject := 'comentado nome da empresa'
		Else
			cSubject := 'comentado nome da empresa'
		EndIf
	Case cEmpAnt == '02'
		cSubject := 'comentado nome da empresa.'
	Case cEmpAnt == '03'
		cSubject := 'comentado nome da empresa'
	End Case

	cQuery  := 	"SELECT RA_FILIAL,RA_MAT,RA_NOME,RC_PD,RV_COD,RV_DESC,RC_VALOR,RC_DATA,RV_TIPOCOD,RV_XEXCE"
	cQuery  +=	"	FROM 	"+RetSqlName("SRA")+" RA"
	cQuery  += 	"	INNER JOIN "+RetSqlName("SRC")+" RC ON RA_FILIAL = RC_FILIAL AND RA_MAT=RC_MAT"
	cQuery  += 	"	INNER JOIN "+RetSqlName("SRV")+" RV ON RC_PD = RV_COD"
	cQuery  +=	"	WHERE RA.D_E_L_E_T_ <> '*'"
	cQuery  +=	"	AND RC.D_E_L_E_T_ <> '*'"
	cQuery  +=	"	AND RV.D_E_L_E_T_ <> '*'"
	cQuery  +=	"	AND RV_XEXCE ='S'"
	cQuery  +=	"	AND RV_TIPOCOD <> '3'"
	cQuery  +=	"	GROUP BY RA_FILIAL,RA_MAT,RA_NOME,RC_PD,RV_COD,RV_DESC,RC_VALOR,RC_DATA,RV_TIPOCOD,RV_XEXCE"
	cQuery  +=	"	ORDER BY RA_MAT"

	/* SELECT RA_FILIAL,RA_MAT,RA_NOME,RC_PD,RV_COD,RV_DESC,RC_VALOR,RC_DATA,RV_TIPOCOD,RV_XEXCE  
	FROM 	   SRA010 RA WITH (NOLOCK)  
	INNER JOIN SRC010 RC WITH (NOLOCK) ON ( RA_FILIAL = RC_FILIAL AND RA_MAT = RC_MAT )  
	INNER JOIN SRV010 RV WITH (NOLOCK) ON ( RC_PD = RV_COD )  
	WHERE RA.D_E_L_E_T_ = ' '  
	AND RC.D_E_L_E_T_ = ' '  
	AND RV.D_E_L_E_T_ = ' '  
	AND RV_XEXCE = '1'  
	AND RV_TIPOCOD <> '3'  
	GROUP BY RA_FILIAL,RA_MAT,RA_NOME,RC_PD,RV_COD,RV_DESC,RC_VALOR,RC_DATA,RV_TIPOCOD,RV_XEXCE  
	ORDER BY 1,3 */

	MpSysOpenQuery(cQuery, cQry) //Traz a Query puxando os códigos de verbas marcados no campo RV_XEXCE

	If (cQry)->(!Eof()) //Caso Haja algum, monta o HTML

		cBody +="       <html> "
		cBody +="       <head> "
		cBody +="       <meta http-equiv='Content-Type' "
		cBody +="       content='text/html; charset=iso-8859-1'> "
		cBody +="       <meta name='GENERATOR' content='Microsoft FrontPage Express 2.0'> "
		cBody +="       <title>Alerta Referente a Folha de pagamento</title> "
		cBody +="       </head> "
		cBody +="       <form name='FrontPage_Form1'> "
		cBody +="           <p>&nbsp;</p> "
		cBody +="           <table border='0' width='1200'> "
		cBody +="               <tr> "
		cBody +="                   <td colspan='2' width='300' bgcolor='#FFFFFF' align='center' > "
		Do Case
		Case cEmpAnt+cFilAnt $ cEmis
			cBody+="                <img src='comentado nome da empresa' width='220' height=65>
			cCor := '#da3754'
		Case cEmpAnt+cFilAnt $ cSom
			cBody+="                <img src='comentado nome da empresa' width='220' height=65>
			cCor := '#0098da'
		Case cEmpAnt+cFilAnt $ cCat
			cBody+="                <img src='comentado nome da empresa' width='220' height=65>
			cCor := '#ffe877'
		Case cEmpAnt+cFilAnt $ cNut
			cBody+="                <img src='comentado nome da empresa' width='250' height=65>
			cCor := '#77aa42'
		EndCase
		cBody +=" </td>                                                                    "
		cBody +=" <tr>                                                                     "
		cBody +="     <td valign='top' colspan='2' width='1200' align='center' ><font      "
		cBody +="     size='3' face='Arial'><p><p></p></font></td>                         "
		cBody +=" </tr>                                                                    "
		cBody +=" <tr>                                                                     "
		cBody +="     <td valign='top' colspan='2' width='1200' align='center' ><font      "
		cBody +="     size='3' face='Arial'><p><p></p></font></td>                         "
		cBody +=" </tr>                                                                    "
		cBody +=" <tr>                                                                     "
		cBody +="     <td valign='top' colspan='2' width='1200' align='center' ><font      "
		cBody +="     size='3' face='Arial'><p><p></p></font></td>                         "
		cBody +=" </tr>                                                                    "
		cBody +=" <tr>                                                                     "
		cBody +="     <td colspan='2' width='733' bgcolor="+cCor+"><p                      "
		cBody +="     align='center'><font size='6' face='Arial' color='#FFFFFF'>          "
		cBody +="     <b>A   V   I   S   O  </b></font></p>                                "
		cBody +="     </td>                                                                "
		cBody +=" </tr>                                                                    "
		cBody +="  <tr>                                                                    "
		cBody +="       <td valign='top' width='1200'><font size='3'                       "
		cBody +="       face='Arial'><b><P><P></P>Alerta de Possiveis Divergências na Folha de Pagamento <P>"
		cBody +="       <P><P><P></P></font></td>                                          "
		cBody +="  </tr>                                                                   "
		cBody +="   <tr>                                                                   "
		cBody +="     <td valign='top' width='1200'><font size='3'                         "
		cBody +="     face='Arial'><br> Revisar Código de Verba com Excesso <P><P>         "
		cBody +="     </b></td>                                                            "
		cBody +="     </tr>                                                                "
		cBody +="   <tr>                                                                   "
		cBody +="     <td valign='top' width='1200'><font size='3'                         "
		cBody +="     face='Arial'><br> Seguintes Funcionários com Verbas excedentes:</td> </tr> <br> "

		While (cQry)->(!Eof())
			cBody +="    <tr> <td>Funcionário: "+AllTrim((cQry)->RA_NOME)+" <br>"
			cBody +="     </b></td>                                                    	   "
			cBody +="     </tr>                                                            "
			cBody +="   <table border='1' cellpadding='4' width='1200'>               	   "
			cBody +="      <tr align='center' bgcolor='silver'>                 		   "
			cBody +="          <td> <b>Codigo Verba	  </b> </td>                       	   "
			cBody +="          <td> <b>Descricao     </b> </td>                    		   "
			cBody +="          <td><b>Mês    		</b> </td>                 			   "
			cBody +="      </tr>                 										   "

			cMat := AllTrim((cQry)->RA_MAT)

			While (cQry)->(!Eof()) .and. cMat == AllTrim((cQry)->RA_MAT)
				cBody +="      <tr align='left'>										  "
				cBody +="            <td align='left'>"+AllTrim((cQry)->RV_COD)+"</td>	  "
				cBody +="            <td align='left'>"+AllTrim((cQry)->RV_DESC)+"</td>	  "
				cBody +="            <td align='left'>"+AllTrim((cQry)->RC_DATA)+"</td>   "
				cBody +="      </tr>"
				(cQry)->(DbSkip())
			End
			cBody +=" </table>"
			cBody +=" <p>&nbsp;</p>"
		End
		If cEmpAnt+cFilAnt $ cEmis+'|'+cSom
			cBody +="                 <tr> "
			cBody +="                     <td colspan='2' width='1200'><p "
			cBody +="                         align='center'><font size='4' face='Arial'> "
			cBody +="                         <b>comentado nome da empresa.</b></font></p> "
			cBody +="                     </td> "
			cBody +="                 </tr> "
		EndIf
		cBody +="                 <tr> "
		cBody+="                    <td colspan='2' width='1200' ><p align='center' ><font"
		Do Case
		Case cEmpAnt+cFilAnt $ cEmis
			cBody+="                    size='3' face='Arial'><b>comentado nome da empresa</b><p><p></p></font></p>"
		Case cEmpAnt+cFilAnt $ cSom
			cBody+="                    size='3' face='Arial'><b>comentado nome da empresa</b><p><p></p></font></p>"
		Case cEmpAnt+cFilAnt $ cCat
			cBody+="                    size='3' face='Arial'><b>comentado nome da empresa</b><p><p></p></font></p>"
		Case cEmpAnt+cFilAnt $ cNut
			cBody+="                    size='3' face='Arial'><b>comentado nome da empresa</b><p><p></p></font></p>"
		EndCase
		cBody +="                     </td> "
		cBody +="                 </tr> "
		cBody +="                 <p>&nbsp;</p> "
		cBody +="                     </td> "
		cBody +="                 </tr> "
		cBody +="             </td> "
		cBody +="         </tr> "
		cBody +="     </table> "
		cBody +=" </form> "
		cBody +=" </body> "
		cBody +=" </html> "

		(cQry)->( DBCloseArea() )

		//chamada de função para envio do email.
		DbSelectArea("ZZ3")
		ZZ3->(DbSetOrder(1))
		ZZ3->(Dbseek(FWxFilial("ZZ3")+"AlertFol"))
		While AllTrim(ZZ3->ZZ3_RELTOR) == "AlertFol"
			If AllTrim(ZZ3->ZZ3_RELTOR) == "AlertFol"
				U_pbMandaEmail(AllTrim(ZZ3->ZZ3_EMAIL),nil,nil,cSubject,nil,cBody,nil,nil,nil,nil)
			EndIf
			ZZ3->(Dbskip())
		End

	Endif

Return
