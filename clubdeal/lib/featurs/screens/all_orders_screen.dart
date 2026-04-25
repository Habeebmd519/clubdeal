import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clubdeal/core/data_stream.dart';
import 'package:clubdeal/featurs/model_placeholder/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

// ── App Colors ─────────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFF111111);
  static const surface = Color(0xFF1C1C1C);
  static const surfaceHi = Color(0xFF242424);
  static const border = Color(0xFF2E2E2E);
  static const borderHi = Color(0xFF3D3D3D);
  static const cream = Color(0xFFF2EDE4);
  static const amber = Color(0xFFE8A020);
  static const amberDim = Color(0xFF7A5210);
  static const green = Color(0xFF3DBD7D);
  static const greenDim = Color(0xFF1A4D34);
  static const red = Color(0xFFD94F4F);
  static const redDim = Color(0xFF5C1F1F);
  static const muted = Color(0xFF6B6B6B);
}

// ── Screen ─────────────────────────────────────────────────────────────────────
class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _filter = 'All';
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Filtering ──────────────────────────────────────────────────────────────
  List<Order> _filterOrders(List<Order> orders) {
    var list = orders;

    if (_filter == 'Active') {
      list = list
          .where(
            (o) =>
                o.status == OrderStatus.pending ||
                o.status == OrderStatus.preparing,
          )
          .toList();
    } else if (_filter == 'Completed') {
      list = list.where((o) => o.status == OrderStatus.delivered).toList();
    }

    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where(
            (o) =>
                o.id.toLowerCase().contains(q) ||
                o.customerName.toLowerCase().contains(q),
          )
          .toList();
    }

    list.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return list;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: StreamBuilder<List<Order>>(
          stream: OrderServices().getOrders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: _C.amber,
                  strokeWidth: 1.5,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(color: _C.muted, fontSize: 13),
                ),
              );
            }

            final orders = snapshot.data!;
            final filtered = _filterOrders(orders);

            final pendingCount = orders
                .where(
                  (o) =>
                      o.status == OrderStatus.pending ||
                      o.status == OrderStatus.preparing,
                )
                .length;
            final completedCount = orders
                .where((o) => o.status == OrderStatus.delivered)
                .length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(totalCount: orders.length, pendingCount: pendingCount),
                _SearchBar(
                  controller: _searchCtrl,
                  query: _query,
                  onChanged: (v) => setState(() => _query = v),
                  onClear: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                ),
                _FilterChips(
                  selected: _filter,
                  allCount: orders.length,
                  activeCount: pendingCount,
                  completedCount: completedCount,
                  onSelect: (f) {
                    HapticFeedback.selectionClick();
                    setState(() => _filter = f);
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? _EmptyState(query: _query)
                      : RefreshIndicator(
                          onRefresh: () async => await Future.delayed(
                            const Duration(milliseconds: 600),
                          ),
                          color: _C.amber,
                          backgroundColor: _C.surface,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) => _OrderRow(
                              key: ValueKey(filtered[i].id),
                              order: filtered[i],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final int totalCount;
  final int pendingCount;
  const _Header({required this.totalCount, required this.pendingCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDERS',
                style: GoogleFonts.bebasNeue(
                  fontSize: 36,
                  color: _C.cream,
                  letterSpacing: 2,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$totalCount total',
                style: TextStyle(fontSize: 12, color: _C.muted),
              ),
            ],
          ),
          const Spacer(),
          if (pendingCount > 0) _PulseBadge(count: pendingCount),
        ],
      ),
    );
  }
}

// ── Pulse Badge ────────────────────────────────────────────────────────────────
class _PulseBadge extends StatefulWidget {
  final int count;
  const _PulseBadge({required this.count});

  @override
  State<_PulseBadge> createState() => _PulseBadgeState();
}

