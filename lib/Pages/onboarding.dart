import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Pages/wallet_home_page.dart';
import 'package:wallet/Utils/wallet_provider.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool keyExists = false;
  void keyGen() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final mnemonic = walletProvider.generateMnemonic();
    walletProvider.getPrivateKey(mnemonic).then(
      (privateKey) {
        setState(
          () {
            keyExists = true;
            print(keyExists);
            navigateToWalletPage();
          },
        );
      },
    );
    print(mnemonic);
  }

  void navigateToWalletPage() {
    print("push called");
    keyExists
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Wallet(),
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number To Continue",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Continue"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    keyGen();
                  },
                  child: const Text("Generate Wallet"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
