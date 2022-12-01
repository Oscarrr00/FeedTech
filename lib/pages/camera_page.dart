import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _MQTTClientState();
}

class _MQTTClientState extends State<CameraPage> {
  bool isConnected = false;
  bool isConnecting = false;

  String host = "192.168.43.240";
  int port = 4883;
  Uint8List? _currentImage;

  late MqttServerClient client;

  @override
  void initState() {
    client = MqttServerClient(host, '');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  @override
  void dispose() {
    _disconnect(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mira a tu mascota!",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController hostCtlr =
                      TextEditingController(text: host);
                  final TextEditingController portCtlr =
                      TextEditingController(text: port.toString());
                  return AlertDialog(
                      title: Text("Cambiar configuración"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Nuevo host:",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: hostCtlr,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Nuevo puerto:",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: portCtlr,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancelar")),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                host = hostCtlr.text;
                                port = int.tryParse(portCtlr.text) ?? 4883;
                              });
                              _disconnect(false);
                              client = MqttServerClient(host, '');
                              Navigator.of(context).pop();
                              _connect();
                            },
                            child: Text("Guardar")),
                      ]);
                },
              );
            },
            icon: Icon(
              Icons.settings,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 3, child: SizedBox.expand()),
          _getMainChild(),
          Expanded(flex: 7, child: SizedBox.expand()),
        ],
      ),
    );
  }

  Widget _getMainChild() {
    if (isConnected) {
      return Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Transmisión en vivo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _cameraStream(),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: SizedBox.shrink()),
                  if (isConnected)
                    ElevatedButton(
                      onPressed: () {
                        _save();
                      },
                      child: const Text(
                        '    Capturar    ',
                      ),
                    ),
                  if (isConnected) SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _disconnect(false);
                    },
                    child: const Text(
                      'Desconectar',
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                ],
              )
            ],
          ));
    } else {
      return _getConnectingChild();
    }
  }

  Widget _getConnectingChild() {
    if (isConnecting) {
      return Container(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "No hay conexión a\na la cámara.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: Center(
                child: ElevatedButton(
              onPressed: () {
                _connect();
              },
              child: Text("Reconectar"),
            )),
          ),
        ],
      );
    }
  }

  Widget _cameraStream() {
    return StreamBuilder(
      stream: client.updates,
      builder: (context,
          AsyncSnapshot<List<MqttReceivedMessage<MqttMessage>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24),
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  "Esperando datos\nde la cámara...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          );
        } else {
          final mqttReceivedMessages = snapshot.data;
          final recMess =
              mqttReceivedMessages![0].payload as MqttPublishMessage;
          _currentImage = Uint8List.view(
            recMess.payload.message.buffer,
            0,
            recMess.payload.message.length,
          );
          return Container(
            width: double.infinity,
            child: Image.memory(
              _currentImage!,
              gaplessPlayback: true,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  _save() async {
    if (_currentImage == null) {
      return;
    }
    if (!await Permission.storage.isGranted &&
        !await Permission.storage.request().isGranted) {
      return;
    }
    final result = await ImageGallerySaver.saveImage(
      _currentImage!,
      quality: 100,
      name: "FeedTech${DateTime.now().toString()}",
    );
    if (result['isSuccess']) {
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Captura guardada!"),
          ),
        );
    } else {
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Error al guardar la captura..."),
          ),
        );
    }
  }

  _connect() async {
    String clientName =
        "cameraESP32App" + Random.secure().nextInt(1500).toString();
    if (clientName.trim().isNotEmpty) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 0,
        dialogTransitionType: DialogTransitionType.Shrink,
        dismissable: true,
        message: const Text("Progress message"),
        title: const Text("Progress title"),
      );
      progressDialog.setLoadingWidget(const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
      progressDialog.setMessage(const Text("Conectando a la cámara..."));
      progressDialog.setTitle(const Text("Conectando..."));
      progressDialog.show();

      setState(() {
        isConnecting = true;
      });
      isConnected = await mqttConnect(clientName.trim());
      setState(() {
        isConnected = isConnected;
      });
      progressDialog.dismiss();
      setState(() {
        isConnecting = false;
      });
    }
  }

  _disconnect(bool disposed) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.unsubscribe("esp32/test");
      client.disconnect();
    }
    if (!mounted || disposed) {
      return;
    }
    setState(() {
      isConnected = false;
      _currentImage = null;
    });
  }

  Future<bool> mqttConnect(String uniqueId) async {
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.port = port;
    client.secure = false;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    try {
      setState(() {
        isConnecting = true;
      });
      await client.connect();
    } catch (err) {}
    setState(() {
      isConnecting = false;
    });
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      return false;
    }

    const topic = 'esp32/test';
    client.subscribe(topic, MqttQos.atMostOnce);

    return true;
  }

  void onConnected() {
    setState(() {
      isConnected = true;
    });
  }

  void onDisconnected() {
    print("Disconnected");
    isConnected = false;
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}
