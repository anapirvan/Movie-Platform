import { useEffect, useState } from 'react';
import { clientsApi } from '../api';
import type { ClientProfileResponse } from '../types/clients';

export default function ProfilePage() {
  const [profile, setProfile] = useState<ClientProfileResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');

  useEffect(() => {
    clientsApi.getClientProfile()
      .then(setProfile)
      .catch(() => setError('Nu s-a putut încărca profilul.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return (
    <div className="page">
      <div className="state-loading"><div className="state-spinner" />Se încarcă profilul...</div>
    </div>
  );
  if (error || !profile) return <div className="page"><div className="state-error">{error || 'Eroare.'}</div></div>;

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Profilul meu</h1>
        {profile.sentimentDominant && (
          <p className="page-subtitle">
            Sentiment dominant:&nbsp;
            <span style={{ color: 'var(--blue-light)', fontFamily: 'var(--font-mono)' }}>
              {profile.sentimentDominant}
            </span>
          </p>
        )}
      </div>

      
      <div className="profile-grid" style={{ marginBottom: 28 }}>
        <div className="profile-stat-card">
          <div className="profile-stat-number">{profile.actoriPreferati?.length ?? 0}</div>
          <div className="profile-stat-label">Actori preferați</div>
        </div>
        <div className="profile-stat-card">
          <div className="profile-stat-number">{profile.categoriiPreferate?.length ?? 0}</div>
          <div className="profile-stat-label">Categorii preferate</div>
        </div>
      </div>

      
      {profile.categoriiPreferate?.length > 0 && (
        <div className="detail-section">
          <h2 className="section-title">Categorii preferate</h2>
          <div className="favorite-list">
            {profile.categoriiPreferate.map(c => (
              <div key={c.categorieId} className="favorite-item">
                <span className="favorite-item-name">{c.denumire}</span>
                <span className="favorite-item-count">{c.nrVizualizari} vizualizări</span>
              </div>
            ))}
          </div>
        </div>
      )}

      
      {profile.actoriPreferati?.length > 0 && (
        <div className="detail-section">
          <h2 className="section-title">Actori preferați</h2>
          <div className="favorite-list">
            {profile.actoriPreferati.map(a => (
              <div key={a.actorId} className="favorite-item">
                <span className="favorite-item-name">{a.numeComplet}</span>
                <span className="favorite-item-count">{a.nrFilmeVazute} filme văzute</span>
              </div>
            ))}
          </div>
        </div>
      )}

    
      {profile.istoric?.length > 0 && (
        <div className="detail-section">
          <h2 className="section-title">Istoric vizualizări ({profile.istoric.length})</h2>
          <div className="table-wrap">
            <table className="history-table">
              <thead>
                <tr>
                  <th>Film</th>
                  <th>Format</th>
                  <th>Limbă</th>
                  <th>Data</th>
                  <th>Durată (min)</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {profile.istoric.map(h => (
                  <tr key={h.vizualizareId}>
                    <td>{h.titlu}</td>
                    <td>{h.format}</td>
                    <td>{h.limba}</td>
                    <td>{h.dataVizualizare}</td>
                    <td>{h.durata}</td>
                    <td>
                      <span
                        className="meta-chip"
                        style={{
                          color: h.status === 'completed'
                            ? 'var(--positive)'
                            : h.status === 'abandoned'
                            ? 'var(--negative)'
                            : 'var(--text-dim)'
                        }}
                      >
                        {h.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
