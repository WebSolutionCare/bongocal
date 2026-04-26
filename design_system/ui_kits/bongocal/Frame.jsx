// iPhone-shaped frame at 390×844 with status bar + home indicator
function Frame({ children }) {
  return (
    <div style={{
      width: 390, height: 844,
      background: 'var(--bg-canvas)',
      borderRadius: 50,
      border: '10px solid #1A1A18',
      boxShadow: 'var(--shadow-lg)',
      overflow: 'hidden',
      position: 'relative',
      fontFamily: 'var(--font-bangla)',
      color: 'var(--fg-primary)',
    }}>
      {/* Status bar */}
      <div style={{
        height: 47, padding: '0 30px',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        fontFamily: 'var(--font-latin)', fontSize: 15, fontWeight: 600,
        position: 'relative', zIndex: 5,
      }}>
        <span>9:41</span>
        {/* Dynamic island spacer */}
        <div style={{
          position: 'absolute', left: '50%', top: 8,
          transform: 'translateX(-50%)',
          width: 110, height: 32, background: '#000', borderRadius: 999,
        }} />
        <span style={{ display: 'inline-flex', gap: 6, alignItems: 'center', color: 'var(--fg-primary)' }}>
          {/* Signal */}
          <svg width="16" height="11" viewBox="0 0 16 11" fill="currentColor">
            <rect x="0" y="7" width="3" height="4" rx="1"/>
            <rect x="4" y="5" width="3" height="6" rx="1"/>
            <rect x="8" y="3" width="3" height="8" rx="1"/>
            <rect x="12" y="0" width="3" height="11" rx="1"/>
          </svg>
          {/* Battery */}
          <svg width="22" height="11" viewBox="0 0 22 11" fill="none" stroke="currentColor" strokeWidth="1">
            <rect x="0.5" y="0.5" width="18" height="10" rx="2.5"/>
            <rect x="2" y="2" width="13" height="7" rx="1.2" fill="currentColor"/>
            <rect x="19.5" y="3" width="1.5" height="5" rx="0.5" fill="currentColor"/>
          </svg>
        </span>
      </div>
      {/* App content */}
      <div style={{ height: 'calc(100% - 47px)', position: 'relative' }}>
        {children}
      </div>
      {/* Home indicator */}
      <div style={{
        position: 'absolute', bottom: 8, left: '50%',
        transform: 'translateX(-50%)',
        width: 134, height: 5, borderRadius: 999,
        background: 'var(--fg-primary)', opacity: 0.85,
      }} />
    </div>
  );
}
window.Frame = Frame;
