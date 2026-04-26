function App() {
  const [tab, setTab] = React.useState('calendar');
  const [selectedDay, setSelectedDay] = React.useState(null);
  const [festivalView, setFestivalView] = React.useState(false);

  let body;
  if (tab === 'calendar') {
    body = <MonthView onSelectDay={setSelectedDay} onOpenFestival={() => setTab('festivals')} />;
  } else if (tab === 'festivals') {
    body = <FestivalScreen onBack={() => setTab('calendar')} />;
  } else if (tab === 'settings') {
    body = <SettingsScreen />;
  } else {
    body = <EventsScreen />;
  }

  return (
    <Frame>
      {body}
      <BottomNav active={tab} onChange={setTab} />
      {selectedDay !== null && (
        <DaySheet day={selectedDay} onClose={() => setSelectedDay(null)} />
      )}
    </Frame>
  );
}

function EventsScreen() {
  const events = window.__BONGOCAL_DATA__.TODAY_EVENTS;
  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 100 }}>
      <div style={{ padding: '12px 20px 12px' }}>
        <div style={{ fontSize: 26, fontWeight: 700 }}>অনুষ্ঠান</div>
        <div style={{ fontSize: 12, color: 'var(--fg-tertiary)' }}>আজ ও আসন্ন</div>
      </div>
      <div style={{ padding: '0 16px', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {events.map((ev, i) => (
          <div key={i} style={{
            background: 'var(--bg-surface)', border: '1px solid var(--border-subtle)',
            borderRadius: 14, padding: 14,
            display: 'flex', alignItems: 'center', gap: 12,
            boxShadow: 'var(--shadow-xs)',
          }}>
            <div style={{
              width: 48, height: 48, borderRadius: 12,
              background: 'var(--brand-emerald-50)', color: 'var(--brand-emerald)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontFamily: 'var(--font-bangla)', fontWeight: 700, fontSize: 13, textAlign: 'center', lineHeight: 1.1,
            }}>
              <div>
                <div>{ev.time}</div>
              </div>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 15, fontWeight: 600 }}>{ev.title}</div>
              <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', marginTop: 2 }}>{ev.location}</div>
            </div>
          </div>
        ))}
      </div>
      {/* FAB */}
      <button style={{
        position: 'absolute', right: 18, bottom: 100,
        width: 56, height: 56, borderRadius: 999,
        background: 'var(--brand-emerald)', color: '#fff', border: 0,
        boxShadow: 'var(--shadow-lg)', cursor: 'pointer',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <Icon name="plus" size={26} />
      </button>
    </div>
  );
}

window.App = App;
