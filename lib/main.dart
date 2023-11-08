import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Utils/wallet_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<WalletProvider>(
      create: (context) => WalletProvider(),
      child: MaterialAppBase(),
    ),
  );
}

class MaterialAppBase extends StatelessWidget {
  const MaterialAppBase({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final mnemonic = walletProvider.generateMnemonic();
              final privateKey = await walletProvider.getPrivateKey(mnemonic);
              final publicKey = await walletProvider.getPublicKey(privateKey);
              print(mnemonic);
              print(privateKey);
              print(publicKey);
            },
            child: const Text("Generate Phrase"),
          ),
        ),
      ),
    );
  }
}
