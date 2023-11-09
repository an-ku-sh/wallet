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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    //fetching balance using default web3dart methods
    final credentials = EthPrivateKey.fromHex(privateKey!);
    final address = credentials.address;
    print(address.hexEip55);
    print(await ethClient?.getBalance(address));

    await ethClient?.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(
          '0x4B92A586C2010a539EE5f9261dD1Ba4D1c1f43AD',
        ),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 10000000000000000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  // sendEther('0x4B92A586C2010a539EE5f9261dD1Ba4D1c1f43AD',
                  //     '0.02', ethClient!, pvKey);
                },
                child: Text("SendEth")),
            Text(walletAddress),
            Text(balance!)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('privateKey');
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Onboarding(),
          ),
          (route) => false,
        );
      }),
    );
  }
}
