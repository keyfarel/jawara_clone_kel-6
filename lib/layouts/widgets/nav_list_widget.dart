import 'package:flutter/material.dart';
import '../../data/menu_item_data.dart';
import '../../data/child_to_route.dart';

class NavListWidget extends StatefulWidget {
  const NavListWidget({super.key});

  @override
  State<NavListWidget> createState() => _NavListWidgetState();
}

class _NavListWidgetState extends State<NavListWidget>
    with TickerProviderStateMixin {
  final Map<int, bool> _expanded = {};
  final Map<int, AnimationController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const parentFontSize = 14.0;
    const childFontSize = 13.0;
    const iconSize = 18.0;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];

        _controllers.putIfAbsent(
          index,
          () => AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 200),
          ),
        );

        final controller = _controllers[index]!;
        final rotation =
            Tween<double>(begin: 0.0, end: 0.25).animate(controller);
        final isExpanded = _expanded[index] ?? false;

        if (item.children == null || item.children!.isEmpty) {
          return ListTile(
            dense: true,
            leading: Icon(item.icon, size: iconSize, color: Colors.blue.shade700),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: parentFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
            onTap: () => Navigator.pop(context),
          );
        }

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: Key(index.toString()),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (value) {
              setState(() {
                _expanded[index] = value;
                value ? controller.forward() : controller.reverse();
              });
            },
            leading: Icon(item.icon, size: iconSize, color: Colors.blue.shade700),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: parentFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: RotationTransition(
              turns: rotation,
              child: Icon(Icons.chevron_right, size: 22, color: Colors.grey.shade600),
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            childrenPadding:
                const EdgeInsets.only(left: 16.0, bottom: 4.0, right: 8.0),
            children: item.children!.map((child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0, right: 12),
                    child: Container(
                      width: 1,
                      height: 32,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      dense: true,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      contentPadding:
                          const EdgeInsets.only(left: 4.0, right: 16.0),
                      title: Text(
                        child,
                        style: const TextStyle(
                          fontSize: childFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (childToRoute.containsKey(child)) {
                          Navigator.pushNamed(context, childToRoute[child]!);
                        }
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
