import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  late MqttServerClient client;
  final StreamController<String> _messageController =
      StreamController.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  bool _isSubscribed = false;
  Completer<bool> _connectCompleter = Completer<bool>();

  MqttService._internal();

  Future<bool> connect() async {
    if (_connectCompleter.isCompleted) {
      return _connectCompleter.future; // ถ้าเชื่อมต่อไปแล้ว ให้ return ทันที
    }

    final String clientId = 'client_${DateTime.now().millisecondsSinceEpoch}';
    final String mqttBroker = dotenv.env['MQTT_BROKER'] ?? 'test.mosquitto.org';
    final String mqttUsername = dotenv.env['MQTT_USERNAME'] ?? '';
    final String mqttPassword = dotenv.env['MQTT_PASSWORD'] ?? '';

    client = MqttServerClient.withPort(mqttBroker, clientId, 8883);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;

    try {
      await client.connect(mqttUsername, mqttPassword);
      log('MQTT connected');
      _subscribe();
      _connectCompleter.complete(true); // แจ้งว่าเชื่อมต่อสำเร็จ
    } catch (e) {
      log('MQTT connection error: $e');
      _connectCompleter.complete(false); // แจ้งว่าเชื่อมต่อไม่สำเร็จ
    }

    return _connectCompleter.future;
  }

  void _subscribe() {
    if (!_isSubscribed) {
      final String topic = dotenv.env['MQTT_ADMIN_TOPIC'] ?? 'admin_topic';
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        String message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        log('Received message: $message');

        _messageController.add(message);
      });

      _isSubscribed = true;
    }
  }

  void _onConnected() {
    log('MQTT connected successfully');
  }

  void _onDisconnected() {
    log('MQTT disconnected');
  }
}
