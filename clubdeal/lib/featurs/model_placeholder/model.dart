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

  const Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.items,
    required this.total,
    required this.status,
    required this.placedAt,
    this.note,
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
  const OrderItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.emoji,
  });
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      qty: map['qty'] ?? 1,
      price: (map['price'] ?? 0).toDouble(),
      emoji: map['emoji'] ?? '🍽️',
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

// ── Menu item model ───────────────────────────────────────────────────────────
class MenuItem {
  final int id;
  final String name;
  final String category;
  final double price;
  final String emoji;
  final String description;
  final String? badge;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.emoji,
    required this.description,
    this.badge,
    this.isAvailable = true,
  });
}

// ── Sample data ───────────────────────────────────────────────────────────────
final List<MenuItem> kMenuItems = [
  MenuItem(
    id: 1,
    name: 'Classic Loaded Fries',
    category: 'fries',
    price: 149,
    emoji: '🍟',
    description:
        'Crispy fries smothered in cheese sauce, jalapeños & sour cream.',
    badge: 'bestseller',
  ),
  MenuItem(
    id: 2,
    name: 'Masala Loaded Fries',
    category: 'fries',
    price: 139,
    emoji: '🍟',
    description:
        'Desi twist — chaat masala, green chutney & tangy tamarind drizzle.',
    badge: 'spicy',
  ),
  MenuItem(
    id: 3,
    name: 'BBQ Bacon Fries',
    category: 'fries',
    price: 179,
    emoji: '🍟',
    description: 'Smoky BBQ sauce, crispy bits & onion straws on golden fries.',
  ),
  MenuItem(
    id: 4,
    name: 'French Fries',
    category: 'fries',
    price: 89,
    emoji: '🍟',
    description:
        'Classic thin-cut golden fries. Simple, perfect, never gets old.',
  ),
  MenuItem(
    id: 5,
    name: 'Club Deal Burger',
    category: 'burger',
    price: 199,
    emoji: '🍔',
    description: 'Double patty, special sauce, caramelised onions & cheddar.',
    badge: 'bestseller',
  ),
  MenuItem(
    id: 6,
    name: 'Spicy Chicken Burger',
    category: 'burger',
    price: 179,
    emoji: '🍔',
    description: 'Crispy fried chicken, sriracha mayo & pickled jalapeños.',
    badge: 'spicy',
  ),
  MenuItem(
    id: 7,
    name: 'Veggie Crunch Burger',
    category: 'burger',
    price: 149,
    emoji: '🍔',
    description:
        'Crispy veggie patty, coleslaw, mustard aioli & fresh lettuce.',
    badge: 'new',
  ),
  MenuItem(
    id: 8,
    name: 'Chicken Tikka Wrap',
    category: 'wrap',
    price: 159,
    emoji: '🌯',
    description: 'Flame-kissed tikka chicken, mint chutney & crunchy onions.',
    badge: 'bestseller',
  ),
  MenuItem(
    id: 9,
    name: 'Shawarma Style Wrap',
    category: 'wrap',
    price: 169,
    emoji: '🌯',
    description:
        'Tender marinated chicken, garlic sauce, pickles & fries wrapped tight.',
  ),
  MenuItem(
    id: 10,
    name: 'Paneer Tikka Wrap',
    category: 'wrap',
    price: 149,
    emoji: '🌯',
    description:
        'Smoky paneer, tangy chutney & crispy veggies in a grilled flatbread.',
    badge: 'new',
  ),
  MenuItem(
    id: 11,
    name: 'Cold Coffee',
    category: 'drinks',
    price: 79,
    emoji: '☕',
    description: 'Thick, rich blended cold coffee. The perfect companion.',
  ),
  MenuItem(
    id: 12,
    name: 'Mango Fizz',
    category: 'drinks',
    price: 69,
    emoji: '🥭',
    description:
        'Fresh mango pulp with sparkling water & a pinch of chaat masala.',
    badge: 'new',
  ),
];

