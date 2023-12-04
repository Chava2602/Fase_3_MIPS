# Programa en emsamblador e Intento de carga al procesador MIPS

## Programa en Emsamblador para aquitectura MIPS
Para esta fase del proyecto, es el momento de implementar un programa en ensamblador para la arquitectura MIPS.

Se decidió, por consideraciones de tiempo y para añadir un nivel de complejidad, desarrollar un programa que calcula la serie de Fibonacci. Además del manual proporcionado en clase, se optó por ampliar la comprensión mediante una investigación adicional, utilizando el libro [Estructura de computadores. Procesadores MIPS y su ensamblador](https://www.agapea.com/libros/) del autor José Antonio Álvarez Bermejo.

Esta decisión contribuyó significativamente a una mejor comprensión de la lógica dentro de la arquitectura MIPS, proporcionando una base sólida para comenzar con la implementación de su ensamblador.

Se decideron usar las siguentes instrucciones:
 -  `li`: Representa la operación de carga inmediata.
 -  `la`: Representa la operación de carga de dirección.
 -  `move`: Representa la operación de copiar el contenido de un registro en otro registro.
 -  `syscall`: Representa la operación de llamada al sistema.
 -  `add`: Representa la operación de carga inmediata.
 -  `addi`: Representa una operación de suma con un valor inmediato.
 -  `bne`: Representa la operación de salto condicional.

Segmentado el codigo quedo asi:

1. Inicialización de Variables:
```assembly
li $t1, 0       # $t1 = 0 (primer número de Fibonacci)
li $t2, 1       # $t2 = 1 (segundo número de Fibonacci)
li $t3, 0       # Contador de bucle
li $t0, 50      # Número total de iteraciones
```
Aquí se están inicializando los primeros dos números de la serie de Fibonacci (`$t1` y `$t2`), así como un contador de bucle (`$t1`) y el número total de iteraciones (`$t1`).


2. Imprimir la Serie Inicial:
```assembly
li $v0, 4       # Código de llamada al sistema para imprimir una cadena
la $a0, result_prompt
syscall
```
Imprime el mensaje *"Fibonacci series: "* usando una llamada al sistema (`syscall`).


3. Bucle para Imprimir la Serie de Fibonacci:
```assembly
print_fibonacci:
    # Imprimir el número de Fibonacci actual
    move $a0, $t1
    li $v0, 1       # Código de llamada al sistema para imprimir un entero
    syscall

    # Imprimir espacio
    li $v0, 4       # Código de llamada al sistema para imprimir una cadena
    la $a0, space_str
    syscall

    # Calcular el siguiente número de Fibonacci
    add $t4, $t1, $t2   # $t4 = $t1 + $t2
    move $t1, $t2       # $t1 = $t2
    move $t2, $t4       # $t2 = $t4

    # Incrementar el contador de bucle
    addi $t3, $t3, 1

    # Verificar si se alcanza el número deseado de iteraciones
    bne $t3, $t0, print_fibonacci
```
Entra en un bucle que imprime el número de Fibonacci actual, imprime un espacio, calcula el siguiente número de Fibonacci y repite hasta que se alcanza el número deseado de iteraciones.


4. Imprimir Nueva Línea:
```assembly
li $v0, 11      # Código de llamada al sistema para imprimir un carácter
li $a0, 10      # Código ASCII para el carácter de nueva línea
syscall
```
Imprime un carácter de nueva línea.


5. Salir del Programa:
```assembly
li $v0, 10      # Código de llamada al sistema para salir
syscall
```
Termina el programa.

## Intento de carga.

### 1.  Traducción a Código Máquina y Exportación (MARS)
 - El código en ensamblador se ensambla en código máquina MIPS utilizando MARS.
 - MARS ofrece la opción de exportar el código ensamblado en formato hexadecimal.

### 2. Conversión del Archivo Hexadecimal a .mif (Script de Python)
- Un script de Python lee el archivo hexadecimal exportado y genera un archivo `.mif`.
- El script organiza los datos hexadecimales en un formato compatible con la inicialización de memorias en simulaciones de hardware digital.

    1. **Lectura del Archivo de Entrada:**
    ```python
    with open('fg.m', 'r') as input_file:
    lines = input_file.readlines()
    ```
    - Abre el archivo `fg.m` en modo lectura (`'r'`).
    - `readlines()` lee todas las líneas del archivo y las guarda en la lista `lines`.
    - Utiliza el bloque `with` para garantizar que el archivo se cierre adecuadamente después de su uso.

    2. **Generación del Archivo .mif:**
    ```python
    with open('fg.mif', 'w') as output_file:
    output_file.write("WIDTH=32;\n")
    output_file.write("DEPTH={};\n".format(len(lines)))
    output_file.write("ADDRESS_RADIX=HEX;\n")
    output_file.write("DATA_RADIX=HEX;\n")
    output_file.write("CONTENT BEGIN\n")
    ```

    - Abre el archivo `fg.mif` en modo escritura (`'w'`).
    - Escribe varias líneas que definen la configuración del archivo `.mif`.
        - `WIDTH=32;`: Establece el ancho de cada palabra de la memoria en 32 bits.
        - `DEPTH={};` : Establece la profundidad de la memoria según la cantidad de líneas leídas del archivo original `fg.m`.
        - `ADDRESS_RADIX=HEX;`: Indica que las direcciones en el archivo `.mif` estarán en formato hexadecimal.
        - `DATA_RADIX=HEX;`: Indica que los datos en el archivo `.mif` estarán en formato hexadecimal.
        - `CONTENT BEGIN`: Marca el inicio de la sección de contenido del archivo `.mif`.


    3. **Escritura del Archivo .mif:**
    ```python
    for i, line in enumerate(lines):
    output_file.write("   {}: {};\n".format(hex(i)[2:].zfill(8).upper(), line.strip()))
    ```
    - Utiliza un bucle `for` y la función `enumerate` para recorrer las líneas del archivo original junto con sus índices.
    - Para cada línea, escribe una entrada en el formato `.mif`.
        - `hex(i)`: Convierte el índice i a formato hexadecimal.
        - `[2:]`: Omite los primeros dos caracteres ('0x') del formato hexadecimal.;
        - `zfill(8)`: Rellena con ceros a la izquierda para asegurar que la dirección tenga 8 dígitos.
        - `upper()`: Convierte la cadena a mayúsculas.
        - `line.strip()`: Elimina espacios en blanco al principio y al final de la línea original.
    - Se escribe cada entrada en el archivo `.mif` con el formato `ADDRESS: DATA;`.


    4. **Escritura de la línea final**
    ```python
    output_file.write("END;\n")
    ```
    - Escribe la línea que marca el final de la sección de contenido del archivo `.mif`.

### 3. Manipulación de InstructionMemory32.v (Verilog)
- Se modifica el módulo `InstructionMemory32.v` (la memoria de instrucciones en el diseño del procesador MIPS) para cargar las instrucciones desde el archivo `.mif` generado durante la simulación.

- Se utiliza el comando `$readmemb` o `$readmemh` en el bloque initial para cargar las instrucciones en la memoria de instrucciones.

### 4. Simulación en ModelSim (Desafío Detectado):
- ModelSim no detecta el archivo `.mif`, generando un error del tipo *"(vsim-7) Failed to open readmem file"*.

### Conclusión

El proceso mostró progresos significativos, pero la resolución del desafío en ModelSim será crucial para lograr una simulación exitosa del procesador MIPS con el programa ensamblado. Este desafío representa una oportunidad para profundizar en la resolución de problemas específicos de simulación en entornos como ModelSim.
