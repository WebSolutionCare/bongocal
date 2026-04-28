import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/utils/bangla_numerals.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/language_preference.dart';
import '../../domain/entities/primary_calendar_preference.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/entities/week_start_preference.dart';
import '../../domain/repositories/settings_repository.dart';
import '../providers/settings_provider.dart';
import '../sheets/preference_picker.dart';
import '../widgets/pro_upgrade_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/segmented_control.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final AsyncValue<AppSettings> async = ref.watch(settingsProvider);
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: async.when(
          data: (AppSettings s) => _Body(
            settings: s,
            bottomPadding:
                AppSpacing.bottomNavHeight + bottomInset + AppSpacing.s6,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Text(
                'লোড করা যায়নি · $e',
                style: AppTypography.bodyBn().copyWith(
                  color: roles.fgSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 4,
        onTap: (int i) {
          switch (i) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.month);
            case 2:
              context.go(AppRoutes.holidays);
            case 3:
              context.go(AppRoutes.events);
            case 4:
              return;
          }
        },
        items: const <BottomNavItem>[
          BottomNavItem(icon: Icons.home_outlined, label: 'হোম'),
          BottomNavItem(
            icon: Icons.calendar_today_outlined,
            label: 'ক্যালেন্ডার',
          ),
          BottomNavItem(icon: Icons.star_outline, label: 'ছুটি'),
          BottomNavItem(icon: Icons.event_note_outlined, label: 'ইভেন্ট'),
          BottomNavItem(icon: Icons.settings_outlined, label: 'সেটিংস'),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.settings, required this.bottomPadding});

  final AppSettings settings;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsRepository repo = ref.watch(settingsRepositoryProvider);

    Future<void> apply(AppSettings next) async {
      await repo.updateSettings(next);
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: bottomPadding),
      children: <Widget>[
        const _TopBar(),
        ProfileCard(onTap: () {}),

        // === Appearance ===
        SettingsSection(
          titleBn: 'চেহারা',
          titleEn: 'Appearance',
          children: <Widget>[
            SettingsTile(
              icon: Icons.brightness_5_outlined,
              tone: SettingsIconTone.emerald,
              label: 'থিম',
              trailing: InlineSegmentedControl<ThemePreference>(
                options: ThemePreference.values,
                selected: settings.themeMode,
                labelOf: (ThemePreference t) => t.displayEn,
                onSelect: (ThemePreference t) =>
                    apply(settings.copyWith(themeMode: t)),
              ),
            ),
            SettingsTile(
              icon: Icons.public,
              tone: SettingsIconTone.info,
              label: 'ভাষা',
              subLabel: 'সেটিং সংরক্ষিত · UI translations coming soon',
              trailing: InlineSegmentedControl<LanguagePreference>(
                options: LanguagePreference.values,
                selected: settings.language,
                labelOf: (LanguagePreference l) => l.displayBn,
                onSelect: (LanguagePreference l) =>
                    apply(settings.copyWith(language: l)),
              ),
            ),
            SettingsSwitchTile(
              icon: Icons.format_list_numbered,
              tone: SettingsIconTone.purple,
              label: 'বাংলা সংখ্যা দেখান',
              subLabel: 'Show Bangla numerals (০ ১ ২)',
              value: settings.showBanglaNumerals,
              onChanged: (bool v) =>
                  apply(settings.copyWith(showBanglaNumerals: v)),
            ),
            SettingsTile(
              icon: Icons.calendar_view_week_outlined,
              tone: SettingsIconTone.red,
              label: 'সপ্তাহ শুরু',
              subLabel: 'সেটিং সংরক্ষিত · ক্যালেন্ডার গ্রিডে শীঘ্রই',
              trailing: SettingsValueTrailing(
                text: settings.weekStartDay.displayBn,
              ),
              onTap: () async {
                final WeekStartPreference? picked =
                    await showPreferencePicker<WeekStartPreference>(
                  context: context,
                  title: 'সপ্তাহ শুরু',
                  options: WeekStartPreference.values,
                  selected: settings.weekStartDay,
                  labelOf: (WeekStartPreference w) => w.displayBn,
                );
                if (picked != null) {
                  await apply(settings.copyWith(weekStartDay: picked));
                }
              },
            ),
          ],
        ),

        // === Calendar ===
        SettingsSection(
          titleBn: 'ক্যালেন্ডার পছন্দ',
          titleEn: 'Calendar',
          children: <Widget>[
            SettingsTile(
              icon: Icons.star_outline,
              tone: SettingsIconTone.emerald,
              label: 'প্রধান ক্যালেন্ডার',
              subLabel: 'সেটিং সংরক্ষিত · লেআউট সুইচ শীঘ্রই',
              trailing: SettingsValueTrailing(
                text: settings.primaryCalendar.displayBn,
              ),
              onTap: () async {
                final PrimaryCalendarPreference? picked =
                    await showPreferencePicker<PrimaryCalendarPreference>(
                  context: context,
                  title: 'প্রধান ক্যালেন্ডার',
                  options: PrimaryCalendarPreference.values,
                  selected: settings.primaryCalendar,
                  labelOf: (PrimaryCalendarPreference p) => p.displayBn,
                );
                if (picked != null) {
                  await apply(settings.copyWith(primaryCalendar: picked));
                }
              },
            ),
          ],
        ),

        // === Notifications ===
        SettingsSection(
          titleBn: 'নোটিফিকেশন',
          titleEn: 'Notifications',
          children: <Widget>[
            SettingsSwitchTile(
              icon: Icons.notifications_active_outlined,
              tone: SettingsIconTone.red,
              label: 'ছুটির রিমাইন্ডার',
              subLabel: 'সেটিং সংরক্ষিত · নোটিফিকেশন শীঘ্রই আসছে',
              value: settings.notificationsEnabled,
              onChanged: (bool v) =>
                  apply(settings.copyWith(notificationsEnabled: v)),
            ),
            SettingsTile(
              icon: Icons.access_time,
              tone: SettingsIconTone.gray,
              label: 'কখন জানাবেন',
              subLabel: 'সেটিং সংরক্ষিত',
              trailing: SettingsValueTrailing(
                text: _holidayReminderLabel(
                  settings.holidayReminderDays,
                  useBn: settings.showBanglaNumerals,
                ),
              ),
              onTap: () async {
                final List<int>? picked =
                    await showPreferencePicker<List<int>>(
                  context: context,
                  title: 'কখন জানাবেন',
                  options: const <List<int>>[
                    <int>[1],
                    <int>[3],
                    <int>[7],
                    <int>[1, 3, 7],
                  ],
                  selected: settings.holidayReminderDays,
                  labelOf: (List<int> d) => _holidayReminderLabel(
                    d,
                    useBn: settings.showBanglaNumerals,
                  ),
                );
                if (picked != null) {
                  await apply(
                    settings.copyWith(holidayReminderDays: picked),
                  );
                }
              },
            ),
            SettingsSwitchTile(
              icon: Icons.celebration_outlined,
              tone: SettingsIconTone.gold,
              label: 'উৎসবের শুভেচ্ছা',
              subLabel: 'সেটিং সংরক্ষিত · উৎসবের ওভারলে শীঘ্রই',
              value: settings.festivalGreetingsEnabled,
              onChanged: (bool v) =>
                  apply(settings.copyWith(festivalGreetingsEnabled: v)),
            ),
            SettingsTile(
              icon: Icons.volume_up_outlined,
              tone: SettingsIconTone.info,
              label: 'ইভেন্ট সাউন্ড',
              subLabel: 'সেটিং সংরক্ষিত',
              trailing: SettingsValueTrailing(
                text: _soundLabel(settings.eventReminderSound),
              ),
              onTap: () async {
                final String? picked = await showPreferencePicker<String>(
                  context: context,
                  title: 'ইভেন্ট সাউন্ড',
                  options: const <String>['default', 'chime', 'silent'],
                  selected: settings.eventReminderSound,
                  labelOf: _soundLabel,
                );
                if (picked != null) {
                  await apply(settings.copyWith(eventReminderSound: picked));
                }
              },
            ),
          ],
        ),

        // === Pro upgrade ===
        ProUpgradeCard(
          onUpgrade: () => context.push(AppRoutes.proInterest),
        ),

        // === About ===
        SettingsSection(
          titleBn: 'সম্পর্কে',
          titleEn: 'About',
          children: <Widget>[
            SettingsTile(
              icon: Icons.info_outline,
              tone: SettingsIconTone.emerald,
              label: 'BongoCal সম্পর্কে',
              subLabel: 'শীঘ্রই আসছে',
              trailing: const SettingsChevTrailing(),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.shield_outlined,
              tone: SettingsIconTone.gray,
              label: 'গোপনীয়তা নীতি',
              subLabel: 'শীঘ্রই আসছে',
              trailing: const SettingsChevTrailing(),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.description_outlined,
              tone: SettingsIconTone.gray,
              label: 'শর্তাবলী',
              subLabel: 'শীঘ্রই আসছে',
              trailing: const SettingsChevTrailing(),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.star_outline,
              tone: SettingsIconTone.gold,
              label: 'অ্যাপ রেট করুন',
              subLabel: 'শীঘ্রই আসছে',
              trailing: const SettingsChevTrailing(),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.ios_share,
              tone: SettingsIconTone.info,
              label: 'শেয়ার করুন',
              subLabel: 'শীঘ্রই আসছে',
              trailing: const SettingsChevTrailing(),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.message_outlined,
              tone: SettingsIconTone.purple,
              label: 'যোগাযোগ',
              subLabel: 'শীঘ্রই আসছে',
              trailing: const SettingsChevTrailing(),
              onTap: () {},
            ),
          ],
        ),

        // === Account ===
        SettingsSection(
          titleBn: 'অ্যাকাউন্ট',
          titleEn: 'Account',
          children: <Widget>[
            SettingsTile(
              icon: Icons.refresh,
              tone: SettingsIconTone.emerald,
              label: 'রিসেট ডিফল্ট',
              subLabel: 'Reset to defaults',
              trailing: const SettingsChevTrailing(),
              onTap: () =>
                  ref.read(settingsRepositoryProvider).updateSettings(
                        AppSettings.defaults(),
                      ),
            ),
            SettingsTile(
              icon: Icons.logout,
              tone: SettingsIconTone.red,
              label: 'সাইন আউট',
              subLabel: 'শীঘ্রই আসছে · sign-in needed first',
              isDestructive: true,
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 18),
        const _Footer(),
      ],
    );
  }

  static String _holidayReminderLabel(List<int> days, {bool useBn = true}) {
    if (days.isEmpty) return 'বন্ধ';
    String fmt(int n) => useBn ? BanglaNumerals.fromInt(n) : '$n';
    if (days.length == 1) {
      return '${fmt(days.first)} দিন আগে';
    }
    return '${days.map(fmt).join(' · ')} দিন আগে';
  }

  static String _soundLabel(String key) {
    switch (key) {
      case 'chime':
        return 'চাইম';
      case 'silent':
        return 'নীরব';
      default:
        return 'ডিফল্ট';
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'সেটিংস',
            style: AppTypography.h1Bn().copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: roles.fgPrimary,
              letterSpacing: -0.11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'SETTINGS',
            style: AppTypography.captionEn().copyWith(
              color: roles.fgTertiary,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Column(
        children: <Widget>[
          Text(
            'BongoCal v1.0.0',
            style: AppTypography.bodySmEn().copyWith(
              fontSize: 11,
              color: roles.fgTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            '© 2026 BongoCal · Made in Dhaka',
            style: AppTypography.bodySmEn().copyWith(
              fontSize: 11,
              color: roles.fgTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
