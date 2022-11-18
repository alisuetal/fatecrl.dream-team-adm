import 'package:dream_team_adm/components/navigation_bar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BottomNavigationBarWidget extends HookWidget {
  final int pageIndex;
  final void Function(int index) onChange;
  const BottomNavigationBarWidget({
    Key? key,
    required this.onChange,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 72,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF2F2F2F),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavigationBarIconWidget(
                  icon: Icons.person_rounded,
                  active: pageIndex == 0,
                  onClick: () => onChange(0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