final List<Order> kSampleOrders = [
  Order(
    id: '#1042',
    customerName: 'Arjun Sharma',
    phone: '+91 98765 43210',
    total: 348,
    status: OrderStatus.preparing,
    placedAt: DateTime.now().subtract(const Duration(minutes: 4)),
    items: [
      const OrderItem(
        name: 'Club Deal Burger',
        qty: 1,
        price: 199,
        emoji: '🍔',
      ),
      const OrderItem(
        name: 'Classic Loaded Fries',
        qty: 1,
        price: 149,
        emoji: '🍟',
      ),
    ],
  ),
  Order(
    id: '#1041',
    customerName: 'Priya Menon',
    phone: '+91 87654 32109',
    total: 317,
    status: OrderStatus.pending,
    placedAt: DateTime.now().subtract(const Duration(minutes: 7)),
    items: [
      const OrderItem(
        name: 'Chicken Tikka Wrap',
        qty: 1,
        price: 159,
        emoji: '🌯',
      ),
      const OrderItem(name: 'Mango Fizz', qty: 1, price: 69, emoji: '🥭'),
      const OrderItem(name: 'French Fries', qty: 1, price: 89, emoji: '🍟'),
    ],
  ),
  Order(
    id: '#1040',
    customerName: 'Rahul Nair',
    phone: '+91 76543 21098',
    total: 179,
    status: OrderStatus.ready,
    placedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    items: [
      const OrderItem(
        name: 'Spicy Chicken Burger',
        qty: 1,
        price: 179,
        emoji: '🍔',
      ),
    ],
  ),
  Order(
    id: '#1039',
    customerName: 'Sneha Pillai',
    phone: '+91 65432 10987',
    total: 427,
    status: OrderStatus.delivered,
    placedAt: DateTime.now().subtract(const Duration(minutes: 25)),
    items: [
      const OrderItem(
        name: 'Shawarma Style Wrap',
        qty: 2,
        price: 169,
        emoji: '🌯',
      ),
      const OrderItem(name: 'Cold Coffee', qty: 1, price: 79, emoji: '☕'),
    ],
  ),
  Order(
    id: '#1038',
    customerName: 'Kiran Raj',
    phone: '+91 54321 09876',
    total: 288,
    status: OrderStatus.delivered,
    placedAt: DateTime.now().subtract(const Duration(minutes: 38)),
    items: [
      const OrderItem(name: 'BBQ Bacon Fries', qty: 1, price: 179, emoji: '🍟'),
      const OrderItem(name: 'Mango Fizz', qty: 1, price: 69, emoji: '🥭'),
      const OrderItem(name: 'Cold Coffee', qty: 1, price: 79, emoji: '☕'),
    ],
  ),
  Order(
    id: '#1037',
    customerName: 'Aisha Khan',
    phone: '+91 43210 98765',
    total: 149,
    status: OrderStatus.cancelled,
    placedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    items: [
      const OrderItem(
        name: 'Masala Loaded Fries',
        qty: 1,
        price: 139,
        emoji: '🍟',
      ),
      const OrderItem(name: 'Cold Coffee', qty: 1, price: 79, emoji: '☕'),
    ],
  ),
  Order(
    id: '#1036',
    customerName: 'Dev Krishnan',
    phone: '+91 32109 87654',
    total: 496,
    status: OrderStatus.delivered,
    placedAt: DateTime.now().subtract(const Duration(hours: 1)),
    items: [
      const OrderItem(
        name: 'Club Deal Burger',
        qty: 2,
        price: 199,
        emoji: '🍔',
      ),
      const OrderItem(name: 'BBQ Bacon Fries', qty: 1, price: 179, emoji: '🍟'),
    ],
  ),
  Order(
    id: '#1035',
    customerName: 'Meera Thomas',
    phone: '+91 21098 76543',
    total: 258,
    status: OrderStatus.delivered,
    placedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
    items: [
      const OrderItem(
        name: 'Paneer Tikka Wrap',
        qty: 1,
        price: 149,
        emoji: '🌯',
      ),
      const OrderItem(
        name: 'Veggie Crunch Burger',
        qty: 1,
        price: 149,
        emoji: '🍔',
      ),
    ],
  ),
];

// Sales data for charts (last 7 days)
final List<double> kDailySales = [3200, 4100, 2800, 5600, 4900, 6200, 5100];
final List<String> kDayLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

// Category breakdown
final Map<String, int> kCategoryOrders = {
  'Fries': 38,
  'Burgers': 45,
  'Wraps': 29,
  'Drinks': 18,
};
