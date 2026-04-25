import 'package:clubdeal/featurs/model_placeholder/model.dart';
import 'package:clubdeal/featurs/screens/all_orders_screen.dart';
import 'package:clubdeal/featurs/screens/order_screen.dart';
import 'package:clubdeal/featurs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
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
                              Expanded(
                                flex: 3,
                                child: WeeklyChart(orders: orders),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: CategoryPieChart(orders: orders),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            WeeklyChart(orders: orders),
                            const SizedBox(height: 16),
                            CategoryPieChart(orders: orders),
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

// ── Weekly Sales Bar Chart ───────
// ── Weekly Chart ───────────────────────────────────────────────────────────────
// Dependencies: fl_chart, google_fonts
// Pass your orders list from the stream directly — no extra data needed.

enum _ChartMode { revenue, count }

class WeeklyChart extends StatefulWidget {
  final List<Order> orders;
  const WeeklyChart({super.key, required this.orders});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart>
    with SingleTickerProviderStateMixin {
  _ChartMode _mode = _ChartMode.revenue;
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;
  int? _touchedIndex;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1,
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Data computation ───────────────────────────────────────────────────────
  // Groups orders into the last 7 days (index 0 = 6 days ago, index 6 = today)
  List<({double revenue, int count})> get _dailyData {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final dayOrders = widget.orders.where((o) {
        final d = DateTime(o.placedAt.year, o.placedAt.month, o.placedAt.day);
        return d == day;
      });
      return (
        revenue: dayOrders.fold(0.0, (s, o) => s + o.total),
        count: dayOrders.length,
      );
    });
  }

  List<String> get _dayLabels {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      if (day == today) return 'Today';
      return _days[day.weekday - 1];
    });
  }

  double get _maxY {
    final data = _dailyData;
    final vals = _mode == _ChartMode.revenue
        ? data.map((d) => d.revenue)
        : data.map((d) => d.count.toDouble());
    final max = vals.fold(0.0, (a, b) => b > a ? b : a);
    if (max == 0) return 10;
    return (max * 1.3).ceilToDouble();
  }

  // ── Summary stats ──────────────────────────────────────────────────────────
  double get _weekTotal => _dailyData.fold(0.0, (s, d) => s + d.revenue);

  int get _weekOrderCount => _dailyData.fold(0, (s, d) => s + d.count);

  double get _todayRevenue => _dailyData.last.revenue;

  // ── Mode toggle with fade ──────────────────────────────────────────────────
  void _toggleMode(_ChartMode m) async {
    if (m == _mode) return;
    HapticFeedback.selectionClick();
    await _fadeCtrl.reverse();
    setState(() {
      _mode = m;
      _touchedIndex = null;
    });
    _fadeCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final data = _dailyData;
    final labels = _dayLabels;
    final maxY = _maxY;

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
          // ── Header ─────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                    'Last 7 days',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.cream.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _ModeToggle(mode: _mode, onChanged: _toggleMode),
            ],
          ),

          const SizedBox(height: 16),

          // ── Summary pills ──────────────────────────────────────────────
          Row(
            children: [
              _StatPill(
                label: 'Week Total',
                value: '₹${_formatNum(_weekTotal)}',
                color: AppColors.greenLight,
              ),
              const SizedBox(width: 8),
              _StatPill(
                label: 'Orders',
                value: '$_weekOrderCount',
                color: AppColors.cream.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              _StatPill(
                label: 'Today',
                value: '₹${_formatNum(_todayRevenue)}',
                color: AppColors.gold,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Tooltip for touched bar ────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _touchedIndex != null
                ? Padding(
                    key: ValueKey(_touchedIndex),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BarTooltip(
                      label: labels[_touchedIndex!],
                      revenue: data[_touchedIndex!].revenue,
                      count: data[_touchedIndex!].count,
                    ),
                  )
                : const SizedBox(height: 0, key: ValueKey('empty')),
          ),

          // ── Bar chart ──────────────────────────────────────────────────
          FadeTransition(
            opacity: _fade,
            child: SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: AppColors.border, strokeWidth: 0.5),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.transparent,
                      tooltipPadding: EdgeInsets.zero,
                      getTooltipItem: (_, __, ___, ____) => null,
                    ),
                    touchCallback: (event, response) {
                      if (event is FlTapUpEvent ||
                          event is FlLongPressEnd ||
                          event is FlPanEndEvent) {
                        setState(() => _touchedIndex = null);
                        return;
                      }
                      final idx = response?.spot?.touchedBarGroupIndex;
                      if (idx != null && idx != _touchedIndex) {
                        HapticFeedback.selectionClick();
                        setState(() => _touchedIndex = idx);
                      }
                    },
                  ),
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
                        reservedSize: 26,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          final isToday = i == 6;
                          final isTouched = i == _touchedIndex;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[i],
                              style: TextStyle(
                                fontSize: isToday ? 10 : 9,
                                fontWeight: isTouched || isToday
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isToday
                                    ? AppColors.gold
                                    : isTouched
                                    ? AppColors.cream
                                    : AppColors.cream.withOpacity(0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(7, (i) {
                    final d = data[i];
                    final val = _mode == _ChartMode.revenue
                        ? d.revenue
                        : d.count.toDouble();
                    final isToday = i == 6;
                    final isTouched = i == _touchedIndex;

                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: val,
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          color: isToday
                              ? AppColors.greenLight
                              : isTouched
                              ? AppColors.greenMid
                              : AppColors.greenMid.withOpacity(0.45),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY,
                            color: AppColors.border.withOpacity(0.25),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
                swapAnimationCurve: Curves.easeInOutCubic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNum(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

// ── Mode Toggle ────────────────────────────────────────────────────────────────
class _ModeToggle extends StatelessWidget {
  final _ChartMode mode;
  final ValueChanged<_ChartMode> onChanged;
  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.charcoalHi,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleBtn(
            label: '₹',
            selected: mode == _ChartMode.revenue,
            onTap: () => onChanged(_ChartMode.revenue),
          ),
          const SizedBox(width: 2),
          _ToggleBtn(
            label: '#',
            selected: mode == _ChartMode.count,
            onTap: () => onChanged(_ChartMode.count),
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.charcoalMid : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? AppColors.border : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? AppColors.cream
                : AppColors.cream.withOpacity(0.35),
          ),
        ),
      ),
    );
  }
}

// ── Stat Pill ──────────────────────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.charcoalHi,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.cream.withOpacity(0.35),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bar Tooltip ────────────────────────────────────────────────────────────────
class _BarTooltip extends StatelessWidget {
  final String label;
  final double revenue;
  final int count;
  const _BarTooltip({
    required this.label,
    required this.revenue,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.charcoalHi,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderHi, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.cream.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '₹${revenue.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.greenLight,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '· $count order${count == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.cream.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
// class _WeeklyChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(
//         MediaQuery.of(context).size.width > 700 ? 32 : 24,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.charcoalMid,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'WEEKLY SALES',
//             style: GoogleFonts.bebasNeue(
//               fontSize: 18,
//               color: AppColors.cream,
//               letterSpacing: 1.5,
//             ),
//           ),
//           Text(
//             'Last 7 days revenue',
//             style: TextStyle(
//               fontSize: 11,
//               color: AppColors.cream.withOpacity(0.4),
//             ),
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 160,
//             child: BarChart(
//               BarChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: 2000,
//                   getDrawingHorizontalLine: (_) =>
//                       FlLine(color: AppColors.border, strokeWidth: 0.5),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (v, _) => Text(
//                         kDayLabels[v.toInt()],
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: AppColors.cream.withOpacity(0.5),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 barGroups: kDailySales.asMap().entries.map((e) {
//                   final isToday = e.key == 6;
//                   return BarChartGroupData(
//                     x: e.key,
//                     barRods: [
//                       BarChartRodData(
//                         toY: e.value,
//                         width: 18,
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(6),
//                         ),
//                         color: isToday
//                             ? AppColors.greenLight
//                             : AppColors.greenMid.withOpacity(0.6),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ── Category Pie Chart ────────────────────────────────────────────────────────
// ── Category Pie Chart ─────────────────────────────────────────────────────────
// Pass your orders list from the stream — groups by OrderItem.category
class CategoryPieChart extends StatefulWidget {
  final List<Order> orders;
  const CategoryPieChart({super.key, required this.orders});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart>
    with SingleTickerProviderStateMixin {
  int _touched = -1;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  // Palette — cycles if more than 6 categories
  static const _palette = [
    AppColors.greenLight,
    AppColors.gold,
    AppColors.info,
    AppColors.warning,
    AppColors.success,
    AppColors.cream,
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Data: group all items by category ─────────────────────────────────────
  List<MapEntry<String, int>> get _categoryData {
    final map = <String, int>{};
    for (final order in widget.orders) {
      for (final item in order.items) {
        final cat = item.category.isNotEmpty ? item.category : 'Other';
        map[cat] = (map[cat] ?? 0) + item.qty;
      }
    }
    // Sort descending by count
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _categoryData;
    if (entries.isEmpty) return const SizedBox.shrink();

    final total = entries.fold<int>(0, (s, e) => s + e.value);
    final touched = _touched >= 0 && _touched < entries.length
        ? entries[_touched]
        : null;

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
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Column(
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
                    '${entries.length} categories · $total items',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.cream.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Pie + center label ───────────────────────────────────────────
          ScaleTransition(
            scale: _scale,
            child: SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (event is FlTapUpEvent ||
                              event is FlLongPressEnd) {
                            setState(() => _touched = -1);
                            return;
                          }
                          final idx =
                              response?.touchedSection?.touchedSectionIndex ??
                              -1;
                          if (idx != _touched) {
                            HapticFeedback.selectionClick();
                            setState(() => _touched = idx);
                          }
                        },
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 44,
                      sections: entries.asMap().entries.map((e) {
                        final isTouched = e.key == _touched;
                        final color = _palette[e.key % _palette.length];
                        return PieChartSectionData(
                          value: e.value.value.toDouble(),
                          color: isTouched ? color : color.withOpacity(0.65),
                          radius: isTouched ? 46 : 36,
                          title: '',
                          showTitle: false,
                          borderSide: isTouched
                              ? BorderSide(color: color, width: 2)
                              : const BorderSide(color: Colors.transparent),
                        );
                      }).toList(),
                    ),
                  ),

                  // Center — shows total or touched segment detail
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: touched != null
                        ? _CenterLabel(
                            key: ValueKey(touched.key),
                            title: touched.key,
                            value: '${touched.value}',
                            sub: '${(touched.value / total * 100).round()}%',
                            color:
                                _palette[entries.indexOf(touched) %
                                    _palette.length],
                          )
                        : _CenterLabel(
                            key: const ValueKey('total'),
                            title: 'TOTAL',
                            value: '$total',
                            sub: 'items',
                            color: AppColors.cream,
                          ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),
          Divider(color: AppColors.border, thickness: 0.5, height: 0),
          const SizedBox(height: 14),

          // ── Legend ───────────────────────────────────────────────────────
          ...entries.asMap().entries.map((e) {
            final color = _palette[e.key % _palette.length];
            final isTouched = e.key == _touched;
            final pct = (e.value.value / total * 100).round();

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _touched = isTouched ? -1 : e.key);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isTouched
                      ? color.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isTouched
                        ? color.withOpacity(0.25)
                        : Colors.transparent,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Color dot
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Category name
                    Expanded(
                      child: Text(
                        e.value.key,
                        style: TextStyle(
                          fontSize: 13,
                          color: isTouched
                              ? AppColors.cream
                              : AppColors.cream.withOpacity(0.75),
                          fontWeight: isTouched
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),

                    // Progress bar
                    SizedBox(
                      width: 80,
                      child: Stack(
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.charcoalHi,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: e.value.value / total,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: color.withOpacity(isTouched ? 1.0 : 0.6),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Count
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${e.value.value}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isTouched
                              ? color
                              : AppColors.cream.withOpacity(0.7),
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Percentage
                    SizedBox(
                      width: 34,
                      child: Text(
                        '$pct%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.cream.withOpacity(0.35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Center Label ───────────────────────────────────────────────────────────────
class _CenterLabel extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final Color color;

  const _CenterLabel({
    super.key,
    required this.title,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 0.8,
            color: AppColors.cream.withOpacity(0.4),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: GoogleFonts.bebasNeue(
            fontSize: 24,
            color: color,
            letterSpacing: 1,
            height: 1.1,
          ),
        ),
        Text(
          sub,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.cream.withOpacity(0.35),
          ),
        ),
      ],
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
