function DateCell({ day, banglaDay, mark, dim, selected, onClick }) {
  const [hover, setHover] = React.useState(false);
  const [pressed, setPressed] = React.useState(false);

  const isToday = mark === 'today';
  const isHoliday = mark === 'holiday';
  const isFestival = mark === 'festival';
  const isEvent = mark === 'event';

  let bg = 'transparent';
  let border = '1px solid transparent';
  let numColor = 'var(--fg-primary)';
  let subColor = 'var(--fg-tertiary)';

  if (isToday) { bg = 'var(--brand-emerald)'; numColor = '#fff'; subColor = 'rgba(255,255,255,0.85)'; }
  else if (selected) { bg = 'var(--brand-emerald-50)'; border = '1px solid var(--brand-emerald)'; }
  else if (hover) { bg = 'var(--bg-surface-2)'; }

  if (isHoliday && !isToday) numColor = 'var(--brand-red)';
  if (dim) { numColor = 'var(--gray-300)'; subColor = 'var(--gray-300)'; }

  return (
    <button
      onClick={onClick}
      onMouseEnter={() => setHover(true)} onMouseLeave={() => { setHover(false); setPressed(false); }}
      onMouseDown={() => setPressed(true)} onMouseUp={() => setPressed(false)}
      style={{
        height: 56, width: '100%',
        borderRadius: 10, border,
        background: bg, padding: 0, cursor: 'pointer',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        gap: 1,
        transition: 'all 120ms cubic-bezier(.2,0,0,1)',
        transform: pressed ? 'scale(0.96)' : 'scale(1)',
        position: 'relative',
      }}>
      <span style={{ fontFamily: 'var(--font-latin)', fontSize: 16, fontWeight: 600, color: numColor, fontVariantNumeric: 'tabular-nums', lineHeight: 1 }}>
        {day}
      </span>
      {!dim && banglaDay && (
        <span style={{ fontFamily: 'var(--font-bangla)', fontSize: 10, color: subColor, lineHeight: 1.1 }}>
          {banglaDay}
        </span>
      )}
      {(isHoliday || isFestival || isEvent) && !isToday && (
        <span style={{
          position: 'absolute', bottom: 6,
          width: 5, height: 5, borderRadius: 999,
          background: isFestival ? 'var(--brand-gold)' : isEvent ? 'var(--brand-emerald)' : 'var(--brand-red)',
        }} />
      )}
      {isToday && (
        <span style={{
          position: 'absolute', bottom: 6,
          width: 5, height: 5, borderRadius: 999, background: '#fff', opacity: 0.9,
        }} />
      )}
    </button>
  );
}
window.DateCell = DateCell;
