// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title KipuBank
/// @notice Gestiona el retiro y deposito de tokens
contract KipuBank {
    // =====>Variables
    /// @notice Limite de retiro por transacción
    uint256 public immutable limiteRetiroTransaccion;
    /// @notice Limite total que puede manejar el banco
    uint256 public immutable limiteBanco;
    /// @notice Total de tokens actualmente depositado en el contrato
    uint256 public totalDepositado;
    /// @notice Mapeo de cada usuario a su balance almacenado
    mapping(address => uint256) public vault;

    /// @notice Numero total de depósitos realizados
    uint256 public totalDepositos;

    /// @notice Numero total de retiros realizados
    uint256 public totalRetiros;

    // Eventos
    /// @notice evento cuando un usuario realiza un depósito exitoso
    /// @param usuario Direccion del depositante
    /// @param monto Monto depositado
    event Depositar(address indexed usuario, uint256 monto);
    /// @notice evento cuando un usuario realiza un depósito exitoso
    /// @param usuario Direccion del usuario
    /// @param monto Monto retirado
    event Retirar(address indexed usuario, uint256 monto);
    
    // =====>Errores
    /// @notice El monto enviado es cero
    error depositoEnCeros();
    /// @notice Se excdio el limite global de depósito
    error limiteGlobalAlcanzado();
    /// @notice Intento de retiro mayor al limite permitido
    error limiteRetiroAlcanzado();
    /// @notice No hay suficientes fondos para retirar
    error balanceInsuficiente();
    /// @notice Fallo la transferencia de fondos
    error falloEnTransferencia();

    // =====>Constructor

    /// @notice Inicializa el contrato con límites definidos
    /// @param retiroMaximoPorTransaccion Máximo retiro por transacción
    /// @param limiteGlobal de depositos del banco
    constructor(uint256 retiroMaximoPorTransaccion, uint256 limiteGlobal) {
        require(
            retiroMaximoPorTransaccion > 1 && limiteGlobal > 20,
            "El limite debe ser mayor a 0"
        );
        limiteRetiroTransaccion = retiroMaximoPorTransaccion;
        limiteBanco = limiteGlobal;
    }

    // =====>Modificadores

    /// @notice Revisa que el usuario tenga suficientes tokens
    modifier cuentaConSuficientesFondos(uint256 monto) {
        if (monto > vault[msg.sender]) revert balanceInsuficiente();
        _;
    }

    // ======>Funciones

    /// @notice Permite depositar tokens en la cuenta del usuario
    function depositar(uint256 monto) external payable cuentaConSuficientesFondos(monto) {
        if (monto == 0) revert depositoEnCeros();
        if (totalDepositado + monto > limiteBanco)
            revert limiteGlobalAlcanzado();
        totalDepositado += monto;
        vault[msg.sender] += monto;
        totalDepositos++;
        emit Depositar(msg.sender, monto);
    }

    /// @notice Permite retirar fondos de la cuenta del usuario
    /// @param monto a retirar
    function retiro(uint256 monto) external cuentaConSuficientesFondos(monto) {
        if (monto > limiteRetiroTransaccion) revert limiteRetiroAlcanzado();
        vault[msg.sender] -= monto;
        totalDepositado -= monto;
        totalRetiros++;
        transferencia(msg.sender, monto);
        emit Retirar(msg.sender, monto);
    }

    /// @notice Consulta el balance de la cuenta del usuario
    /// @param usuario numero de la direccion de usuario
    /// @return balance  almacenado en la cuenta del usuario
    function obtenerBalance(address usuario)
        external
        view
        returns (uint256 balance)
    {
        return vault[usuario];
    }

    /// @notice Realiza la transferencia de tokens
    /// @param destinatario de los fondos
    /// @param monto a transferir
    function transferencia(address destinatario, uint256 monto) private {
        (bool success, ) = destinatario.call{value: monto}("");
        if (!success) {
            revert falloEnTransferencia();
        }
    }
}
