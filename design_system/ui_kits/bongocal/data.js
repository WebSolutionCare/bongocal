// Static fake data for the BongoCal UI kit demo.
// Hardcoded around April 2026 / Boishakh 1432.

export const MONTHS_BN = ['জানুয়ারি','ফেব্রুয়ারি','মার্চ','এপ্রিল','মে','জুন','জুলাই','আগস্ট','সেপ্টেম্বর','অক্টোবর','নভেম্বর','ডিসেম্বর'];
export const WEEKDAYS_BN = ['শনি','রবি','সোম','মঙ্গল','বুধ','বৃহঃ','শুক্র'];

export const TODAY = { day: 27, weekdayIndex: 3 /* Mon (Sat-first) */ };

// April 1, 2026 falls on Wednesday; in a Sat-first grid that's column 4.
export const APRIL_LEAD_BLANKS = 4;
export const APRIL_DAYS = 30;

// Marked dates within the displayed month
export const MARKS = {
  5:  { kind: 'festival', label: 'বৌদ্ধ পূর্ণিমা', color: 'gold' },
  14: { kind: 'holiday',  label: 'পহেলা বৈশাখ',    color: 'red' },
  21: { kind: 'event',    label: 'টিম মিটিং' },
  27: { kind: 'today',    label: 'আজ' },
};

export const TODAY_EVENTS = [
  { time: '১০:০০', title: 'টিম মিটিং', location: 'অফিস · বনানী', color: 'emerald' },
  { time: '১৩:৩০', title: 'লাঞ্চ — রাহাত ভাই', location: 'ধানমন্ডি ৩২', color: 'gold' },
  { time: '১৯:৩০', title: 'পরিবারের সাথে রাতের খাবার', location: 'বাসা', color: 'red' },
];

export const UPCOMING_FESTIVALS = [
  { id: 'boishakh', name: 'পহেলা বৈশাখ', date: '১৪ এপ্রিল', sub: 'নববর্ষ ১৪৩৩ · সরকারি ছুটি', tone: 'boishakh', daysAway: 18 },
  { id: 'eid',      name: 'ঈদুল আজহা',  date: '৩১ মে',     sub: 'ঈদুল আজহা · ১০ যিলহজ্জ',    tone: 'eid',      daysAway: 34 },
  { id: 'indep',    name: 'স্বাধীনতা দিবস', date: '২৬ মার্চ', sub: 'জাতীয় দিবস',                  tone: 'independence', daysAway: 333 },
];
