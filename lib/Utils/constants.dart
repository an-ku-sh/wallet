import 'package:web3dart/web3dart.dart';

String infura_url =
    "https://goerli.infura.io/v3/541d9e3028d64feb81ebebdb5b2edc3e";

String contract_address = "0xA426FE72f337fA07cC9FF071c93937C2d64F9A31";

String pv_key_ankush_dev =
    '6c18f02ab795c85dedd502f8bc24cc534e4c42d97b626cf434c4a0891828d7bb';

String pv_key_dev =
    '161d05975f2ab4369e165c4c4550311449546ddd9a257c743113cb6f0eb006b9';

String dev_publicKey = '0x4B92A586C2010a539EE5f9261dD1Ba4D1c1f43AD';

final credentials = EthPrivateKey.fromHex(pv_key_dev);
final recieverAddress = credentials.address;
