function FestivalScreen({ onBack }) {
  const fest = window.__BONGOCAL_DATA__.UPCOMING_FESTIVALS;
  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 100 }}>
      <div style={{ padding: '8px 12px 12px', display: 'flex', alignItems: 'center', gap: 4 }}>
        <button onClick={onBack} style={{
          width: 38, height: 38, borderRadius: 999, background: 'transparent', border: 0,
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
          color: 'var(--fg-primary)',
        }}>
          <Icon name="chevron-left" size={22} />
        </button>
        <div style={{ fontSize: 18, fontWeight: 700 }}>উৎসব</div>
      </div>

      {/* Hero */}
      <div style={{ padding: '0 16px' }}>
        <div style={{
          position: 'relative', overflow: 'hidden',
          borderRadius: 20, padding: 22,
          background: 'linear-gradient(135deg, #006A4E 0%, #005A42 60%, #007558 100%)',
          color: '#fff',
          boxShadow: 'var(--shadow-md)',
        }}>
          <div style={{
            position: 'absolute', right: -50, bottom: -50, width: 220, height: 220,
            borderRadius: 999, pointerEvents: 'none',
            background: 'radial-gradient(circle, rgba(212,175,55,0.30) 0%, transparent 65%)',
          }} />
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 14 }}>
            <span style={{
              padding: '4px 10px', borderRadius: 999, fontSize: 11, fontWeight: 600,
              background: 'rgba(212,175,55,0.25)', color: '#F5EBC4',
              border: '1px solid rgba(212,175,55,0.5)',
            }}>✦ আসন্ন</span>
          </div>
          <div style={{ fontSize: 32, fontWeight: 700, letterSpacing: '-0.005em' }}>পহেলা বৈশাখ</div>
          <div style={{ fontSize: 14, opacity: 0.85, marginTop: 6 }}>নববর্ষ ১৪৩৩ · সরকারি ছুটি</div>
          <div style={{ height: 1, background: 'rgba(255,255,255,0.16)', margin: '18px 0' }} />
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, fontSize: 12 }}>
            <div>
              <div style={{ opacity: 0.7 }}>তারিখ</div>
              <div style={{ fontWeight: 600, marginTop: 2 }}>১ বৈশাখ ১৪৩৩</div>
              <div style={{ opacity: 0.7, fontFamily: 'var(--font-latin)', fontSize: 11, marginTop: 2 }}>14 April 2026</div>
            </div>
            <div>
              <div style={{ opacity: 0.7 }}>বাকি</div>
              <div style={{ fontFamily: 'var(--font-latin)', fontSize: 22, fontWeight: 700, marginTop: 0 }}>18</div>
              <div style={{ opacity: 0.7, fontSize: 11 }}>দিন</div>
            </div>
          </div>
        </div>
      </div>

      {/* List */}
      <div style={{ padding: '24px 16px 8px' }}>
        <div style={{
          fontSize: 11, fontWeight: 600, color: 'var(--fg-tertiary)',
          textTransform: 'uppercase', letterSpacing: '0.06em',
          fontFamily: 'var(--font-latin)', marginBottom: 10,
        }}>সকল উৎসব · ২০২৬</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {fest.map(f => {
            const tone = f.tone === 'eid' ? { bg: 'var(--brand-gold-100)', fg: 'var(--brand-gold-700)', dot: 'var(--brand-gold)' }
                       : f.tone === 'boishakh' ? { bg: 'var(--brand-red-100)', fg: 'var(--brand-red-700)', dot: 'var(--brand-red)' }
                       : { bg: 'var(--brand-emerald-100)', fg: 'var(--brand-emerald-700)', dot: 'var(--brand-emerald)' };
            return (
              <div key={f.id} style={{
                background: 'var(--bg-surface)', border: '1px solid var(--border-subtle)',
                borderRadius: 12, padding: '14px 14px',
                display: 'flex', alignItems: 'center', gap: 12,
                boxShadow: 'var(--shadow-xs)',
              }}>
                <div style={{
                  width: 44, height: 44, borderRadius: 12,
                  background: tone.bg, color: tone.fg,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  flexShrink: 0, fontWeight: 700, fontSize: 11, textAlign: 'center', lineHeight: 1.1,
                }}>
                  {f.date.split(' ').map((s, i) => <div key={i}>{s}</div>)}
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 15, fontWeight: 600, color: 'var(--fg-primary)' }}>{f.name}</div>
                  <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', marginTop: 1 }}>{f.sub}</div>
                </div>
                <div style={{ fontFamily: 'var(--font-latin)', fontSize: 12, color: 'var(--fg-tertiary)', fontWeight: 600 }}>
                  {f.daysAway}d
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
window.FestivalScreen = FestivalScreen;
