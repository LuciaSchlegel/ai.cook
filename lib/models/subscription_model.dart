enum SubscriptionType { free, premium, pro }

class Subscription {
  final int id;
  final int userId;
  final SubscriptionType type;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
