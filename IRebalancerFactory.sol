// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.14;


// Mock
library AddressSet {


    struct Set {
        bool foo;
    }
}


/// @title Rebalance Strategy Contract Factory Interface
/// @notice The RebalancerFactory interface enables users to create and manage
/// their own instances of rebalance strategy contracts.
interface IRebalancerFactory {


    // Storage
    struct StrategyType {
        address implementation;
        string description;
        bool deployable;
        AddressSet.Set strategySet;
    }


    struct StrategyInstance {
        uint256 typeId;
        address instance;
        address vault;
        bool enabled;
    }


    struct Vault {
        AddressSet.Set strategyInstanceSet;
    }


    // Events
    event StrategyTypeRegistered(
        uint256 indexed typeId,
        address indexed implementation,
        bool indexed deployable,
        string description
    );


    event StrategyInstanceDeployed(
        uint256 indexed typeId,
        address indexed strategyInstance,
        address indexed owner
    );


    event LegacyStrategyRegistered(
        uint256 indexed typeId,
        address indexed strategyInstance,
        address indexed vault
    );


    event StrategyTypeEnabled(uint256 indexed typeId);
    event StrategyTypeDisabled(uint256 indexed typeId);
    event StrategyEnabled(address indexed strategyInstance);
    event StrategyDisabled(address indexed strategyInstance);


    /// @notice Initializes the RebalancerFactory with the VaultFactory address.
    /// @param vaultFactoryAddress The address of the VaultFactory contract.
    function initialize(address vaultFactoryAddress) external;


    /// @notice Registers a new strategy type with the given implementation address,
    /// description, and active status.
    /// @dev Requires ROLE_STRATEGY_TYPE_REGISTRAR.
    /// @param implementation The implementation address of the strategy.
    /// @param description A human-readable description of the strategy.
    /// @param deployable The deployable status of the strategy type.
    function registerStrategyType(
        address implementation,
        string calldata description,
        bool deployable
    ) external;


    /// @notice Deploys a new strategy instance with the specified typeId.
    /// @dev Requires ROLE_STRATEGY_DEPLOYER.
    /// @param typeId The type ID of the strategy to be deployed.
    /// @param initData Arbitrary data to pass to the initializer() function.
    /// @param owner Owner that will receive control of the deployed rebalancer.
    /// @return strategyInstance The address of the newly deployed strategy instance.
    function deployStrategyInstance(
        uint256 typeId,
        bytes calldata initData,
        address owner
    ) external returns (address strategyInstance);


    /// @notice Registers a legacy strategy with the given typeId, strategyInstance, and vault.
    /// @dev Requires ROLE_LEGACY_STRATEGY_REGISTRAR.
    /// @param typeId The type ID of the legacy strategy.
    /// @param strategyInstance The address of the legacy strategy instance.
    /// @param vault The address of the vault associated with the legacy strategy.
    function registerLegacyStrategy(
        uint256 typeId,
        address strategyInstance,
        address vault
    ) external;


    /// @notice Records that the strategy is enabled. Has no effect on deployed strategy contract.
    /// @dev Requires ROLE_STRATEGY_TYPE_ACTIVE_SETTER.
    /// @param typeId The type ID of the strategy.
    function enableStrategyType(uint256 typeId) external;


    /// @notice Records that the strategy is disable. Has no effect on deployed strategy contract.
    /// @dev Requires ROLE_STRATEGY_TYPE_ACTIVE_SETTER.
    /// @param typeId The type ID of the strategy.
    function disableStrategyType(uint256 typeId) external;


    /// @notice Enables a strategy instance.
    /// @dev Requires ROLE_STRATEGY_ENABLE_SETTER.
    /// @param strategyAddress The address of the strategy instance.
    function enableStrategy(address strategyAddress) external;


    /// @notice Disables a strategy instance.
    /// @dev Requires ROLE_STRATEGY_ENABLE_SETTER.
    /// @param strategyAddress The address of the strategy instance.
    function disableStrategy(address strategyAddress) external;


