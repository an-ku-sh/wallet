import 'package:flutter/services.dart';
import 'package:wallet/Utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('lib/assets/abi.json');
  String contractAddress = contract_address;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Wallet'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String fname, List<dynamic> args,
    Web3Client ethClient, String pvkey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(pvkey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(fname);
  final result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
        contract: contract, function: ethFunction, parameters: args),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );
  return result;
}

//Smart contract function's inference
Future<String> getBalance(Web3Client ethClient, String pvkey) async {
  var response = await callFunction('getBalance', [], ethClient, pvkey);
  print("getBalance");
  print('transaction hash $response');
  return response;
}

// Future<String> ask(String fname, List<dynamic> args, Web3Client ethClient,
//     String pvkey) async {
//   final contract = await loadContract();
//   final ethFunction = contract.function(fname);
//   final result =
//       ethClient.call(contract: contract, function: ethFunction, params: args);
//   print(result.toString());
//   return result.toString();
// }

Future<String> sendEther(
  String address,
  String amount,
  Web3Client ethClient,
  String pvkey,
) async {
  var response = await callFunction(
    'sendEther',
    [
      EthereumAddress.fromHex(address),
      amount,
    ],
    ethClient,
    pvkey,
  );
  print("ETH sent");
  return response;
}
