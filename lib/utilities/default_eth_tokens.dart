import 'package:stackwallet/models/isar/models/ethereum/eth_contract.dart';

abstract class DefaultTokens {
  static List<EthContract> list = [
    EthContract(
      address: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
      name: "USD Coin",
      symbol: "USDC",
      decimals: 6,
      type: EthContractType.erc20,
    ),
    EthContract(
      address: "0xdac17f958d2ee523a2206206994597c13d831ec7",
      name: "Tether",
      symbol: "USDT",
      decimals: 6,
      type: EthContractType.erc20,
    ),
    EthContract(
      address: "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce",
      name: "Shiba Inu",
      symbol: "SHIB",
      decimals: 18,
      type: EthContractType.erc20,
    ),
    EthContract(
      address: "0x514910771af9ca656af840dff83e8264ecf986ca",
      name: "Chainlink",
      symbol: "LINK",
      decimals: 18,
      type: EthContractType.erc20,
    ),
    EthContract(
      address: "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
      name: "Uniswap",
      symbol: "UNI",
      decimals: 18,
      type: EthContractType.erc20,
    ),
  ];
}