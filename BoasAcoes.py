
import requests, xlwt, re, sys, time, datetime
import urllib.request


try:
    
    wb = xlwt.Workbook()
    sheet2 = wb.add_sheet('Lista de FIIs', cell_overwrite_ok=True)
    style2 = xlwt.easyxf('pattern: pattern solid, fore_colour dark_blue;' 'font: colour white, bold True;')

    # Titulo
    sheet2.write_merge(0, 0, 0, 2, 'Lista de Fiis - Bruno Caseiro', style2)

    # Cabecalho
    sheet2.write(4, 0, 'Valor a Investir:', style2)
    sheet2.write(4, 1, 350000, style2)
    
    sheet2.write(8, 0, 'Ticker', style2)
    sheet2.write(8, 1, 'P/VP', style2)
    sheet2.write(8, 2, 'Valor Patrimonial', style2)
    sheet2.write(8, 3, 'Cota Atual', style2)
    sheet2.write(8, 4, 'Retorno por cota - 12 meses', style2)
    sheet2.write(8, 5, 'Ultimo Dividendo', style2)
    sheet2.write(8, 6, 'Numero de Cotas', style2)
    sheet2.write(8, 7, 'Receita Estimada Mensal', style2)
    sheet2.write(8, 8, 'Liquidez', style2)
    sheet2.write(8, 9, 'No. Cotistas', style2)
    sheet2.write(8, 10, 'Valor em Caixa', style2)
    sheet2.write(8, 11, 'Inicio do Fundo', style2)
    primeiro_fii = 9


    lista_fiis = open('listagem_fiis.txt','r')
    #lista_fiis = lista_fiis.read()


    for fii in lista_fiis:
 
        
        ### DEterminado ticker - fii
        fii = fii.strip()

        status_invest_url = 'https://www.fundsexplorer.com.br/funds/' + fii
        response = requests.get(status_invest_url)
        string_response = str(response.text)
        #print (string_response)
        print (fii)
       
    
        ### Determinado valor Atual da Cota
        regex_valorAtualCota = re.compile('<span class="price">[\\n\\tR\$ ]+[0-9]+,[0-9]+')
        valor_atualcota = (regex_valorAtualCota.findall(string_response))
        valor_atualcota = str(valor_atualcota)
        valor_atualcota = valor_atualcota.split('R$ ')
        valor_atualcota = valor_atualcota[1]
        valor_atualcota = valor_atualcota.replace("']",'')
        #valor_atualcota = valor_atualcota.replace(",",'.')
        
        print (valor_atualcota, 'Valor da cota atual')


            ### Determinando Valor Patrimonial
        regex_valorPatrimonial = re.compile('Valor Patrimonial</span>[\\n\\t- ="<a-zA-Z\->\$]+[0-9]+,[0-9]+')
        valor_Patrimonial = (regex_valorPatrimonial.findall(string_response))
        valor_Patrimonial = str(valor_Patrimonial)
        valor_Patrimonial = valor_Patrimonial.split("R$ ")
        valor_Patrimonial = valor_Patrimonial[1].replace("']",'')
        valor_Patrimonial = valor_Patrimonial.replace("'",'')
        #valor_Patrimonial = valor_Patrimonial
        print (valor_Patrimonial, 'Valor Patrimonial')


        ### Determinando P/VP
        regex_pvp = re.compile('P/VP</span>[\\n\\t- ="<a-zA-Z\->\$]+[0-9]+,[0-9]+')
        valor_pvp = (regex_pvp.findall(string_response))
        valor_pvp = str(valor_pvp)
        valor_pvp = valor_pvp.split('indicator-value">\\n')
        valor_pvp = valor_pvp[1].replace("']",'')
        valor_pvp = valor_pvp.replace("'",'')
        valor_pvp = valor_pvp.strip()
        print (valor_pvp, 'P/VP')



            ### Determinando Proventos dos Ultimos 12 meses
        regex_12meses = re.compile('<th>12 meses</th>[\\n\\t ]+<th>Desde o IPO</th>[\\n\\t ]+</tr>[\\n\\t ]+</thead>[\\n\\t ]+<tbody>[\\n\\t ]+<tr>[\\n\\t ]+<td>Retorno por cota</td>[\\n\\t ]+[<td>R\$ 0-9.,-/]+\\n[<td>R\$ 0-9.,-/]+\\n[<td>R\$ 0-9.,-/]+\\n[<td>R\$ 0-9.,-/]+')
        div_12meses = (regex_12meses.findall(string_response))
        div_12meses = str(div_12meses)
        div_12meses = div_12meses.split("<td>Retorno por cota</td>\\n ")
        div_12meses = div_12meses[1].replace("<td>","")
        div_12meses = div_12meses.replace("</td>","")
        div_12meses = div_12meses.replace("                       ","")
        div_12meses = div_12meses.split("\\n ")
        div_12meses = div_12meses[3]
        div_12meses = div_12meses.replace('R$ ','')
        div_12meses = div_12meses.replace("']",'')
        div_12meses = div_12meses.replace("'",'')
        print (div_12meses, "12 meses")


        ## Ultimo dividendo - ['Último Rendimento</span>\n              <span class="indicator-value">\n                R$ 0,60\n']
        regex_UltimoDividendo = re.compile('Último Rendimento</span>\\n[\\n\t <>a-zA-z0-9-.,="\$]+\\n')
        Ultimo_Dividendo = (regex_UltimoDividendo.findall(string_response))
        Ultimo_Dividendo = str(Ultimo_Dividendo)
        Ultimo_Dividendo = Ultimo_Dividendo.split("R$ ")
        Ultimo_Dividendo = Ultimo_Dividendo[1].replace("\\n']","")
 
        print (Ultimo_Dividendo, "Ultimo Dividendo")
        
            

        '''

            ### Determinando Proventos dos Ultimos 24 meses
        regex_24meses = re.compile('RENDIMENTO MENSAL MÉDIO \(24M\)</h3>\\n<span class="icon">R\$</span>\\n<strong class="value">[0-9.-]+,[0-9.-]+</strong>')
        div_24meses = (regex_24meses.findall(string_response))
        div_24meses = str(div_24meses)
        div_24meses = div_24meses.replace('RENDIMENTO MENSAL MÉDIO (24M)</h3>\\n<span class="icon">R$</span>\\n<strong class="value">','')
        div_24meses = div_24meses.replace('</strong>','')
        div_24meses = div_24meses.replace("']",'')
        div_24meses = div_24meses.replace("['",'')
        print (div_24meses)
        


        
        ### Determinando Valor em Caixa
        regex_ValorCaixa = re.compile('Valor em caixa</h3>\\n<strong class="value">[0-9.-]+,[0-9.-]+</strong>\\n<span class="icon">[a-zA-Z0-9-.,%]+</span>\\n</div>\\n<div class="">\\n<span class="sub-title">Total</span>\\n<span class="sub-value">R\$ [0-9.-]+,[0-9.-]+</span>') 
        valor_caixa = (regex_ValorCaixa.findall(string_response))
        print (valor_caixa)
        valor_caixa = str(valor_caixa)
        valor_caixa = valor_caixa.replace('</span>','')
        valor_caixa = valor_caixa.split('R$ ')
        if len(valor_caixa) > 1:
            valor_caixa = valor_caixa[1].replace("']",'')
            #valor_caixa = valor_caixa[1].replace("'",'')
        '''

    
        ### Determinando a Liquidez
        regex_Liquidez = re.compile('Liquidez Diária</span>\\n[a-z \\t<>"=-]+\\n[ 0-9.,]+') 
        liquidez = (regex_Liquidez.findall(string_response))
        liquidez = str(liquidez)
        liquidez = liquidez.split('"indicator-value">\\n')
        liquidez = liquidez[1]
        liquidez = liquidez.replace("']","")
        liquidez = liquidez.strip()
        print (liquidez, "Liquidez")

        #Calculo Numero de Cotas
        valor_atualcota_convertido = valor_atualcota.replace(',','.')
        valor_atualcota_convertido = float(valor_atualcota_convertido)
        numero_cotas = int((350000 / valor_atualcota_convertido))
        
        sheet2.write(primeiro_fii, 0, fii)
        sheet2.write(primeiro_fii, 1, valor_pvp)
        sheet2.write(primeiro_fii, 2, valor_Patrimonial)
        sheet2.write(primeiro_fii, 3, valor_atualcota)
        sheet2.write(primeiro_fii, 4, div_12meses)
        sheet2.write(primeiro_fii, 5, Ultimo_Dividendo)
        sheet2.write(primeiro_fii, 6, numero_cotas)
        sheet2.write(primeiro_fii, 7, numero_cotas * Ultimo_Dividendo)
        sheet2.write(primeiro_fii, 8, liquidez)

   
        primeiro_fii = primeiro_fii + 1


            
    wb.save("Lista_Fiis.xlsx")


except PermissionError: 
    print ('Planilha listagem_fiis.xlsx aberta. Favor fechar e tentar novamente.')




#### <<<================== continuar aqui.. depois liquidez



