/// Whether the respondent wants to test the Pro beta. Single-select.
enum BetaInterest { yes, maybe, no }

extension BetaInterestX on BetaInterest {
  String get displayBn {
    switch (this) {
      case BetaInterest.yes:
        return 'হ্যাঁ, আগ্রহী';
      case BetaInterest.maybe:
        return 'হয়তো';
      case BetaInterest.no:
        return 'না';
    }
  }

  String get sheetKey {
    switch (this) {
      case BetaInterest.yes:
        return 'yes';
      case BetaInterest.maybe:
        return 'maybe';
      case BetaInterest.no:
        return 'no';
    }
  }
}
