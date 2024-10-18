import requests
from bs4 import BeautifulSoup

import json, sys


#urls
#quiniela-nacional
#quiniela_provincia_buenos_aires
#quiniela_santa_fe
#quiniela_cordoba

numF1=-1

def redNum100(num):
    while int(num) >= 100:  # Mientras el número tenga más de un dígito
        num = sum(int(digito) for digito in str(num))  # Sumar los dígitos
    return num

def reduccion_numerologica(num):
    while int(num) >= 10:  # Mientras el número tenga más de un dígito
        num = sum(int(digito) for digito in str(num))  # Sumar los dígitos
    return num

def procesarNums(aNums):
    retJson={}
    retJson['nums']=[]
    ret = ''
    formula=''
    todos=''
    a20=[]
    pos=1
    for num in aNums:
        a20.append(num)
        if pos > 19:
            break
        pos+=1

    resultados = [reduccion_numerologica(num) for num in a20]
    pos=1
    for num in a20:
        retJson['nums'].append(num)
        ret += ""+str(pos)+": "+str(num)+"="+str(resultados[int(pos-1)])+"\n"
        pos+=1

    pos=1
    for num in resultados:
        todos+=str(num)
        if pos == 1:
            formula+=str(num)+"+"
        else:
            formula+="+"+str(num)
        pos+=1
    formula+="="
    #resultados2 = [reduccion_numerologica(num) for num in resultados]
    #ret += "Resultados: "+str(a20)+"\n"
    suma_total = sum(resultados)
    resultado_final = redNum100(suma_total)
    #print(f"Resultado de la nueva reducción numerológica: {resultado_final}")
    #ret += "Resultado: "+str(resultados)+"\n"
    retJson['resNums']=resultados
    ret += "Todos: "+todos+"\n"
    ret += "Formula: "+formula+str(resultado_final)+"\n"
    ret += "Resultado Final: "+str(resultado_final)+"\n"
    #ret = json.dumps(retJson, indent=4)
    ret = retJson
    return ret

def getArrayNums(html):
    aRet=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    ret=''
    soup = BeautifulSoup(html, "html.parser")
    filas = soup.find_all("tr")
    #ret=filas
    for fila in filas:
        #ret+=fila.get_text().replace(" ", "")
        s1 = BeautifulSoup(fila.prettify(), "html.parser")
        celdas = s1.find_all("td")
        f=-1
        for celda in celdas:
            s2 = BeautifulSoup(celda.prettify(), "html.parser")
            celdas2 = s2.find_all("font")
            #f=0
            for celda2 in celdas2:
                s3 = BeautifulSoup(celda2.prettify(), "html.parser")
                celdas3 = s3.find_all("font")
                num=""+celdas3[0].get_text().replace("\n", "").replace(" ", "")+""
                if len(num) == 4:
                    #ret += str(num)#"["+str(f)+": "+celdas3[0].get_text().replace("\n", "").replace(" ", "")+"]"
                    ret += "["+str(f)+": "+str(num)+"]"
                    aRet[int(f - 1)]=str(num)
                elif len(num) == 1 or len(num) == 2:
                    f = int(num)
                else:
                    ret += "["+celdas3[0].get_text().replace("\n", "").replace(" ", "")+"]"
                #f=f+1
                #ret += celda2.get_text().replace(" ", "").replace("\n", "")
                #ret += celda.get_text().replace("\n", "").replace("\r", "")
                ret += "\n"
                #ret += celda.prettify()
    #ret = str(aRet)
    return aRet

def traerDatoTabla(html, fecha, tipo):
    ret = ''
    soup = BeautifulSoup(html, "html.parser")
    tablas = soup.find_all("table")
    for tabla in tablas:
        datos=tabla.get_text()
        if fecha in datos and tipo in datos:
            ret += tabla.prettify()
    return ret



# URL de la página que queremos scrapear
fechaUrl=sys.argv[1].replace("/", "")
lugar=sys.argv[2]
#url = "https://www.tujugada.com.ar/quiniela-nacional.asp"
#url = "https://www.tujugada.com.ar/quiniela-nacional.asp?sorteo="+fechaUrl
url = "https://www.tujugada.com.ar/"+lugar+".asp?sorteo="+fechaUrl

# Hacer una solicitud GET a la página
response = requests.get(url)

#print(response)

jsonFinal={}

# Verificar si la solicitud fue exitosa
if response.status_code == 200:
    html=response.content
    fecha=sys.argv[1]#"12/10/2024"
    tablaPrevia=traerDatoTabla(html, fecha, "Previa")
    tablaPrimera=traerDatoTabla(html, fecha, "Primera")
    tablaMatutina=traerDatoTabla(html, fecha, "Matutina")
    tablaVespertina=traerDatoTabla(html, fecha, "Vespertina")
    tablaNocturna=traerDatoTabla(html, fecha, "Nocturna")
    #print(tablaPrevia)
    #print(str(getArrayNums(tablaPrevia)))

    jsonFinal['previa']=procesarNums(getArrayNums(tablaPrevia))
    jsonFinal['primera']=procesarNums(getArrayNums(tablaPrimera))
    jsonFinal['matutina']=procesarNums(getArrayNums(tablaMatutina))
    jsonFinal['vespertina']=procesarNums(getArrayNums(tablaVespertina))
    jsonFinal['nocturna']=procesarNums(getArrayNums(tablaNocturna))
    #print("Resultados de la PREVIA: "+fecha)
    #print(procesarNums(getArrayNums(tablaPrevia)))
    #print(json.dumps(jsonFinal, indent=4))
#else:
    #print("No pasa naranja....")

print(json.dumps(jsonFinal, indent=4))
