function MonthView({ onSelectDay, onOpenFestival }) {
  const data = window.__BONGOCAL_DATA__;
  const banglaDigits = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
  const toBn = n => String(n).split('').map(d => banglaDigits[+d] ?? d).join('');

  const lead = [28, 29, 30, 31];
  const days = Array.from({ length: 30 }, (_, i) => i + 1);
  const trail = [1, 2, 3, 4, 5];
  const cells = [
    ...lead.map(n => ({ n, dim: true })),
    ...days.map(n => ({ n })),
    ...trail.map(n => ({ n, dim: true })),
  ].slice(0, 35);

  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 100 }}>
      <AppBar
        title="এপ্রিল"
        subtitle="১৪৩২ বঙ্গাব্দ · ১৪৪৭ হিজরি"
      />

      {/* Weekday header */}
      <div style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 4 }}>
        {data.WEEKDAYS_BN.map(d => (
          <div key={d} style={{
            textAlign: 'center', fontSize: 10, fontWeight: 600,
            color: 'var(--fg-tertiary)', letterSpacing: '0.04em',
            paddingBottom: 6,
          }}>{d}</div>
        ))}
      </div>

      {/* Grid */}
      <div style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 4 }}>
        {cells.map((c, i) => {
          const mark = !c.dim ? data.MARKS[c.n]?.kind : null;
          return (
            <DateCell
              key={i}
              day={c.n}
              banglaDay={!c.dim ? toBn(((c.n - 14 + 30) % 30) + 1) : ''}
              mark={mark}
              dim={c.dim}
              onClick={() => !c.dim && onSelectDay(c.n)}
            />
          );
        })}
      </div>

      {/* Today summary */}
      <div style={{ padding: '20px 16px 8px' }}>
        <div style={{ fontSize: 11, fontWeight: 600, color: 'var(--fg-tertiary)',
                      textTransform: 'uppercase', letterSpacing: '0.06em',
                      fontFamily: 'var(--font-latin)', marginBottom: 10 }}>
          আজ · 27 April
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {data.TODAY_EVENTS.map((ev, i) => (
            <div key={i} style={{
              background: 'var(--bg-surface)', border: '1px solid var(--border-subtle)',
              borderRadius: 12, padding: '12px 14px',
              display: 'flex', alignItems: 'center', gap: 12,
              boxShadow: 'var(--shadow-xs)',
            }}>
              <span style={{
                width: 8, height: 8, borderRadius: 999, flexShrink: 0,
                background: ev.color === 'red' ? 'var(--brand-red)'
                          : ev.color === 'gold' ? 'var(--brand-gold)'
                          : 'var(--brand-emerald)',
              }} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--fg-primary)' }}>{ev.title}</div>
                <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', marginTop: 1 }}>{ev.location}</div>
              </div>
              <div style={{ fontFamily: 'var(--font-bangla)', fontSize: 12, color: 'var(--fg-secondary)', fontWeight: 600 }}>{ev.time}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Upcoming festival prompt */}
      <div style={{ padding: '16px 16px 24px' }}>
        <button onClick={() => onOpenFestival('boishakh')} style={{
          width: '100%', textAlign: 'left', cursor: 'pointer',
          background: 'radial-gradient(circle at 100% 0%, rgba(212,175,55,0.18) 0%, transparent 55%), var(--bg-surface)',
          border: '1px solid var(--brand-gold-100)',
          borderRadius: 16, padding: 16,
          display: 'flex', alignItems: 'center', gap: 12,
          fontFamily: 'var(--font-bangla)',
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 12,
            background: 'var(--brand-red)', color: '#fff',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            flexShrink: 0,
          }}>
            <Icon name="sparkles" size={22} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 15, fontWeight: 600, color: 'var(--fg-primary)' }}>পহেলা বৈশাখ</div>
            <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', marginTop: 2 }}>১৮ দিন বাকি · নববর্ষ ১৪৩৩</div>
          </div>
          <Icon name="chevron-right" size={20} style={{ color: 'var(--fg-tertiary)' }} />
        </button>
      </div>
    </div>
  );
}
window.MonthView = MonthView;
