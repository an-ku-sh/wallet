import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Pages/onboarding.dart';
import 'package:wallet/Pages/wallet_home_page.dart';
import 'package:wallet/Utils/wallet_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    if (walletProvider.privateKey == null) {
      // If private key doesn't exist, load CreateOrImportPage
      return const Onboarding();
    } else {
      // If private key exists, load WalletPage
      return Wallet();
    }
  }
}
