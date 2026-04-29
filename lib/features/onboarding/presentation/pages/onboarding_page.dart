import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/notifications/notifications_service.dart';
import '../../../../shared/theme/theme.dart';
import '../../../settings/domain/entities/primary_calendar_preference.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/calendar_choice_card.dart';
import '../widgets/feature_card.dart';
import '../widgets/onboarding_screen_layout.dart';
import '../widgets/permission_preview.dart';
import '../widgets/welcome_illustration.dart';

const int _totalSteps = 4;

/// 4-screen swipeable onboarding: Welcome → Features → Calendar choice →
/// Notification permission. Skip jumps to the last screen so users still
/// see the permission ask. Completion writes the persisted flag and
/// routes home.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;
  PrimaryCalendarPreference _selectedCalendar =
      PrimaryCalendarPreference.english;
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _selectedCalendar =
        ref.read(currentSettingsProvider).primaryCalendar;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _complete({required bool requestNotifications}) async {
    if (_completing) return;
    setState(() => _completing = true);

    // Persist calendar choice into settings.
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final current = ref.read(currentSettingsProvider);
    await settingsRepo.updateSettings(
      current.copyWith(primaryCalendar: _selectedCalendar),
    );

    if (requestNotifications) {
      final bool granted =
          await NotificationsService.instance.requestPermission();
      await settingsRepo.updateSettings(
        ref.read(currentSettingsProvider).copyWith(
              notificationsEnabled: granted,
            ),
      );
    }

    // Mark onboarding done.
    await ref.read(onboardingRepositoryProvider).markCompleted();
    ref.invalidate(hasCompletedOnboardingProvider);

    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Scaffold(
      backgroundColor: roles.bgCanvas,
      body: PageView(
        controller: _controller,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (int i) => setState(() => _index = i),
        children: <Widget>[
          _Welcome(
            currentStep: _index,
            onSkip: () => _goTo(3),
            onNext: () => _goTo(1),
          ),
          _Features(
            currentStep: _index,
            onSkip: () => _goTo(3),
            onNext: () => _goTo(2),
          ),
          _CalendarChoice(
            currentStep: _index,
            selected: _selectedCalendar,
            onSelect: (PrimaryCalendarPreference p) =>
                setState(() => _selectedCalendar = p),
            onSkip: () => _goTo(3),
            onNext: () => _goTo(3),
          ),
          _Permissions(
            currentStep: _index,
            isCompleting: _completing,
            onAllow: () => _complete(requestNotifications: true),
            onMaybeLater: () => _complete(requestNotifications: false),
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({
    required this.currentStep,
    required this.onSkip,
    required this.onNext,
  });

  final int currentStep;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return OnboardingScreenLayout(
      totalSteps: _totalSteps,
      currentStep: currentStep,
      onSkip: onSkip,
      body: Column(
        children: <Widget>[
          const Expanded(child: Center(child: WelcomeIllustration())),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: AppTypography.h1Bn().copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: roles.fgPrimary,
                height: 1.25,
                letterSpacing: -0.14,
              ),
              children: const <InlineSpan>[
                TextSpan(text: 'স্বাগতম '),
                TextSpan(
                  text: 'BongoCal',
                  style: TextStyle(color: AppColors.brandEmerald),
                ),
                TextSpan(text: '-এ'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bangladesh\'s most beautiful calendar. বাংলা, ইংরেজি '
            'ও হিজরি — সব এক জায়গায়।',
            style: AppTypography.bodyBn().copyWith(
              fontSize: 15,
              color: roles.fgSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
      cta: _PrimaryCta(label: 'শুরু করুন', onPressed: onNext),
    );
  }
}

class _Features extends StatelessWidget {
  const _Features({
    required this.currentStep,
    required this.onSkip,
    required this.onNext,
  });

  final int currentStep;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return OnboardingScreenLayout(
      totalSteps: _totalSteps,
      currentStep: currentStep,
      onSkip: onSkip,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'সব এক জায়গায়।',
              style: AppTypography.h1Bn().copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: roles.fgPrimary,
                letterSpacing: -0.14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'তিনটি ক্যালেন্ডার, প্রার্থনার সময়, এবং বাংলাদেশের সব ছুটি '
              '— একটি সুন্দর অ্যাপে।',
              style: AppTypography.bodyBn().copyWith(
                fontSize: 15,
                color: roles.fgSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            const FeatureCard(
              icon: Icons.calendar_month_outlined,
              tone: FeatureCardTone.emerald,
              titleBn: 'বাংলা ক্যালেন্ডার',
              descriptionBn:
                  'সংস্কারকৃত বঙ্গাব্দ — তারিখ, মাস ও পঞ্জিকা।',
            ),
            const SizedBox(height: 12),
            const FeatureCard(
              icon: Icons.brightness_3,
              tone: FeatureCardTone.gold,
              titleBn: 'হিজরি ও নামাজের সময়',
              descriptionBn:
                  'আপনার এলাকা অনুযায়ী পাঁচ ওয়াক্তের সময়সূচী।',
            ),
            const SizedBox(height: 12),
            const FeatureCard(
              icon: Icons.star_outline,
              tone: FeatureCardTone.red,
              titleBn: 'সব ছুটি ও উৎসব',
              descriptionBn:
                  'পহেলা বৈশাখ, ঈদ, পূজা, স্বাধীনতা ও বিজয় দিবস।',
            ),
          ],
        ),
      ),
      cta: _PrimaryCta(label: 'পরবর্তী', onPressed: onNext),
    );
  }
}

class _CalendarChoice extends StatelessWidget {
  const _CalendarChoice({
    required this.currentStep,
    required this.selected,
    required this.onSelect,
    required this.onSkip,
    required this.onNext,
  });

  final int currentStep;
  final PrimaryCalendarPreference selected;
  final ValueChanged<PrimaryCalendarPreference> onSelect;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return OnboardingScreenLayout(
      totalSteps: _totalSteps,
      currentStep: currentStep,
      onSkip: onSkip,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'প্রধান ক্যালেন্ডার বেছে নিন',
              style: AppTypography.h1Bn().copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: roles.fgPrimary,
                letterSpacing: -0.14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'আপনি যেকোনো সময় পরিবর্তন করতে পারবেন (Settings → '
              'প্রধান ক্যালেন্ডার)।',
              style: AppTypography.bodyBn().copyWith(
                fontSize: 15,
                color: roles.fgSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 22),
            CalendarChoiceCard(
              titleBn: 'English (Gregorian)',
              titleEn: 'Default',
              exampleDate: '27 April 2026',
              icon: Icons.calendar_today_outlined,
              isSelected: selected == PrimaryCalendarPreference.english,
              onTap: () => onSelect(PrimaryCalendarPreference.english),
            ),
            const SizedBox(height: 10),
            CalendarChoiceCard(
              titleBn: 'বাংলা (বঙ্গাব্দ)',
              titleEn: 'Bengali',
              exampleDate: '১৪ বৈশাখ ১৪৩৩',
              icon: Icons.local_florist_outlined,
              isSelected: selected == PrimaryCalendarPreference.bangla,
              onTap: () => onSelect(PrimaryCalendarPreference.bangla),
            ),
            const SizedBox(height: 10),
            CalendarChoiceCard(
              titleBn: 'হিজরি (Islamic)',
              titleEn: 'Hijri',
              exampleDate: '৯ শাওয়াল ১৪৪৭',
              icon: Icons.brightness_3,
              isSelected: selected == PrimaryCalendarPreference.hijri,
              onTap: () => onSelect(PrimaryCalendarPreference.hijri),
            ),
          ],
        ),
      ),
      cta: _PrimaryCta(label: 'পরবর্তী', onPressed: onNext),
    );
  }
}

