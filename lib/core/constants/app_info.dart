/// App-wide constants (display name, supported locales, etc.).
class AppInfo {
  const AppInfo._();

  /// Canonical app name — keep in lock-step with `android:label` in
  /// `AndroidManifest.xml` and the splash wordmark.
  static const String appName = 'BongoCal';

  static const String displayNameBn = 'বঙ্গক্যাল';
  static const String displayNameEn = appName;

  /// Tagline used on splash and onboarding.
  static const String taglineBn = 'তিন ক্যালেন্ডার, এক জায়গায়';
  static const String taglineEn = 'Three calendars, one place.';

  /// Google Apps Script Web App that receives Pro-interest form
  /// submissions and appends them to the demand-validation Sheet.
  ///
  /// Re-deploy the Apps Script when its body changes; the deployment URL
  /// rotates with each new "version" so this constant must be updated in
  /// lock-step.
  static const String proInterestEndpoint =
      'https://script.google.com/macros/s/AKfycbx1kV0BZL6KW5bK_VG4GJERtP72xozk-WO0A3bVX0J5d_oYK6TAFKSdhDEGdOWjcD9z/exec';

  /// True when the [proInterestEndpoint] has not been configured. Used
  /// by the data layer to short-circuit with a friendly error in dev
  /// builds rather than failing on `Uri.parse`.
  static bool get isProInterestEndpointConfigured =>
      !proInterestEndpoint.contains('PASTE_YOUR_');
}
