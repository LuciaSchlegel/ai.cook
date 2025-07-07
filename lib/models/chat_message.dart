enum MessageType { user, bot }

class ChatMessage {
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.type,
    DateTime? timestamp,
    this.isLoading = false,
  }) : timestamp = timestamp ?? DateTime.now();
}
