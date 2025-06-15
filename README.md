# kipu-bank

>Descripción

KipuBank es un contrato inteligente escrito en Solidity que permite a los usuarios depositar y retirar tokens dentro de una cuenta.

Algunas de las caractericticas del contrato son:
- Limite máximo de retiro por transacción
- Limite total de fondos que puede contener el banco
- Control de balance individual por usuario
- Manejo de errores personalizados
- Eventos emitidos en cada operación.


>Despliegue del contrato

1. Abrir https://remix.ethereum.org).
2. Crea un nuevo archivo llamado 'KipuBank.sol'.
3. Copia y pega el código del contrato.
4. Compila el archivo:
   - Ir a la pestaña "Solidity Compiler".
   - Seleccio na de usar la versión '0.8.30'.
   - Haz clic en Compile KipuBank.sol.
5. Ve a la pestaña "Deploy & Run Transactions".
   - Selecciona el contrato `KipuBank`.
   - Introduce los parámetros del constructor:
     - 'retiroMaximoPorTransaccion': Ejemplo ? `1000000000000000000` (1 ETH en wei)
     - `limiteGlobal`: Ejemplo ? `10000000000000000000` (10 ETH en wei)
   - Haz clic en Deploy.
 
>Cómo interactuar con el contrato

1.Indicar el monto de deposito(uint256 monto) external payable`
Deposita tokens en la cuenta del usuario.
- El monto debe ser mayor a 0.
- No debe exceder el límite total del banco.

2.Funcion 'retiro(uint256 monto) external'
Retira una cantidad específica de token desde tu cuenta.

- No puedes retirar más de lo que tienes.
- El monto no debe exceder el límite de retiro por transacción.


3.Funcion 'obtenerBalance(address usuario) external view returns (uint256)'
Consulta el balance actual de una dirección indicada.
