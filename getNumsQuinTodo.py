import sys
import subprocess
import json

fecha=sys.argv[1]

def ejecutar_proceso(comando):
    """Ejecuta un comando y captura la salida."""
    resultado = subprocess.run(comando, capture_output=True, text=True)
    if resultado.returncode == 0:
        return json.loads(resultado.stdout)  # Asume que la salida es un JSON string
    else:
        print(f"Error al ejecutar el comando: {comando}")
        return None

def recolectar_datos():
    """Recolecta los datos de todos los procesos y los combina en un solo JSON."""
    comandos = [
        ['python3', '/home/ns/nsp/numqui/getNumsQuin.py', fecha, 'quiniela-nacional'],
        ['python3', '/home/ns/nsp/numqui/getNumsQuin.py', fecha, 'quiniela_provincia_buenos_aires'],
        ['python3', '/home/ns/nsp/numqui/getNumsQuin.py', fecha, 'quiniela_santa_fe'],
        ['python3', '/home/ns/nsp/numqui/getNumsQuin.py', fecha, 'quiniela-cordoba']
    ]

    datos_recolectados = []

    # Ejecutar cada comando y recolectar los resultados
    for comando in comandos:
        resultado_json = ejecutar_proceso(comando)
        if resultado_json is not None:
            datos_recolectados.append(resultado_json)

    # Combinar todos los resultados en un solo objeto JSON
    datos_combinados = {"resultados": datos_recolectados}

    # Imprimir el JSON combinado
    print(json.dumps(datos_combinados, indent=4))


recolectar_datos()

