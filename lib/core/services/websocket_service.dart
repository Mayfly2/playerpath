import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../storage/secure_storage.dart';

class WebSocketService {
  io.Socket? _socket;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  Stream<Map<String, dynamic>> get typingUpdates => _typingController.stream;
  Stream<bool> get connectionStatus => _connectionController.stream;
  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    final token = await SecureStorage.getAccessToken();
    if (token == null) return;

    _socket = io.io(
      'http://localhost:3000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .setPath('/socket.io')
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..connect()
      ..onConnect((_) {
        _connectionController.add(true);
        // Register user on the messaging namespace
        _socket!.emit('auth:register', {'userId': 'current'});
      })
      ..onDisconnect((_) => _connectionController.add(false))
      ..onConnectError((err) => _connectionController.add(false))
      ..on('message:new', (data) => _messageController.add(data as Map<String, dynamic>))
      ..on('typing:update', (data) => _typingController.add(data as Map<String, dynamic>));
  }

  void joinConversation(String conversationId) {
    _socket?.emit('conversation:join', {'conversationId': conversationId});
  }

  void leaveConversation(String conversationId) {
    _socket?.emit('conversation:leave', {'conversationId': conversationId});
  }

  void sendMessage(String conversationId, String content, {String type = 'text'}) {
    _socket?.emit('message:send', {
      'conversationId': conversationId,
      'content': content,
      'type': type,
    });
  }

  void startTyping(String conversationId, String userId) {
    _socket?.emit('typing:start', {'conversationId': conversationId, 'userId': userId});
  }

  void stopTyping(String conversationId, String userId) {
    _socket?.emit('typing:stop', {'conversationId': conversationId, 'userId': userId});
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
    _connectionController.close();
    disconnect();
  }
}
