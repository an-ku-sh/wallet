import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Pages/onboarding.dart';
import 'package:wallet/Pages/wallet_home_page.dart';
import 'package:wallet/Utils/wallet_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the private key
  WalletProvider walletProvider = WalletProvider();
  await walletProvider.loadPrivateKey();

  runApp(
    ChangeNotifierProvider<WalletProvider>.value(
      value: walletProvider,
      child: const MaterialAppBase(),
    ),
  );
}

class MaterialAppBase extends StatelessWidget {
  const MaterialAppBase({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    return MaterialApp(
      home: walletProvider.privateKey == null ? Onboarding() : Wallet(),
    );
  }
}
