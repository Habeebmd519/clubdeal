// ── Order model ──────────────────────────────────────────────────────────────
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Order {
  final String id;
  final String customerName;
  final String phone;
  final List<OrderItem> items;
  final double total;
  final OrderStatus status;
  final DateTime placedAt;
  final String? note;
  final String? category;

  const Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.items,
    required this.total,
    required this.status,
    required this.placedAt,
    this.note,
    this.category,
  });

  Order copyWith({OrderStatus? status}) => Order(
    id: id,
    customerName: customerName,
    phone: phone,
    items: items,
    total: total,
    status: status ?? this.status,
    placedAt: placedAt,
    note: note,
  );
  factory Order.fromFirestore(firestore.DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Order(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      phone: data['phone'] ?? '',
      total: (data['total'] ?? 0).toDouble(),
      status: _parseStatus(data['status']),
      placedAt: (data['createdAt'] as firestore.Timestamp).toDate(),
      note: data['note'],
      items: (data['items'] as List).map((i) => OrderItem.fromMap(i)).toList(),
    );
  }
}

OrderStatus _parseStatus(String? s) {
  switch (s) {
    case 'pending':
      return OrderStatus.pending;
    case 'preparing':
      return OrderStatus.preparing;
    case 'ready':
      return OrderStatus.ready;
    case 'delivered':
      return OrderStatus.delivered;
    case 'cancelled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.pending;
  }
}

class OrderItem {
  final String name;
  final int qty;
  final double price;
  final String emoji;
  final String category; // ✅ REQUIRED

  OrderItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.emoji,
    required this.category,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      qty: map['qty'] ?? 1,
      price: (map['price'] ?? 0).toDouble(),
      emoji: map['emoji'] ?? '🍽️',
      category: map['cat'] ?? 'Other', // ✅ IMPORTANT
    );
  }
}

enum OrderStatus { pending, preparing, ready, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.preparing => 'Preparing',
    OrderStatus.ready => 'Ready',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Cancelled',
  };
}
