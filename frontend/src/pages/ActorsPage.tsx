import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { actorsApi } from '../api';
import type { ActorListResponse } from '../types/actors';

function avatarInitials(name: string) {
  return name.split(' ').slice(0, 2).map(w => w[0]).join('').toUpperCase();
}

export default function ActorsPage() {
  const [actors,  setActors]  = useState<ActorListResponse[]>([]);
  const [search,  setSearch]  = useState('');
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    actorsApi.getActors()
      .then(setActors)
      .catch(() => setError('Nu s-au putut încărca actorii.'))
      .finally(() => setLoading(false));
  }, []);

  const filtered = actors.filter(a =>
    a.numeComplet.toLowerCase().includes(search.toLowerCase()) ||
    a.numeScena?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Actori</h1>
        <p className="page-subtitle">{actors.length} actori în baza de date</p>
      </div>

      <div className="search-bar">
        <div className="search-input-wrap">
          <span className="search-icon">🔍</span>
          <input
            type="text"
            placeholder="Caută după nume..."
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
      </div>

      {loading && (
        <div className="state-loading"><div className="state-spinner" />Se încarcă actorii...</div>
      )}
      {error && <div className="state-error">{error}</div>}
      {!loading && !error && filtered.length === 0 && (
        <div className="state-empty">Niciun actor găsit.</div>
      )}

      <div className="actors-grid">
        {filtered.map(actor => (
          <div
            key={actor.actorId}
            className="actor-card"
            onClick={() => navigate(`/actors/${actor.actorId}`, { state: actor })}
          >
            <div className="actor-avatar">{avatarInitials(actor.numeComplet)}</div>
            <div>
              <div className="actor-card-name">{actor.numeComplet}</div>
              {actor.numeScena && (
                <div className="actor-card-stage">"{actor.numeScena}"</div>
              )}
              <div className="actor-card-movies">{actor.nrFilme} filme</div>
            </div>
            <div style={{ marginLeft: 'auto', fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--font-mono)' }}>
              {actor.dataNastere?.slice(0, 4) ?? ''}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
