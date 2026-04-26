function AppBar({ title, subtitle, onSearch, onBell }) {
  return (
    <div style={{
      padding: '8px 20px 12px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
    }}>
      <div>
        <div style={{ fontSize: 26, fontWeight: 700, letterSpacing: '-0.005em' }}>{title}</div>
        {subtitle && (
          <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', marginTop: 1 }}>{subtitle}</div>
        )}
      </div>
      <div style={{ display: 'flex', gap: 8 }}>
        <RoundIcon name="search" onClick={onSearch} />
        <RoundIcon name="bell" onClick={onBell} />
      </div>
    </div>
  );
}

function RoundIcon({ name, onClick }) {
  const [pressed, setPressed] = React.useState(false);
  return (
    <button
      onClick={onClick}
      onMouseDown={() => setPressed(true)} onMouseUp={() => setPressed(false)} onMouseLeave={() => setPressed(false)}
      style={{
        width: 38, height: 38, borderRadius: 999,
        background: 'var(--bg-surface-2)', border: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        color: 'var(--fg-secondary)', cursor: 'pointer',
        transition: 'transform 80ms cubic-bezier(.2,0,0,1), background 120ms',
        transform: pressed ? 'scale(0.94)' : 'scale(1)',
      }}>
      <Icon name={name} size={20} />
    </button>
  );
}

window.AppBar = AppBar;
