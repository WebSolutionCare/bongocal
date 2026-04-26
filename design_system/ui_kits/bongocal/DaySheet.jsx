function DaySheet({ day, onClose }) {
  const banglaDigits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
  const toBn = n => String(n).split('').map(d => banglaDigits[+d] ?? d).join('');
  const banglaDay = toBn(((day - 14 + 30) % 30) + 1);
  const hijriDay = toBn(((day - 18 + 30) % 30) + 1);
  const isToday = day === 27;

  return (
    <>
      {/* Scrim */}
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0, background: 'var(--bg-scrim)',
        zIndex: 20, animation: 'fadeIn 220ms ease-out',
      }} />
      {/* Sheet */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 21,
        background: 'var(--bg-surface)',
        borderRadius: '20px 20px 0 0',
        padding: '12px 20px 28px',
        boxShadow: 'var(--shadow-lg)',
        animation: 'sheetUp 280ms cubic-bezier(.32,.72,0,1)',
        fontFamily: 'var(--font-bangla)',
      }}>
        <div style={{
          width: 36, height: 4, borderRadius: 999, background: 'var(--gray-300)',
          margin: '0 auto 14px',
        }} />
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 4 }}>
          <div style={{ fontFamily: 'var(--font-latin)', fontSize: 36, fontWeight: 700, letterSpacing: '-0.02em', color: 'var(--fg-primary)' }}>
            {day}
          </div>
          {isToday && (
            <span style={{
              padding: '4px 10px', borderRadius: 999, fontSize: 11, fontWeight: 600,
              background: 'var(--brand-emerald-50)', color: 'var(--brand-emerald)',
            }}>আজ</span>
          )}
        </div>
        <div style={{ fontSize: 14, color: 'var(--fg-secondary)' }}>এপ্রিল ২০২৬ · সোমবার</div>

        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8,
          marginTop: 16,
        }}>
          {[
            { lab: 'বাংলা', val: `${banglaDay} বৈশাখ`, sub: '১৪৩২' },
            { lab: 'English', val: `${day} April`, sub: '2026', latin: true },
            { lab: 'হিজরি', val: `${hijriDay} যিলক্বদ`, sub: '১৪৪৭' },
          ].map((c, i) => (
            <div key={i} style={{
              background: 'var(--bg-surface-2)', borderRadius: 12, padding: '10px 12px',
            }}>
              <div style={{
                fontSize: 10, fontWeight: 600, color: 'var(--fg-tertiary)',
                textTransform: 'uppercase', letterSpacing: '0.04em',
                fontFamily: 'var(--font-latin)',
              }}>{c.lab}</div>
              <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--fg-primary)', marginTop: 4, fontFamily: c.latin ? 'var(--font-latin)' : 'var(--font-bangla)' }}>{c.val}</div>
              <div style={{ fontSize: 11, color: 'var(--fg-tertiary)', marginTop: 2, fontFamily: c.latin ? 'var(--font-latin)' : 'var(--font-bangla)' }}>{c.sub}</div>
            </div>
          ))}
        </div>

        <div style={{ marginTop: 16, fontSize: 12, fontWeight: 600, color: 'var(--fg-tertiary)', textTransform: 'uppercase', letterSpacing: '0.06em', fontFamily: 'var(--font-latin)' }}>
          Events · ৩
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6, marginTop: 8 }}>
          {window.__BONGOCAL_DATA__.TODAY_EVENTS.map((ev, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '8px 10px', background: 'var(--bg-surface-2)', borderRadius: 10 }}>
              <span style={{ width: 6, height: 6, borderRadius: 999, background: 'var(--brand-emerald)' }} />
              <div style={{ fontSize: 13, fontWeight: 500, flex: 1 }}>{ev.title}</div>
              <div style={{ fontSize: 12, color: 'var(--fg-tertiary)' }}>{ev.time}</div>
            </div>
          ))}
        </div>

        <div style={{ display: 'flex', gap: 8, marginTop: 18 }}>
          <button onClick={onClose} style={{
            flex: 1, height: 44, borderRadius: 10,
            background: 'var(--bg-surface-2)', color: 'var(--fg-primary)',
            border: '1px solid var(--border-default)',
            fontFamily: 'var(--font-bangla)', fontSize: 15, fontWeight: 600, cursor: 'pointer',
          }}>বাতিল</button>
          <button style={{
            flex: 1, height: 44, borderRadius: 10,
            background: 'var(--brand-emerald)', color: '#fff', border: 0,
            fontFamily: 'var(--font-bangla)', fontSize: 15, fontWeight: 600, cursor: 'pointer',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          }}>
            <Icon name="plus" size={18} /> অনুষ্ঠান যোগ
          </button>
        </div>
      </div>
      <style>{`
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes sheetUp { from { transform: translateY(100%); } to { transform: translateY(0); } }
      `}</style>
    </>
  );
}
window.DaySheet = DaySheet;
