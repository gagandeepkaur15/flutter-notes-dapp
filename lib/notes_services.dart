// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:web_socket_channel/io.dart';
// import './note.dart';
// import 'package:http/http.dart' as http;

// class NoteServices extends ChangeNotifier {
//   List<Note> notes = [];

//   final String _rpcUrl =
//       Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
//   final String _wsUrl =
//       Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';

//   bool isLoading = true;

//   final String _privatekey =
//       '0x20b890a1ea0797bb3fdb718e471189bab8dc99c7ca0858472ea6d26116667102';

//   late Web3Client _web3client;

//   NoteServices() {
//     init();
//   }

//   Future<void> init() async {
//     _web3client = Web3Client(
//       _rpcUrl,
//       http.Client(),
//       socketConnector: () {
//         return IOWebSocketChannel.connect(_wsUrl).cast<String>();
//       },
//     );

//     await getABI();
//     await getCredentials();
//     await getDeployedContract();
//   }

//   late ContractAbi _abiCode;
//   late EthereumAddress _contractAddress;
//   Future<void> getABI() async {
//     String abiFile =
//         await rootBundle.loadString('build/contracts/NotesContract.json');
//     var jsonABI = jsonDecode(abiFile);
//     _abiCode =
//         ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContract');
//     _contractAddress =
//         EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
//   }

//   late EthPrivateKey _creds;
//   Future<void> getCredentials() async {
//     _creds = EthPrivateKey.fromHex(_privatekey);
//   }

//   late DeployedContract _deployedContract;
//   late ContractFunction _createNote;
//   late ContractFunction _deleteNote;
//   late ContractFunction _notes;
//   late ContractFunction _noteCount;

//   Future<void> getDeployedContract() async {
//     _deployedContract = DeployedContract(_abiCode, _contractAddress);
//     _createNote = _deployedContract.function('createNote');
//     _deleteNote = _deployedContract.function('deleteNote');
//     _notes = _deployedContract.function('notes');
//     _noteCount = _deployedContract.function('noteCount');
//     await fetchNotes();
//   }

//   Future<void> fetchNotes() async {
//     List totalTaskList = await _web3client.call(
//       contract: _deployedContract,
//       function: _noteCount,
//       params: [],
//     );

//     int totalTaskLen = totalTaskList[0].toInt();
//     notes.clear();
//     for (var i = 0; i < totalTaskLen; i++) {
//       var temp = await _web3client.call(
//           contract: _deployedContract,
//           function: _notes,
//           params: [BigInt.from(i)]);
//       if (temp[1] != "") {
//         notes.add(
//           Note(
//             id: (temp[0] as BigInt).toInt(),
//             title: temp[1],
//             description: temp[2],
//           ),
//         );
//       }
//     }
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> addNote(String title, String description) async {
//     await _web3client.sendTransaction(
//       _creds,
//       Transaction.callContract(
//         contract: _deployedContract,
//         function: _createNote,
//         parameters: [title, description],
//       ),
//     );
//     isLoading = true;
//     notifyListeners();
//     fetchNotes();
//   }

//   Future<void> deleteNote(int id) async {
//     await _web3client.sendTransaction(
//       _creds,
//       Transaction.callContract(
//         contract: _deployedContract,
//         function: _deleteNote,
//         parameters: [BigInt.from(id)],
//       ),
//     );
//     isLoading = true;
//     notifyListeners();
//     fetchNotes();
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './note.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class NoteServices extends ChangeNotifier {
  List<Note> notes = [];
  final String _rpcUrl =
      'https://7681-2405-201-401c-2003-11be-8de-f1ae-b9f6.ngrok-free.app';
  final String _wsUrl =
      'https://7681-2405-201-401c-2003-11be-8de-f1ae-b9f6.ngrok-free.app';
  // final String _rpcUrl =
  //     Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  // final String _wsUrl =
  //     Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  // bool isLoading = true;

  final String _privatekey =
      '0x20b890a1ea0797bb3fdb718e471189bab8dc99c7ca0858472ea6d26116667102';
  late Web3Client _web3cient;

  NoteServices() {
    init();
  }

  Future<void> init() async {
    _web3cient = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/NotesContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContract');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function('createNote');
    _deleteNote = _deployedContract.function('deleteNote');
    _notes = _deployedContract.function('notes');
    _noteCount = _deployedContract.function('noteCount');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _web3cient.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3cient.call(
          contract: _deployedContract,
          function: _notes,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        notes.add(
          Note(
            id: (temp[0] as BigInt).toInt(),
            title: temp[1],
            description: temp[2],
          ),
        );
      }
    }
    // isLoading = false;

    notifyListeners();
  }

  Future<void> addNote(String title, String description) async {
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [title, description],
      ),
    );
    // isLoading = true;
    fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
    );
    // isLoading = true;
    notifyListeners();
    fetchNotes();
  }
}
