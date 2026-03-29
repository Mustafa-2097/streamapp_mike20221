import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../offline_storage/shared_pref.dart';
import 'api_endpoints.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  final isConnected = false.obs;

  Future<SocketService> init() async {
    await _initializeSocket();
    return this;
  }

  Future<void> _initializeSocket() async {
    final String? token = await SharedPreferencesHelper.getToken();

    // The baseUrl is http://10.0.30.59:8000/api/v1
    // We want the root: http://10.0.30.59:8000
    final String socketUrl = ApiEndpoints.baseUrl.split('/api/').first;

    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {if (token != null) 'Authorization': 'Bearer $token'},
    });

    socket.onConnect((_) async {
      debugPrint('Socket connected to $socketUrl');
      isConnected.value = true;
      
      // Auto-join user room after connection
      final String? userId = await SharedPreferencesHelper.getUserId();
      if (userId != null) {
        joinUserRoom(userId);
      }
    });

    socket.onDisconnect((_) {
      debugPrint('Socket disconnected');
      isConnected.value = false;
    });

    socket.onConnectError((err) {
      debugPrint('Socket connection error: $err');
    });

    socket.connect();
  }

  void joinRoom(String roomId) {
    if (socket.connected) {
      socket.emit("join_room", roomId);
      debugPrint('Joined room: $roomId');
    } else {
      socket.once('connect', (_) {
        socket.emit("join_room", roomId);
        debugPrint('Joined room (after delayed connect): $roomId');
      });
    }
  }

  void joinUserRoom(String userId) {
    if (socket.connected) {
      socket.emit("join_user_room", userId);
      debugPrint('Joined user room: $userId');
    } else {
      socket.once('connect', (_) {
        socket.emit("join_user_room", userId);
        debugPrint('Joined user room (after delayed connect): $userId');
      });
    }
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void off(String event) {
    socket.off(event);
  }
}
