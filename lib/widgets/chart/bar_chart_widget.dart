import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final List<Map<String, dynamic>> data; // {'bulan': 'Jan', 'value': 8, 'color': Colors.blue}
  final String Function(double value)? formatAxisLabel;
  final double heightPerItem;

  const BarChartWidget({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    required this.data,
    this.heightPerItem = 44,
    this.formatAxisLabel,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  int? selectedIndex;

  double get _maxValue {
    if (widget.data.isEmpty) return 1;
    final maxv = widget.data
        .map((e) => (e['value'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    final upper = ((maxv / 5).ceil() * 5).toDouble();
    return upper == 0 ? 5 : upper;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final maxValue = _maxValue;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final chartWidth = constraints.maxWidth - (56 + 8);
            final ticks = 5;
            final tickStep = chartWidth / ticks;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Title dengan ikon ===
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      if (widget.icon != null)
                        Icon(
                          widget.icon,
                          color: widget.iconColor ?? Colors.indigoAccent,
                          size: 20,
                        ),
                      if (widget.icon != null) const SizedBox(width: 8),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                          widget.iconColor ?? Colors.indigoAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ Scroll seluruh chart untuk mencegah overflow
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // === Bar chart list ===
                      ...List.generate(data.length, (index) {
                        final item = data[index];
                        final value = (item['value'] as num).toDouble();
                        final color = item['color'] as Color;
                        final label = item['bulan'] as String;
                        final fraction =
                        (maxValue == 0) ? 0.0 : (value / maxValue);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 56,
                                child: Text(
                                  label,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex =
                                      selectedIndex == index ? null : index;
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: fraction.clamp(0.0, 1.0),
                                        child: AnimatedContainer(
                                          duration:
                                          const Duration(milliseconds: 300),
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: selectedIndex == index
                                                ? color.withOpacity(0.9)
                                                : color,
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            boxShadow: selectedIndex == index
                                                ? [
                                              BoxShadow(
                                                color: color
                                                    .withOpacity(0.25),
                                                blurRadius: 8,
                                                offset:
                                                const Offset(0, 3),
                                              )
                                            ]
                                                : null,
                                          ),
                                        ),
                                      ),
                                      if (selectedIndex == index)
                                        Positioned(
                                          right: 6,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item['label'] ??
                                                  value.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 12),

                      // === Axis scale ===
                      Padding(
                        padding: const EdgeInsets.only(left: 56 + 8, right: 8),
                        child: Row(
                          children: List.generate(ticks + 1, (i) {
                            final tickValue = (maxValue / ticks * i);
                            final tickLabel = widget.formatAxisLabel != null
                                ? widget.formatAxisLabel!(tickValue)
                                : tickValue.round().toString();

                            return Expanded(
                              child: Align(
                                alignment: i == 0
                                    ? Alignment.centerLeft
                                    : i == ticks
                                    ? Alignment.centerRight
                                    : Alignment.center,
                                child: Text(
                                  tickLabel,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
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