    /// @notice Checks if a strategy instance is enabled.
    /// @param strategyAddress The address of the strategy instance.
    /// @return isEnabled True if the strategy is enabled, false otherwise.
    function isStrategyEnabled(address strategyAddress) external view returns (bool isEnabled);


    /// @notice Returns the number of registered strategy types.
    /// @return count The number of registered strategy types.
    function getStrategyTypeCount() external view returns (uint256 count);


    /// @notice Returns information about a strategy type.
    /// @param strategy The address of the strategy instance.
    /// @return description A human-readable description of the strategy.
    /// @return active The active status of the strategy type.
    /// @return strategyCount The number of  instances of the strategy type.
    function getStrategyType(address strategy) external view returns (
        string memory description,
        bool active,
        uint256 strategyCount
    );


    /// @notice Returns the number of strategy instances for a given typeId.
    /// @param typeId The type ID of the strategy.
    /// @return count The number of strategy instances for the given typeId.
    function getTypeStrategyCount(uint256 typeId) external view returns (uint256 count);


    /// @notice Returns the strategy instance address for a given typeId and index.
    /// @param typeId The type ID of the strategy.
    /// @param index The index of the strategy instance.
    /// @return strategyInstance The address of the strategy instance.
    function getTypeStrategyByIndex(
        uint256 typeId,
        uint256 index
    ) external view returns (StrategyInstance memory strategyInstance);


    /// @notice Returns an array of strategy instances for a given typeId.
    /// @param typeId The type ID of the strategy.
    /// @return strategyInstances An array of strategy instances.
    function getTypeStrategies(uint256 typeId) external view returns (StrategyInstance[] memory strategyInstances);


    /// @notice Checks if a given typeId is a registered strategy type.
    /// @param typeId The type ID of the strategy.
    /// @return isIndeed True if the typeId is a registered strategy type, false otherwise.
    function isStrategyType(uint256 typeId) external view returns (bool isIndeed);


    /// @notice Returns the total number of strategy instances.
    /// @return count The total number of strategy instances.
    function getStrategyInstanceCount() external view returns (uint256 count);


    /// @notice Returns information about a strategy instance.
    /// @param strategy The address of the strategy instance.
    /// @return typeId The type ID of the strategy.
    /// @return vault The address of the associated vault.
    /// @return enabled True if the instance is considered enabled.
    function getStrategyInstance(address strategy) external view returns (
        uint256 typeId,
        address vault,
        bool enabled
    );


    /// @notice Checks if a given address is a registered strategy instance.
    /// @param strategyAddress The address of the strategy instance.
    /// @return isIndeed True if the address is a registered strategy instance, false otherwise.
    function isStrategyInstance(address strategyAddress) external view returns (bool isIndeed);


    /// @notice Returns the number of strategies associated with a vault.
    /// @param vault The address of the vault.
    /// @return count The number of strategies associated with the vault.
    function getVaultStrategyCount(address vault) external view returns (uint256 count);


    /// @notice Returns the strategy instance address for a given vault and index.
    /// @param vault The address of the vault.
    /// @param index The index of the strategy instance.
    /// @return strategyInstance Strategy instance.
    function getVaultStrategyByIndex(
        address vault,
        uint256 index
    ) external view returns (StrategyInstance memory strategyInstance);


    /// @notice Returns an array of strategy instances associated with a given vault.
    /// @param vault The address of the vault.
    /// @return strategyInstances An array of strategy instance addresses.
    function getVaultStrategies(address vault) external view returns (StrategyInstance memory strategyInstances);


    /// @notice Checks if a given strategy instance is associated with a vault.
    /// @param vault The address of the vault.
    /// @param strategy The address of the strategy instance.
    /// @return isIndeed True if the strategy instance is associated with the vault, false otherwise.
    function isVaultStrategy(address vault, address strategy) external view returns (bool isIndeed);


}