class _PulseBadgeState extends State<_PulseBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color.lerp(_C.redDim, const Color(0xFF6B2020), _anim.value),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _C.red.withOpacity(0.25 + _anim.value * 0.25),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _C.red.withOpacity(0.6 + _anim.value * 0.4),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '${widget.count} LIVE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _C.red.withOpacity(0.75 + _anim.value * 0.25),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search Bar ─────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.border, width: 0.5),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(color: _C.cream, fontSize: 14),
          cursorColor: _C.amber,
          decoration: InputDecoration(
            hintText: 'Search by name or order ID…',
            hintStyle: TextStyle(color: _C.muted, fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: _C.muted, size: 18),
            suffixIcon: query.isNotEmpty
                ? GestureDetector(
                    onTap: onClear,
                    child: Icon(Icons.close_rounded, color: _C.muted, size: 16),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}

// ── Filter Chips ───────────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  final String selected;
  final int allCount;
  final int activeCount;
  final int completedCount;
  final ValueChanged<String> onSelect;

  const _FilterChips({
    required this.selected,
    required this.allCount,
    required this.activeCount,
    required this.completedCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      ('All', allCount),
      ('Active', activeCount),
      ('Completed', completedCount),
    ];

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: chips.map((chip) {
          final isSelected = selected == chip.$1;
          return GestureDetector(
            onTap: () => onSelect(chip.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? _C.amber : _C.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _C.amber : _C.border,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    chip.$1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? _C.bg : _C.cream.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withOpacity(0.18)
                          : _C.surfaceHi,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${chip.$2}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? _C.bg : _C.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            query.isNotEmpty ? '🔍' : '🍽️',
            style: const TextStyle(fontSize: 44),
          ),
          const SizedBox(height: 14),
          Text(
            query.isNotEmpty ? 'No results found' : 'No orders yet',
            style: GoogleFonts.bebasNeue(
              fontSize: 22,
              color: _C.muted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            query.isNotEmpty
                ? 'Try a different name or ID'
                : 'New orders will appear here',
            style: TextStyle(fontSize: 12, color: _C.muted.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ───────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, dimColor) = switch (status) {
      OrderStatus.pending => ('PENDING', _C.amber, _C.amberDim),
      OrderStatus.preparing => ('PREPARING', _C.amber, _C.amberDim),
      OrderStatus.delivered => ('DONE', _C.green, _C.greenDim),
      _ => ('UNKNOWN', _C.muted, _C.surface),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: dimColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: color,
        ),
      ),
    );
  }
}

// ── Order Row ──────────────────────────────────────────────────────────────────
class _OrderRow extends StatefulWidget {
  final Order order;
  const _OrderRow({super.key, required this.order});

  @override
  State<_OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<_OrderRow>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  Future<void> _markDelivered() async {
    HapticFeedback.mediumImpact();

    try {
      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .update({'status': 'delivered'});

      debugPrint('✅ Order updated: ${widget.order.id}');
    } on firestore.FirebaseException catch (e) {
      debugPrint('🔥 Firestore error: ${e.code} - ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('❌ Unknown error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteOrder() async {
    HapticFeedback.heavyImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _C.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Delete order?',
          style: TextStyle(
            color: _C.cream,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '${widget.order.id} will be permanently removed.',
          style: TextStyle(color: _C.muted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: _C.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: _C.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final isDelivered = order.status == OrderStatus.delivered;
    final totalItems = order.items.fold(0, (s, i) => s + i.qty);
    final ago = _timeAgo(order.placedAt);

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _expanded ? _C.surfaceHi : _C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expanded ? _C.borderHi : _C.border,
            width: _expanded ? 0.8 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Collapsed header ────────────────────────────────────────
            Row(
              children: [
                // Emoji bubble
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _C.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.border, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      order.items.first.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            order.id,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 15,
                              color: _C.cream,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.customerName,
                              style: TextStyle(
                                fontSize: 12,
                                color: _C.cream.withOpacity(0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$totalItems item${totalItems > 1 ? 's' : ''} · $ago',
                        style: TextStyle(fontSize: 11, color: _C.muted),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${order.total.toStringAsFixed(0)}',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                        color: _C.cream,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(width: 6),

                // Chevron
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOutCubic,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _C.muted,
                    size: 18,
                  ),
                ),
              ],
            ),

            // ── Expanded section ────────────────────────────────────────
            SizeTransition(
              sizeFactor: _expandAnim,
              axisAlignment: -1,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Divider(color: _C.border, thickness: 0.5, height: 0),
                    const SizedBox(height: 12),

                    // Item list
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: Row(
                          children: [
                            Text(
                              item.emoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _C.cream.withOpacity(0.8),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _C.bg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _C.border,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                '×${item.qty}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _C.muted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '₹${(item.price * item.qty).toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: _C.cream.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    Divider(color: _C.border, thickness: 0.5, height: 0),
                    const SizedBox(height: 10),

                    // Total row
                    Row(
                      children: [
                        Text(
                          'ORDER TOTAL',
                          style: TextStyle(
                            fontSize: 10,
                            color: _C.muted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${order.total.toStringAsFixed(0)}',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 22,
                            color: _C.cream,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Action buttons ─────────────────────────────────
                    Row(
                      children: [
                        if (!isDelivered)
                          Expanded(
                            child: _ActionBtn(
                              label: 'Mark Delivered',
                              icon: Icons.check_circle_outline_rounded,
                              color: _C.green,
                              dim: _C.greenDim,
                              onTap: _markDelivered,
                            ),
                          ),
                        if (isDelivered) ...[
                          Expanded(
                            child: _ActionBtn(
                              label: 'Delete Order',
                              icon: Icons.delete_outline_rounded,
                              color: _C.red,
                              dim: _C.redDim,
                              onTap: _deleteOrder,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inSeconds < 60) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

// ── Action Button ──────────────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color dim;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.dim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: dim,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
