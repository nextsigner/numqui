import sys
import sympy  # Para detectar números primos
from collections import Counter  # Para contar repeticiones

# Función para detectar números pares
def es_par(numero):
    return numero % 2 == 0

# Función para detectar números impares
def es_impar(numero):
    return numero % 2 != 0

# Función para detectar números primos
def es_primo(numero):
    return sympy.isprime(numero)

# Función para detectar múltiplos de un número (ejemplo: múltiplos de 3)
def es_multiplo(numero, divisor):
    return numero % divisor == 0

# Función para extraer pares de 2 cifras consecutivas
def extraer_pares_2_cifras(numero):
    numero_str = str(numero)  # Convertir el número a cadena
    pares = [numero_str[i:i+2] for i in range(len(numero_str) - 1)]  # Extraer pares consecutivos
    return pares

# Función para extraer tripletas de 3 cifras consecutivas
def extraer_tripletas_3_cifras(numero):
    numero_str = str(numero)  # Convertir el número a cadena
    tripletas = [numero_str[i:i+3] for i in range(len(numero_str) - 2)]  # Extraer tripletas consecutivas
    return tripletas

# Función para encontrar repeticiones de números de 2 cifras
def encontrar_repeticiones_pares(numeros):
    pares_totales = []
    for numero in numeros:
        pares_totales.extend(extraer_pares_2_cifras(numero))  # Agregar todos los pares a la lista

    # Contar las repeticiones usando Counter
    contador = Counter(pares_totales)

    # Devolver los pares que se repiten más de una vez
    repeticiones = {par: count for par, count in contador.items() if count > 1}
    return repeticiones

# Función para encontrar repeticiones de números de 3 cifras
def encontrar_repeticiones_tripletas(numeros):
    tripletas_totales = []
    for numero in numeros:
        tripletas_totales.extend(extraer_tripletas_3_cifras(numero))  # Agregar todas las tripletas a la lista

    # Contar las repeticiones usando Counter
    contador = Counter(tripletas_totales)

    # Devolver las tripletas que se repiten más de una vez
    repeticiones = {tripleta: count for tripleta, count in contador.items() if count > 1}
    return repeticiones

# Función para encontrar el número menos repetido (2 cifras)
def encontrar_menos_repetido_pares(numeros):
    pares_totales = []
    for numero in numeros:
        pares_totales.extend(extraer_pares_2_cifras(numero))

    contador = Counter(pares_totales)

    # Devolver el par menos repetido
    menos_repetido = contador.most_common()[-1]  # El último es el menos común
    return menos_repetido

# Función para encontrar el número menos repetido (3 cifras)
def encontrar_menos_repetido_tripletas(numeros):
    tripletas_totales = []
    for numero in numeros:
        tripletas_totales.extend(extraer_tripletas_3_cifras(numero))

    contador = Counter(tripletas_totales)

    # Devolver la tripleta menos repetida
    menos_repetido = contador.most_common()[-1]  # El último es el menos común
    return menos_repetido

# Función para analizar patrones en una lista de números
def detectar_patrones(numeros):
    patrones = {
        "pares": [],
        "impares": [],
        "primos": [],
        "multiplos_de_3": [],
        "repeticiones_pares": {},
        "repeticiones_tripletas": {},
        "menos_repetido_pares": None,
        "menos_repetido_tripletas": None
    }

    for numero in numeros:
        if es_par(numero):
            patrones["pares"].append(numero)
        if es_impar(numero):
            patrones["impares"].append(numero)
        if es_primo(numero):
            patrones["primos"].append(numero)
        if es_multiplo(numero, 3):
            patrones["multiplos_de_3"].append(numero)

    # Encontrar repeticiones de pares de 2 cifras
    patrones["repeticiones_pares"] = encontrar_repeticiones_pares(numeros)

    # Encontrar repeticiones de tripletas de 3 cifras
    patrones["repeticiones_tripletas"] = encontrar_repeticiones_tripletas(numeros)

    # Encontrar el menos repetido para 2 cifras
    if patrones["repeticiones_pares"]:
        patrones["menos_repetido_pares"] = encontrar_menos_repetido_pares(numeros)

    # Encontrar el menos repetido para 3 cifras
    if patrones["repeticiones_tripletas"]:
        patrones["menos_repetido_tripletas"] = encontrar_menos_repetido_tripletas(numeros)

    return patrones
lista_numeros = []
lista=sys.argv[1].split(" ")
for num in lista:
    lista_numeros.append(int(num)) #[1234, 2345, 3456, 4567, 5678, 6789, 7919, 9999, 1299, 9912]

# Detectar patrones en la lista
resultado = detectar_patrones(lista_numeros)

# Imprimir los resultados
cantPares=len(resultado["pares"])
cantImpares=len(resultado["impares"])
if cantPares > cantImpares:
    print("Salieron más pares que impares.")
    print("Cantidad de pares: "+str(cantPares))
    print("Cantidad de impares: "+str(cantImpares))
elif(cantPares == cantImpares):
    print("Salieron la misma cantidad de pares e impares.")
    print("Cantidad de pares: "+str(cantPares))
    print("Cantidad de impares: "+str(cantImpares))
else:
    print("Salieron más impares que pares.")
    print("Cantidad de impares: "+str(cantImpares))
    print("Cantidad de pares: "+str(cantPares))

print('\n')
print("Números pares:", resultado["pares"])
print("Números impares:", resultado["impares"])
print("Números primos:", resultado["primos"])
print("Múltiplos de 3:", resultado["multiplos_de_3"])
print("Repeticiones de pares de 2 cifras:", resultado["repeticiones_pares"])
print("Repeticiones de tripletas de 3 cifras:", resultado["repeticiones_tripletas"])
print("Par menos repetido:", resultado["menos_repetido_pares"])
print("Tripleta menos repetida:", resultado["menos_repetido_tripletas"])
