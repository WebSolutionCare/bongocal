import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import 'settings_tile.dart';

/// Settings tile whose trailing widget is a Material switch.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    required this.icon,
    required this.tone,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subLabel,
    super.key,
  });

  final IconData icon;
  final SettingsIconTone tone;
  final String label;
  final String? subLabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      tone: tone,
      label: label,
      subLabel: subLabel,
      onTap: () => onChanged(!value),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.brandEmerald,
      ),
    );
  }
}
