import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final List<Map<String, dynamic>> data;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.icon,
    this.iconColor,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Bagian Judul dengan Icon ===
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
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

            // === Chart ===
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 0,
                      sectionsSpace: 1,
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              touchedIndex = null;
                              return;
                            }
                            final index =
                                response.touchedSection!.touchedSectionIndex;
                            touchedIndex =
                            (index >= 0 && index < data.length)
                                ? index
                                : null;
                          });
                        },
                      ),
                      sections: List.generate(data.length, (i) {
                        final isTouched = i == touchedIndex;
                        final double radius = isTouched ? 70 : 60;
                        return PieChartSectionData(
                          color: data[i]['color'] as Color,
                          value: (data[i]['value'] as num).toDouble(),
                          radius: radius,
                          title: '',
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            // === Tooltip ===
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: touchedIndex != null
                  ? Center(
                key: ValueKey<int>(touchedIndex!),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data[touchedIndex!]['kategori'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data[touchedIndex!]['value']} kegiatan',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),

            const SizedBox(height: 12),

            // === Keterangan kategori ===
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: e['color'] as Color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  e['kategori'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: data.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${e['value']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
