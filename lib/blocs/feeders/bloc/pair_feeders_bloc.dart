import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

part 'pair_feeders_event.dart';
part 'pair_feeders_state.dart';

class PairFeedersBloc extends Bloc<FeedersEvent, FeedersState> {
  final FeedersRepository _feedersRepository;
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  Completer<void>? _discoveryCompleter;

  PairFeedersBloc({required feedersRepository})
      : _feedersRepository = feedersRepository,
        super(FeedersInitial()) {
    on<LoadUserFeedersEvent>(_loadUserFeedersEventHandler);
    on<PairNewFeederEvent>(_pairNewFeederEventHandler);
    on<DiscoverFeedersEvent>(_discoverFeedersEventHandler);
  }

  FutureOr<void> _discoverFeedersEventHandler(event, emit) async {
    emit(DiscoveringFeedersState(feeders: []));
    if (await Permission.bluetooth.request().isGranted != true) {
      emit(BluetoothErrorFeederState());
      return;
    }
    try {
      bool isEnabled =
          await FlutterBluetoothSerial.instance.requestEnable() == true;
      if (!isEnabled) {
        emit(BluetoothErrorFeederState());
        return;
      }
    } catch (e) {
      emit(BluetoothErrorFeederState());
      print(e);
      return;
    }
    await _cancelDiscovery();
    emit(DiscoveringFeedersState(feeders: []));
    _discoveryCompleter = Completer();
    Future<void> Function() discoverDevices = () {
      List<BluetoothDiscoveryResult> results = [];
      _streamSubscription =
          FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          results[existingIndex] = r;
        } else {
          results.add(r);
        }
        emit(DiscoveringFeedersState(feeders: results));
      });

      _streamSubscription?.onDone(() {
        emit(FinishedDiscoveringFeedersState(feeders: results));
        print('Finish discovering devices');
        _discoveryCompleter?.complete();
      });
      return _discoveryCompleter?.future ?? Future.value();
    };
    await discoverDevices();
  }

  Future<void> _cancelDiscovery() async {
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    _streamSubscription?.onDone(() {});
    await _streamSubscription?.cancel();
    if (_discoveryCompleter?.isCompleted == false) {
      _discoveryCompleter?.complete();
    }
  }

  FutureOr<void> _loadUserFeedersEventHandler(event, emit) async {
    await _cancelDiscovery();
    emit(LoadingUserFeedersState());
    try {
      final List<Feeder> userFeeders =
          await _feedersRepository.getAllUserFeeders();
      if (userFeeders.isEmpty) {
        emit(UserHasNoFeedersState());
      } else {
        emit(FeedersLoadedState(userFeeders: userFeeders));
      }
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> _pairNewFeederEventHandler(
      PairNewFeederEvent event, Emitter<FeedersState> emit) async {
    final Completer completer = Completer();
    print("Connecting to:" + event.device.address);
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(event.device.address);

    String messageBuffer = "";
    Map<String, String> mapData = {};
    connection.input?.listen((data) async {
      messageBuffer =
          _processDataFromPeerBTConnection(data, messageBuffer, mapData);
      final feederName = mapData['feederName'];
      if (feederName != null) {
        print(feederName + " AGAIN ADIOS");
        Feeder feeder =
            await _feedersRepository.createFirestoreFeeder(feederName);
        mapData.remove('feederName');
        await _sendDataToPeerBTConnection(
          feeder.feederId,
          connection,
        );

        await _sendDataToPeerBTConnection(
          FirebaseAuth.instance.currentUser!.uid,
          connection,
        );
        emit(FeederNewFeederPaired());
      }
    }).onDone(() {
      print("Connection closed");
      completer.complete();
    });

    return completer.future;
  }

  Future<void> _sendDataToPeerBTConnection(
      String data, BluetoothConnection connection) async {
    connection.output.add(Uint8List.fromList(utf8.encode("$data\n")));
    await connection.output.allSent;
  }

  String _processDataFromPeerBTConnection(
      Uint8List data, String messageBuffer, Map<String, String> mapData) {
    // Create message if there is new line character
    String dataString = String.fromCharCodes(data);
    int index = data.indexOf('\n'.codeUnits[0]);
    messageBuffer = messageBuffer + dataString;
    if (index >= 0) {
      final lines = messageBuffer.split('\n');
      for (int i = 0; i < lines.length - 1; i++) {
        final String paramName = lines[i].split(":")[0];
        final String paramValue = lines[i].split(":")[1];
        if (paramName == "feederName") {
          mapData[paramName] = paramValue;
          print("FEEDER NAME IS: " + (mapData[paramName] ?? 'NO FEEDER NAME'));
        }
      }
      messageBuffer = messageBuffer.split('\n').last;
    }
    return messageBuffer;
  }
}
