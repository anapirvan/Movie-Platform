import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { clientsApi } from '../api';
import type { RecommandationResponse } from '../types/movies';

export default function RecommendationsPage() {
  const [recos,   setRecos]   = useState<RecommandationResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    clientsApi.getClientRecommandations()
      .then(setRecos)
      .catch(() => setError('Nu s-au putut încărca recomandările.'))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Recomandări</h1>
        <p className="page-subtitle">Filme selectate pe baza profilului tău</p>
      </div>

      {loading && (
        <div className="state-loading"><div className="state-spinner" />Se calculează recomandările...</div>
      )}
      {error && <div className="state-error">{error}</div>}
      {!loading && !error && recos.length === 0 && (
        <div className="state-empty">Nu există recomandări momentan. Vizionează mai multe filme!</div>
      )}

      <div className="reco-list">
        {recos.map((r, idx) => (
          <div
            key={r.filmId}
            className="reco-card"
            onClick={() => navigate(`/movies/${r.filmId}`)}
          >
            <div className="reco-info">
              <div className="reco-rank">#{idx + 1}</div>
              <div>
                <div className="reco-title">{r.titlu}</div>
                <div className="reco-meta">
                  {r.dataLansare?.slice(0, 4)} &nbsp;·&nbsp; {r.categorii}
                </div>
              </div>
            </div>
            <div style={{ display: 'flex', gap: 16, alignItems: 'center' }}>
              <div className="reco-score">
                <div className="reco-score-value">{r.scorRelevanta}</div>
                <div className="reco-score-label">relevanță</div>
              </div>
              <div>
                <span className="rating-badge">★ {r.rating?.toFixed(1)}</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
