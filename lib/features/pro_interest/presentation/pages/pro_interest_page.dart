import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../domain/entities/beta_interest.dart';
import '../../domain/entities/price_point.dart';
import '../../domain/entities/pro_feature.dart';
import '../../domain/entities/pro_interest_submission.dart';
import '../../domain/entities/usage_frequency.dart';
import '../../domain/repositories/pro_interest_repository.dart';
import '../providers/pro_interest_provider.dart';
import '../widgets/checkbox_option.dart';
import '../widgets/radio_option.dart';
import '../widgets/section_card.dart';
import '../widgets/submit_button.dart';

/// Pro-interest demand-validation form. Captures structured feedback +
/// posts to the configured Apps Script Web App.
class ProInterestPage extends ConsumerStatefulWidget {
  const ProInterestPage({super.key});

  @override
  ConsumerState<ProInterestPage> createState() => _ProInterestPageState();
}

class _ProInterestPageState extends ConsumerState<ProInterestPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _whatsappCtrl = TextEditingController();
  final TextEditingController _suggestionsCtrl = TextEditingController();

  final ScrollController _scroll = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = <int, GlobalKey>{
    for (int i = 1; i <= 8; i++) i: GlobalKey(),
  };

  UsageFrequency? _usage;
  final Set<ProFeature> _features = <ProFeature>{};
  PricePoint? _price;
  BetaInterest? _beta;

  String? _emailError;
  String? _usageError;
  String? _featuresError;
  String? _priceError;
  String? _betaError;

  bool _submitting = false;
  bool _submitted = false;
  String? _submissionError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _whatsappCtrl.dispose();
    _suggestionsCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+\-]+@[\w\-]+\.[\w.\-]+$');

  bool _validate() {
    final String email = _emailCtrl.text.trim();
    final String? emailErr = email.isEmpty
        ? 'ইমেইল দিন'
        : !_emailRegex.hasMatch(email)
            ? 'সঠিক ইমেইল ঠিকানা দিন'
            : null;

    final String? usageErr =
        _usage == null ? 'ব্যবহারের ধরন বেছে নিন' : null;
    final String? featuresErr =
        _features.isEmpty ? 'অন্তত একটি ফিচার বেছে নিন' : null;
    final String? priceErr =
        _price == null ? 'একটি মূল্য বেছে নিন' : null;
    final String? betaErr =
        _beta == null ? 'একটি অপশন বেছে নিন' : null;

    setState(() {
      _emailError = emailErr;
      _usageError = usageErr;
      _featuresError = featuresErr;
      _priceError = priceErr;
      _betaError = betaErr;
    });

    return emailErr == null &&
        usageErr == null &&
        featuresErr == null &&
        priceErr == null &&
        betaErr == null;
  }

  void _scrollToFirstError() {
    final List<int> erroredSections = <int>[
      if (_emailError != null) 2,
      if (_usageError != null) 4,
      if (_featuresError != null) 5,
      if (_priceError != null) 6,
      if (_betaError != null) 7,
    ];
    if (erroredSections.isEmpty) return;
    final BuildContext? ctx = _sectionKeys[erroredSections.first]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.1,
    );
  }

  Future<void> _submit() async {
    if (!_validate()) {
      _scrollToFirstError();
      return;
    }
    setState(() {
      _submitting = true;
      _submissionError = null;
    });

    final ProInterestRepository repo =
        ref.read(proInterestRepositoryProvider);
    final result = await repo.submitInterest(
      ProInterestSubmission(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        whatsapp: _whatsappCtrl.text.trim(),
        usageFrequency: _usage!,
        features: _features.toList()..sort((a, b) => a.index - b.index),
        pricePoint: _price!,
        betaInterest: _beta!,
        suggestions: _suggestionsCtrl.text.trim(),
        submittedAt: DateTime.now(),
        userAgent: _userAgent(),
      ),
    );

    if (!mounted) return;
    result.fold(
      (Object f) => setState(() {
        _submitting = false;
        _submissionError = 'জমা দেওয়া যায়নি · please try again ($f)';
      }),
      (_) => setState(() {
        _submitting = false;
        _submitted = true;
      }),
    );
  }

  String _userAgent() {
    if (kIsWeb) return 'Web';
    try {
      return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    } on Exception {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      body: _submitted
          ? const _SuccessState()
          : _FormBody(
              scroll: _scroll,
              sectionKeys: _sectionKeys,
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              whatsappCtrl: _whatsappCtrl,
              suggestionsCtrl: _suggestionsCtrl,
              usage: _usage,
              features: _features,
              price: _price,
              beta: _beta,
              emailError: _emailError,
              usageError: _usageError,
              featuresError: _featuresError,
              priceError: _priceError,
              betaError: _betaError,
              submitting: _submitting,
              submissionError: _submissionError,
              onUsage: (UsageFrequency? u) => setState(() => _usage = u),
              onToggleFeature: (ProFeature f) => setState(() {
                if (!_features.add(f)) _features.remove(f);
              }),
              onPrice: (PricePoint? p) => setState(() => _price = p),
              onBeta: (BetaInterest? b) => setState(() => _beta = b),
              onSubmit: _submit,
              onBack: () => Navigator.of(context).maybePop(),
            ),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({
    required this.scroll,
    required this.sectionKeys,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.whatsappCtrl,
    required this.suggestionsCtrl,
    required this.usage,
    required this.features,
    required this.price,
    required this.beta,
    required this.emailError,
    required this.usageError,
    required this.featuresError,
    required this.priceError,
    required this.betaError,
    required this.submitting,
    required this.submissionError,
    required this.onUsage,
    required this.onToggleFeature,
    required this.onPrice,
    required this.onBeta,
    required this.onSubmit,
    required this.onBack,
  });

  final ScrollController scroll;
  final Map<int, GlobalKey> sectionKeys;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController whatsappCtrl;
  final TextEditingController suggestionsCtrl;
  final UsageFrequency? usage;
  final Set<ProFeature> features;
  final PricePoint? price;
  final BetaInterest? beta;
  final String? emailError;
  final String? usageError;
  final String? featuresError;
  final String? priceError;
  final String? betaError;
  final bool submitting;
  final String? submissionError;
  final ValueChanged<UsageFrequency?> onUsage;
  final ValueChanged<ProFeature> onToggleFeature;
  final ValueChanged<PricePoint?> onPrice;
  final ValueChanged<BetaInterest?> onBeta;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;

    return CustomScrollView(
      controller: scroll,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(child: _Hero(onBack: onBack)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              SectionCard(
                key: sectionKeys[1],
                number: 1,
                title: 'নাম',
                subtitle: 'ঐচ্ছিক · we use this only to greet you',
                child: _PlainTextField(
                  controller: nameCtrl,
                  hintBn: 'আপনার নাম',
                  textInputType: TextInputType.name,
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[2],
                number: 2,
                title: 'ইমেইল',
                subtitle: 'launch হলে আপনাকে জানাব',
                isRequired: true,
                errorText: emailError,
                child: _PlainTextField(
                  controller: emailCtrl,
                  hintBn: 'you@example.com',
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[3],
                number: 3,
                title: 'WhatsApp নম্বর',
                subtitle: 'ঐচ্ছিক',
                child: _PlainTextField(
                  controller: whatsappCtrl,
                  hintBn: '+880 1XXX-XXXXXX',
                  textInputType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[4],
                number: 4,
                title: 'ব্যবহারের ধরন',
                subtitle: 'কতটা ঘন ঘন ব্যবহার করতে চান?',
                isRequired: true,
                errorText: usageError,
                child: Column(
                  children: <Widget>[
                    for (final UsageFrequency u in UsageFrequency.values) ...<Widget>[
                      RadioOption(
                        label: u.displayBn,
                        isSelected: u == usage,
                        onTap: () => onUsage(u),
                      ),
                      if (u != UsageFrequency.values.last)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[5],
                number: 5,
                title: 'কোন Pro features চান',
                subtitle: 'যত খুশি বেছে নিন',
                isRequired: true,
                errorText: featuresError,
                child: Column(
                  children: <Widget>[
                    for (final ProFeature f in ProFeature.values) ...<Widget>[
                      CheckboxOption(
                        label: f.displayBn,
                        isChecked: features.contains(f),
                        onToggle: () => onToggleFeature(f),
                      ),
                      if (f != ProFeature.values.last)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[6],
                number: 6,
                title: 'মূল্য — কোনটি ঠিক মনে হয়?',
                isRequired: true,
                errorText: priceError,
                child: Column(
                  children: <Widget>[
                    for (final PricePoint p in PricePoint.values) ...<Widget>[
                      RadioOption(
                        label: p.displayBn,
                        isSelected: p == price,
                        onTap: () => onPrice(p),
                        trailingBadge: p.isPopular ? const _PopularBadge() : null,
                      ),
                      if (p != PricePoint.values.last)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[7],
                number: 7,
                title: 'Beta tester হতে চান?',
                subtitle: 'launch-এর আগে চেষ্টা করার সুযোগ',
                isRequired: true,
                errorText: betaError,
                child: Column(
                  children: <Widget>[
                    for (final BetaInterest b in BetaInterest.values) ...<Widget>[
                      RadioOption(
                        label: b.displayBn,
                        isSelected: b == beta,
                        onTap: () => onBeta(b),
                      ),
                      if (b != BetaInterest.values.last)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SectionCard(
                key: sectionKeys[8],
                number: 8,
                title: 'অন্য কোন feature বা মতামত?',
                subtitle: 'ঐচ্ছিক · যা মনে আসে লিখুন',
                child: TextField(
                  controller: suggestionsCtrl,
                  minLines: 3,
                  maxLines: 6,
                  style: AppTypography.bodyBn().copyWith(
                    fontSize: 14,
                    color: roles.fgPrimary,
                  ),
                  decoration: _decoration(
                    context,
                    hint: 'আপনার ভাবনা শেয়ার করুন...',
                  ),
                ),
              ),
              const SizedBox(height: 22),
              if (submissionError != null) ...<Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.errorTint,
                    borderRadius: AppRadii.mdBorder,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          submissionError!,
                          style: AppTypography.bodySmBn().copyWith(
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
              SubmitButton(
                label: 'আপনার মতামত জমা দিন →',
                isLoading: submitting,
                onPressed: onSubmit,
              ),
              const SizedBox(height: 12),
              Text(
                'আপনার তথ্য নিরাপদ — শুধু product improvement-এর '
                'জন্য ব্যবহার হবে।',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 12,
                  color: roles.fgTertiary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  static InputDecoration _decoration(
    BuildContext context, {
    required String hint,
  }) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyBn().copyWith(
        fontSize: 14,
        color: roles.fgTertiary,
      ),
      filled: true,
      fillColor: roles.bgSurface2,
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: roles.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: roles.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.brandEmerald),
      ),
    );
  }
}

class _PlainTextField extends StatelessWidget {
  const _PlainTextField({
    required this.controller,
    required this.hintBn,
    required this.textInputType,
  });

  final TextEditingController controller;
  final String hintBn;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      style: AppTypography.bodyBn().copyWith(
        fontSize: 15,
        color: roles.fgPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintBn,
        hintStyle: AppTypography.bodyBn().copyWith(
          fontSize: 15,
          color: roles.fgTertiary,
        ),
        filled: true,
        fillColor: roles.bgSurface2,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: roles.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: roles.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandEmerald),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    AppColors.brandEmeraldHeroLight1,
                    AppColors.brandEmerald,
                    AppColors.brandEmeraldHeroLight3,
                  ],
                  stops: <double>[0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            right: -90,
            top: -90,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Color(0x66D4AF37),
                      Color(0x00D4AF37),
                    ],
                    stops: <double>[0.0, 0.7],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: Colors.white.withValues(alpha: 0.18),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onBack,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 12, 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.30),
                        ),
                        borderRadius: AppRadii.pillBorder,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.brandGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'শীঘ্রই আসছে · COMING SOON',
                            style: AppTypography.captionEn().copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'BongoCal Pro',
                      style: AppTypography.h1En().copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.28,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'আপনার মতামত জানান',
                      style: AppTypography.h1Bn().copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.28,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'তিন ক্যালেন্ডার, এক জায়গায় — এখন Pro features '
                      'আসছে। Launch-এর আগে আপনার মতামত জানতে চাই।',
                      style: AppTypography.bodyBn().copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: AppRadii.pillBorder,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'মাত্র ১ মিনিট সময় দিন',
                            style: AppTypography.bodySmBn().copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.brandGold.withValues(alpha: 0.18),
        borderRadius: AppRadii.pillBorder,
      ),
      child: Text(
        'জনপ্রিয়',
        style: AppTypography.bodySmBn().copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.brandGold700,
        ),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.brandEmerald,
                    AppColors.brandGold,
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x4D006A4E),
                    offset: Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'ধন্যবাদ!',
              style: AppTypography.h1Bn().copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: roles.fgPrimary,
                letterSpacing: -0.34,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'আপনার মতামত পেয়েছি। Launch হলে সবার আগে email-এ '
              'জানাব। ইনশাআল্লাহ। 🌟',
              textAlign: TextAlign.center,
              style: AppTypography.bodyBn().copyWith(
                fontSize: 15,
                height: 1.6,
                color: roles.fgSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/settings');
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandEmerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'ফিরে যান',
                  style: AppTypography.bodyBn().copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
