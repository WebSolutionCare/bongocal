function SettingsScreen() {
  const [lang, setLang] = React.useState('bn');
  const [bnNumerals, setBnNumerals] = React.useState(true);
  const [hijri, setHijri] = React.useState(true);
  const [notif, setNotif] = React.useState(true);

  return (
    <div style={{ height: '100%', overflowY: 'auto', paddingBottom: 100 }}>
      <div style={{ padding: '12px 20px 12px' }}>
        <div style={{ fontSize: 26, fontWeight: 700 }}>সেটিংস</div>
      </div>

      <Group title="ভাষা">
        <Row label="অ্যাপের ভাষা">
          <Segmented value={lang} onChange={setLang} options={[
            { v: 'bn', label: 'বাংলা' }, { v: 'en', label: 'English' },
          ]}/>
        </Row>
        <Row label="বাংলা সংখ্যা ব্যবহার করুন" sub="০ ১ ২ ৩ vs 0 1 2 3">
          <Toggle on={bnNumerals} onChange={setBnNumerals} />
        </Row>
      </Group>

      <Group title="ক্যালেন্ডার">
        <Row label="বাংলা ক্যালেন্ডার" sub="বঙ্গাব্দ"><Toggle on={true} onChange={()=>{}} /></Row>
        <Row label="হিজরি ক্যালেন্ডার" sub="চান্দ্র মাস"><Toggle on={hijri} onChange={setHijri} /></Row>
        <Row label="ছুটির দিন হাইলাইট"><Toggle on={true} onChange={()=>{}} /></Row>
      </Group>

      <Group title="নোটিফিকেশন">
        <Row label="ছুটি ও উৎসবের রিমাইন্ডার"><Toggle on={notif} onChange={setNotif} /></Row>
        <Row label="দৈনিক সারাংশ" sub="প্রতিদিন সকাল ৭টায়"><Toggle on={false} onChange={()=>{}} /></Row>
      </Group>

      <Group title="সম্পর্কে">
        <LinkRow label="গোপনীয়তা নীতি"/>
        <LinkRow label="পরিষেবার শর্তাবলী"/>
        <LinkRow label="সংস্করণ" trail="1.0.0 (240426)"/>
      </Group>
    </div>
  );
}

function Group({ title, children }) {
  return (
    <div style={{ padding: '14px 16px 4px' }}>
      <div style={{
        fontSize: 11, fontWeight: 600, color: 'var(--fg-tertiary)',
        textTransform: 'uppercase', letterSpacing: '0.06em',
        fontFamily: 'var(--font-latin)', marginBottom: 8, paddingLeft: 4,
      }}>{title}</div>
      <div style={{
        background: 'var(--bg-surface)', border: '1px solid var(--border-subtle)',
        borderRadius: 14, overflow: 'hidden',
      }}>{children}</div>
    </div>
  );
}

function Row({ label, sub, children }) {
  return (
    <div style={{
      padding: '14px 14px',
      borderBottom: '1px solid var(--border-subtle)',
      display: 'flex', alignItems: 'center', gap: 12,
    }}>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 14, fontWeight: 500, color: 'var(--fg-primary)' }}>{label}</div>
        {sub && <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', marginTop: 1 }}>{sub}</div>}
      </div>
      {children}
    </div>
  );
}

function LinkRow({ label, trail }) {
  return (
    <div style={{
      padding: '14px 14px', borderBottom: '1px solid var(--border-subtle)',
      display: 'flex', alignItems: 'center', gap: 12, cursor: 'pointer',
    }}>
      <div style={{ flex: 1, fontSize: 14, fontWeight: 500 }}>{label}</div>
      {trail && <div style={{ fontSize: 12, color: 'var(--fg-tertiary)', fontFamily: 'var(--font-latin)' }}>{trail}</div>}
      <Icon name="chevron-right" size={18} style={{ color: 'var(--fg-tertiary)' }} />
    </div>
  );
}

function Toggle({ on, onChange }) {
  return (
    <button onClick={() => onChange(!on)} style={{
      width: 50, height: 30, borderRadius: 999, border: 0, cursor: 'pointer', padding: 0,
      background: on ? 'var(--brand-emerald)' : 'var(--gray-300)',
      position: 'relative', transition: 'background 200ms',
    }}>
      <span style={{
        position: 'absolute', top: 2, left: on ? 22 : 2, width: 26, height: 26, borderRadius: 999,
        background: '#fff', boxShadow: '0 1px 2px rgba(0,0,0,.2)',
        transition: 'left 220ms cubic-bezier(.32,.72,0,1)',
      }}/>
    </button>
  );
}

function Segmented({ value, onChange, options }) {
  return (
    <div style={{
      display: 'inline-flex', background: 'var(--bg-surface-2)', borderRadius: 8, padding: 2,
    }}>
      {options.map(o => (
        <button key={o.v} onClick={() => onChange(o.v)} style={{
          padding: '6px 12px', borderRadius: 6, border: 0, cursor: 'pointer',
          fontFamily: 'var(--font-bangla)', fontSize: 13, fontWeight: 600,
          background: value === o.v ? 'var(--bg-elevated)' : 'transparent',
          color: value === o.v ? 'var(--fg-primary)' : 'var(--fg-tertiary)',
          boxShadow: value === o.v ? 'var(--shadow-xs)' : 'none',
          transition: 'all 160ms',
        }}>{o.label}</button>
      ))}
    </div>
  );
}

window.SettingsScreen = SettingsScreen;
