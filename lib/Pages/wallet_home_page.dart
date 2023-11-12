import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/Pages/onboarding.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../Utils/constants.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => WalletState();
}

class WalletState extends State<Wallet> {
  //Wallet Credentials
  String walletAddress = '';
  String? balance = '';
  String pvKey = '';
  Credentials? creds;

  //Web3
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    print("load wallet called");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? privateKey = preferences.getString('privateKey');

    //fetching balance using default web3dart methods
    final credentials = EthPrivateKey.fromHex(privateKey!);
    final address = credentials.address;
    print(address.hexEip55);
    print(await ethClient?.getBalance(address));
    EtherAmount? bal = await ethClient?.getBalance(address);

    setState(() {
      walletAddress = address.hexEip55;
      balance = bal?.getInWei.toString();
      creds = credentials;
      pvKey = privateKey;
    });
  }

  // Future<void> sendEth() async {
  //   await ethClient?.sendTransaction(
  //     creds!,
  //     Transaction(
  //       to: EthereumAddress.fromHex('0xC91...3706'),
  //       gasPrice: EtherAmount.inWei(BigInt.one),
  //       maxGas: 100000,
  //       value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 1),
  //     ),
  //   );
  // }

  Future<void> requestEth() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Frictionless zkWallet",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(walletAddress),
              Text("Balance in Wei $balance"),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text("Send Eth"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('privateKey');
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Onboarding(),
            ),
            (route) => false,
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
