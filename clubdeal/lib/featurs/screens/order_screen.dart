import 'package:clubdeal/featurs/model_placeholder/model.dart';
import 'package:clubdeal/featurs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import '../theme.dart';
// import '../models/models.dart';
import '../widgets/widgets.dart';

class OrdersScreen extends StatefulWidget {
  final List<Order> orders;
  final void Function(String id, OrderStatus status) onUpdateStatus;

  const OrdersScreen({
    super.key,
    required this.orders,
    required this.onUpdateStatus,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderStatus? _filter;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.orders.where((o) {
      final matchStatus = _filter == null || o.status == _filter;
      final matchSearch =
          _search.isEmpty ||
          o.customerName.toLowerCase().contains(_search.toLowerCase()) ||
          o.id.contains(_search);
      return matchStatus && matchSearch;
    }).toList();

    return Column(
      children: [
        // ── Header ────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDERS',
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                  color: AppColors.cream,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'Manage and track all orders',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.cream.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              // Search bar
              TextField(
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(color: AppColors.cream, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search by name or order ID…',
                  hintStyle: TextStyle(
                    color: AppColors.cream.withOpacity(0.3),
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.cream.withOpacity(0.4),
                    size: 18,
                  ),
                  filled: true,
                  fillColor: AppColors.charcoalMid,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greenLight,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _filter == null,
                      onTap: () => setState(() => _filter = null),
                    ),
                    ...OrderStatus.values.map(
                      (s) => _FilterChip(
                        label: s.label,
                        selected: _filter == s,
                        onTap: () =>
                            setState(() => _filter = _filter == s ? null : s),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // ── Order List ────────────────────────────────────────────────────
        Expanded(
          child: filtered.isEmpty
              ? const EmptyState(
                  emoji: '📋',
                  message: 'No orders match your filter',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _OrderCard(
                    order: filtered[i],
                    onUpdateStatus: widget.onUpdateStatus,
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenMid : AppColors.charcoalMid,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.greenMid : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? AppColors.cream
                : AppColors.cream.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

// ── Order Card ────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final Order order;
  final void Function(String, OrderStatus) onUpdateStatus;
  const _OrderCard({required this.order, required this.onUpdateStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoalMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Text(
                order.id,
                style: GoogleFonts.bebasNeue(
                  fontSize: 20,
                  color: AppColors.cream,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 10),
              StatusBadge(status: order.status),
              const Spacer(),
              Text(
                DateFormat('h:mm a').format(order.placedAt),
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.cream.withOpacity(0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Customer info
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 13,
                color: AppColors.cream.withOpacity(0.4),
              ),
              const SizedBox(width: 4),
              Text(
                order.customerName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.phone_outlined,
                size: 13,
                color: AppColors.cream.withOpacity(0.4),
              ),
              const SizedBox(width: 4),
              Text(
                order.phone,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.cream.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Items
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: order.items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenDeep.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Text(
                      '${item.emoji} ${item.name} ×${item.qty}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.cream,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          if (order.note != null && order.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.sticky_note_2_outlined,
                  size: 13,
                  color: AppColors.warning.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.note!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.warning.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              Text(
                '₹${order.total.toStringAsFixed(0)}',
                style: GoogleFonts.bebasNeue(
                  fontSize: 22,
                  color: AppColors.cream,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              _ActionButtons(order: order, onUpdate: onUpdateStatus),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Action Buttons ────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final Order order;
  final void Function(String, OrderStatus) onUpdate;
  const _ActionButtons({required this.order, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return switch (order.status) {
      OrderStatus.pending => Row(
        children: [
          _Btn(
            label: '✓ Accept',
            color: AppColors.success,
            onTap: () => onUpdate(order.id, OrderStatus.preparing),
          ),
          const SizedBox(width: 8),
          _Btn(
            label: '✕ Cancel',
            color: AppColors.error,
            onTap: () => onUpdate(order.id, OrderStatus.cancelled),
          ),
        ],
      ),
      OrderStatus.preparing => _Btn(
        label: '🔔 Mark Ready',
        color: AppColors.info,
        onTap: () => onUpdate(order.id, OrderStatus.ready),
      ),
      OrderStatus.ready => _Btn(
        label: '✓ Delivered',
        color: AppColors.greenLight,
        onTap: () => onUpdate(order.id, OrderStatus.delivered),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4), width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
