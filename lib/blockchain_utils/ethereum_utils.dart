import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_wallet_/models/wallet.dart';
import 'package:riverpod/riverpod.dart';
import 'package:web_socket_channel/io.dart';

const String savedBalance = "savedBalance";

final ethereumUtilsProvider = Provider((ref) => EthereumUtils());

enum SCEvents {
    Balance
}

class EthereumUtils {
    late http.Client _httpClient;
    late Web3Client _ethClient;
    final String _rpcUrl = 'http://$dotenv.env['RPC_URL']:$dotenv.env['PORT']';
    final String _wsUrl = 'ws://$dotenv.env['WS_URL']:$dotenv.env['PORT']';
    String? privateKey = dotenv.env['GANACHE_PRIVATE_KEY'];
    late Credentials credentials;
    late SharedPreferences _prefs;

    late String abi;
    late EthereumAddress contractAddress;
    late DeployedContract contract;
    List? decoded;
    late WalletModel wallet;

    void initialSetup() async {
        _prefs = await SharedPreferences.getInstance();
        _httpClient = http.Client();
        _ethClient = Web3Client(
            _rpcUrl,
            _httpClient,
            socketConnector: () {
                return IOWebSocketChannel.connect(_wsUrl).cast<String>(),
            }
        );
    }

    Future listenContract() async {
        contract = await _getContract();
        listenEvent();
        return decoded;
    }

    StreamSubscription listenEvent() {
        var events = _ethClient.events(FilterOptions.events(contract: contract, event: contract.event('BalanceChange')));
        return events.listen((FilterEvent event) {
            if(event.topics == null || event.data == null) {
                return;
            }

            decoded = contract.event('BalanceChange').decodedResults(event.topics!, event.data!);
            print("Listen event: $decoded");

            List<String> balanceList = decoded!.map((e) => e.toInt().toString()).toList();

            _prefs.setStringList(savedBalance, balanceList);
        });
    }

    Future<DeployedContract> _getContract() async {
        Completer<DeployedContract> completer = Completer();

        await rootBundle.loadString('assets/contracts_abis/Investments.json')
        .then((abiString) => {
            var abiJson = jsonDecode(abiString);
            abi = jsonEncode(abiJson['abi']);
        })
    }
}