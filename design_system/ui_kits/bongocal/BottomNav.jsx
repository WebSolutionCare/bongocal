function BottomNav({ active, onChange }) {
  const items = [
    { id: 'calendar',  label: 'ক্যালেন্ডার', icon: 'calendar' },
    { id: 'events',    label: 'অনুষ্ঠান',    icon: 'check' },
    { id: 'festivals', label: 'উৎসব',        icon: 'sparkles' },
    { id: 'settings',  label: 'সেটিংস',     icon: 'settings' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0,
      height: 80, paddingBottom: 18,
      display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
      borderTop: '1px solid var(--border-subtle)',
      background: 'color-mix(in oklab, var(--bg-surface) 88%, transparent)',
      backdropFilter: 'saturate(160%) blur(20px)',
      WebkitBackdropFilter: 'saturate(160%) blur(20px)',
    }}>
      {items.map(it => (
        <button key={it.id} onClick={() => onChange(it.id)} style={{
          background: 'transparent', border: 0, cursor: 'pointer',
          display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
          gap: 4,
          color: active === it.id ? 'var(--brand-emerald)' : 'var(--fg-tertiary)',
          fontSize: 10, fontWeight: 600, fontFamily: 'var(--font-bangla)',
          transition: 'color 120ms',
        }}>
          <Icon name={it.icon} size={22} style={{ strokeWidth: active === it.id ? 1.8 : 1.5 }} />
          <span>{it.label}</span>
        </button>
      ))}
    </div>
  );
}
window.BottomNav = BottomNav;
