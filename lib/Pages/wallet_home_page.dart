import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/Pages/onboarding.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => WalletState();
}

class WalletState extends State<Wallet> {
  //Wallet Credentials
  String walletAddress = '';
  String? accountBalance = '';
  String pvKey = '';

  //Web3
  String infuraUrl =
      "https://goerli.infura.io/v3/541d9e3028d64feb81ebebdb5b2edc3e";
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient!);
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    // print("load wallet called");
    //loading private key from sharedPrefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');

    //fetching balance
    Credentials credentials = EthPrivateKey.fromHex(privateKey!);
    var address = credentials.address;
    // print(address.hex);
    EtherAmount balance = await ethClient!.getBalance(address);
    // print(balance.getValueInUnit(EtherUnit.ether));

    //updating wallet data
    setState(() {
      walletAddress = address.toString();
      accountBalance = balance.getValueInUnit(EtherUnit.ether).toString();
    });

    //auto send transaction
    await ethClient?.sendTransaction(
      credentials,
      Transaction(
        from: EthereumAddress.fromHex(
            '0x949ae7ddd794a6040237022eeff3a596fadd6157'),
        to: EthereumAddress.fromHex(
            '0x4B92A586C2010a539EE5f9261dD1Ba4D1c1f43AD'),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 20000000000000000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Send Eth")),
            Text(walletAddress),
            Text(accountBalance!)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
        },
      ),
    );
  }
}
