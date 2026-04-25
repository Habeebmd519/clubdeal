import 'package:clubdeal/featurs/model_placeholder/model.dart';
import 'package:clubdeal/featurs/screens/all_orders_screen.dart';
import 'package:clubdeal/featurs/screens/order_screen.dart';
import 'package:clubdeal/featurs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import '../theme.dart';
// import '../models/models.dart';
import '../widgets/widgets.dart';

class DashboardScreen extends StatelessWidget {
  final List<Order> orders;
  const DashboardScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final todayRevenue = orders
        .where((o) => o.status != OrderStatus.cancelled)
        .fold<double>(0, (s, o) => s + o.total);
    final activeOrders = orders
        .where(
          (o) =>
              o.status == OrderStatus.preparing ||
              o.status == OrderStatus.pending,
        )
        .length;
    final completedToday = orders
        .where((o) => o.status == OrderStatus.delivered)
        .length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B1F17), Color(0xFF0F2920)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Greeting ──────────────────────────────────────────────────────
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Good ${_greeting()}! 👋',
                    //           style: TextStyle(
                    //             color: AppColors.cream.withOpacity(0.5),
                    //             fontSize: 13,
                    //           ),
                    //         ),
                    //         const SizedBox(height: 4),
                    //         Text(
                    //           "Today's Overview",
                    //           style: GoogleFonts.bebasNeue(
                    //             fontSize: 30,
                    //             color: AppColors.cream,
                    //             letterSpacing: 1.5,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 14,
                    //         vertical: 8,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: AppColors.greenMid.withOpacity(0.2),
                    //         border: Border.all(
                    //           color: AppColors.greenMid.withOpacity(0.4),
                    //         ),
                    //         borderRadius: BorderRadius.circular(30),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           const Icon(
                    //             Icons.calendar_today_rounded,
                    //             size: 14,
                    //             color: AppColors.greenLight,
                    //           ),
                    //           const SizedBox(width: 6),
                    //           Text(
                    //             DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                    //             style: const TextStyle(
                    //               color: AppColors.cream,
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_greeting()}! 👋',
                              style: TextStyle(
                                color: AppColors.cream.withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Today's Overview",
                              style: GoogleFonts.bebasNeue(
                                fontSize:
                                    MediaQuery.of(context).size.width > 700
                                    ? 36
                                    : 30,
                                color: AppColors.cream,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenMid.withOpacity(0.2),
                            border: Border.all(
                              color: AppColors.greenMid.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: AppColors.greenLight,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat(
                                  'EEE, d MMM yyyy',
                                ).format(DateTime.now()),
                                style: const TextStyle(
                                  color: AppColors.cream,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ── Stat Cards ────────────────────────────────────────────────────
                    LayoutBuilder(
                      builder: (ctx, c) {
                        final validOrders = orders
                            .where((o) => o.status != OrderStatus.cancelled)
                            .toList();

                        final width = c.maxWidth;

                        final cols = width > 1100
                            ? 4 // large tablet / desktop
                            : width > 700
                            ? 3 // tablet
                            : width > 500
                            ? 2
                            : 1;
                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: width > 700 ? 1.2 : 1.45,
                          children: [
                            StatCard(
                              title: "Today's Revenue",
                              value: '₹${todayRevenue.toStringAsFixed(0)}',
                              subtitle: 'vs ₹4,200 yesterday',
                              icon: Icons.currency_rupee_rounded,
                              iconColor: AppColors.cream,
                              trend: '21%',
                              trendUp: true,
                            ),
                            StatCard(
                              title: 'Active Orders',
                              value: '$activeOrders',
                              subtitle: '$completedToday completed today',
                              icon: Icons.receipt_long_rounded,
                              iconColor: AppColors.info,
                              trend: '3',
                              trendUp: true,
                            ),
                            StatCard(
                              title: 'Total Orders',
                              value: '${orders.length}',
                              subtitle: 'since opening today',
                              icon: Icons.local_fire_department_rounded,
                              iconColor: AppColors.warning,
                              trend: '12%',
                              trendUp: true,
                            ),
                            StatCard(
                              title: 'Avg Order Value',
                              value: validOrders.isEmpty
                                  ? '₹0'
                                  : '₹${(todayRevenue / validOrders.length).toStringAsFixed(0)}',
                              subtitle: 'per customer',
                              icon: Icons.person_rounded,
                              iconColor: AppColors.greenLight,
                              trend: '5%',
                              trendUp: false,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Charts Row ────────────────────────────────────────────────────
                    LayoutBuilder(
                      builder: (ctx, c) {
                        if (c.maxWidth > 900) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _WeeklyChart()),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _CategoryPieChart()),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            _WeeklyChart(),
                            const SizedBox(height: 16),
                            _CategoryPieChart(),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Recent Orders ─────────────────────────────────────────────────
                    SectionHeader(
                      title: 'RECENT ORDERS',
                      action: 'View all →',
                      onAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllOrdersScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ...orders.take(5).map((o) => _OrderRow(order: o)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }
}

// ── Weekly Sales Bar Chart ────────────────────────────────────────────────────
class _WeeklyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 700 ? 32 : 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.charcoalMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY SALES',
            style: GoogleFonts.bebasNeue(
              fontSize: 18,
              color: AppColors.cream,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'Last 7 days revenue',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.cream.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2000,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.border, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        kDayLabels[v.toInt()],
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.cream.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                barGroups: kDailySales.asMap().entries.map((e) {
                  final isToday = e.key == 6;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        color: isToday
                            ? AppColors.greenLight
                            : AppColors.greenMid.withOpacity(0.6),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category Pie Chart ────────────────────────────────────────────────────────
class _CategoryPieChart extends StatefulWidget {
  @override
  State<_CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<_CategoryPieChart> {
  int _touched = -1;

  static const _colors = [
    AppColors.greenLight,
    AppColors.cream,
    AppColors.info,
    AppColors.warning,
  ];

  @override
  Widget build(BuildContext context) {
    final entries = kCategoryOrders.entries.toList();
    final total = entries.fold<int>(0, (s, e) => s + e.value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoalMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BY CATEGORY',
            style: GoogleFonts.bebasNeue(
              fontSize: 18,
              color: AppColors.cream,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'Order share',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.cream.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (_, r) => setState(() {
                    _touched = r?.touchedSection?.touchedSectionIndex ?? -1;
                  }),
                ),
                sectionsSpace: 3,
                centerSpaceRadius: 36,
                sections: entries.asMap().entries.map((e) {
                  final isTouched = e.key == _touched;
                  return PieChartSectionData(
                    value: e.value.value.toDouble(),
                    color: _colors[e.key % _colors.length],
                    radius: isTouched ? 42 : 34,
                    title: '',
                    showTitle: false,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...entries.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _colors[e.key % _colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    e.value.key,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.cream,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${e.value.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cream,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${(e.value.value / total * 100).round()}%)',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.cream.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expandable Order Row ───────────────────────────────────────────────────────
class _OrderRow extends StatefulWidget {
  final Order order;
  const _OrderRow({required this.order});

  @override
  State<_OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<_OrderRow>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final ago = _timeAgo(widget.order.placedAt);
    int totalItems = widget.order.items.fold(0, (sum, item) => sum + item.qty);

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _expanded
              ? AppColors.charcoalMid.withOpacity(0.95)
              : AppColors.charcoalMid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? AppColors.cream.withOpacity(0.15)
                : AppColors.border,
            width: _expanded ? 1.0 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Collapsed header (always visible) ─────────────────────────
            Row(
              children: [
                Text(
                  widget.order.items.first.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.order.id,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 16,
                              color: AppColors.cream,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '· ${widget.order.customerName}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.cream.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$totalItems item${totalItems > 1 ? 's' : ''} · $ago',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.cream.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${widget.order.total.toStringAsFixed(0)}',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                        color: AppColors.cream,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(status: widget.order.status),
                  ],
                ),
                const SizedBox(width: 8),
                // Chevron indicator
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.cream.withOpacity(0.4),
                    size: 18,
                  ),
                ),
              ],
            ),

            // ── Expanded detail section ────────────────────────────────────
            SizeTransition(
              sizeFactor: _expandAnim,
              axisAlignment: -1,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Divider(
                      color: AppColors.cream.withOpacity(0.08),
                      thickness: 0.5,
                      height: 0,
                    ),
                    const SizedBox(height: 12),

                    // ── Item list ──────────────────────────────────────────
                    ...widget.order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
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
                                  color: AppColors.cream.withOpacity(0.85),
                                ),
                              ),
                            ),
                            if (item.qty > 1)
                              Text(
                                '×${item.qty}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.cream.withOpacity(0.4),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Text(
                              '₹${item.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.cream.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                    Divider(
                      color: AppColors.cream.withOpacity(0.08),
                      thickness: 0.5,
                      height: 0,
                    ),
                    const SizedBox(height: 10),

                    // ── Footer: address + total ────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deliver to',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.cream.withOpacity(0.35),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Text(
                              //   widget.order.deliveryAddress,
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     color: AppColors.cream.withOpacity(0.6),
                              //   ),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.cream.withOpacity(0.35),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '₹${widget.order.total.toStringAsFixed(0)}',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 22,
                                color: AppColors.cream,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
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
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    return '${d.inHours}h ago';
  }
}