class _Permissions extends StatelessWidget {
  const _Permissions({
    required this.currentStep,
    required this.isCompleting,
    required this.onAllow,
    required this.onMaybeLater,
  });

  final int currentStep;
  final bool isCompleting;
  final VoidCallback onAllow;
  final VoidCallback onMaybeLater;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return OnboardingScreenLayout(
      totalSteps: _totalSteps,
      currentStep: currentStep,
      // No skip on the last screen — skip lands here already.
      onSkip: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const PermissionPreview(),
            const SizedBox(height: 18),
            Text(
              'Notifications চালু করুন',
              style: AppTypography.h1Bn().copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: roles.fgPrimary,
                letterSpacing: -0.14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ছুটি ও উৎসবের আগে reminder পান। আপনি যেকোনো সময় '
              'বন্ধ করতে পারবেন।',
              style: AppTypography.bodyBn().copyWith(
                fontSize: 15,
                color: roles.fgSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 14),
            const _PermBullet(text: 'সরকারি ছুটির ১ দিন আগে'),
            const SizedBox(height: 8),
            const _PermBullet(text: 'উৎসবের সকালে শুভেচ্ছা'),
            const SizedBox(height: 8),
            const _PermBullet(text: 'প্রার্থনার সময় (ঐচ্ছিক)'),
          ],
        ),
      ),
      cta: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _PrimaryCta(
            label: 'Allow notifications',
            onPressed: onAllow,
            isLoading: isCompleting,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: isCompleting ? null : onMaybeLater,
              style: TextButton.styleFrom(
                foregroundColor: roles.fgSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'পরে করব',
                style: AppTypography.bodyBn().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: roles.fgSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermBullet extends StatelessWidget {
  const _PermBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.brandEmerald.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check,
            size: 14,
            color: AppColors.brandEmerald,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 13,
              color: roles.fgSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandEmerald,
          disabledBackgroundColor:
              AppColors.brandEmerald.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isLoading) ...<Widget>[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTypography.bodyBn().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
