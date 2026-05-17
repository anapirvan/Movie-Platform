import { useEffect, useState } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { actorsApi } from '../api';
import type { ActorListResponse } from '../types/actors';
import type { ActorFeelingResponse } from '../types/actors';

function sentimentClass(s: string) {
  const l = s?.toLowerCase();
  if (l === 'pozitiv') return 'pozitiv';
  if (l === 'negativ') return 'negativ';
  return 'neutru';
}

export default function ActorDetailPage() {
  const { id } = useParams<{ id: string }>();
  const actorId = Number(id);
  const navigate = useNavigate();
  const location = useLocation();

  // Actor basic info passed via navigation state from ActorsPage
  const actorInfo = location.state as ActorListResponse | null;

  const [feeling, setFeeling] = useState<ActorFeelingResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');

  useEffect(() => {
    actorsApi.getActorFeeling(actorId)
      .then(setFeeling)
      .catch(() => setError('Nu s-au putut încărca datele actorului.'))
      .finally(() => setLoading(false));
  }, [actorId]);

  return (
    <div className="page">
      <span className="back-link" onClick={() => navigate('/actors')} style={{ cursor: 'pointer' }}>
        ← Înapoi la actori
      </span>

      <div className="page-header">
        <h1 className="page-title">{actorInfo?.numeComplet ?? `Actor #${actorId}`}</h1>
        {actorInfo?.numeScena && (
          <p className="page-subtitle">Cunoscut ca "{actorInfo.numeScena}"</p>
        )}
        {actorInfo && (
          <div style={{ display: 'flex', gap: 10, marginTop: 10, flexWrap: 'wrap' }}>
            {actorInfo.dataNastere && (
              <span className="meta-chip">Născut: {actorInfo.dataNastere}</span>
            )}
            <span className="meta-chip">{actorInfo.nrFilme} filme</span>
          </div>
        )}
      </div>

      {loading && (
        <div className="state-loading"><div className="state-spinner" />Se încarcă sentimentele...</div>
      )}
      {error && <div className="state-error">{error}</div>}

      {!loading && !error && feeling && (
        <>
          <div className="detail-section">
            <h2 className="section-title">Sentiment public</h2>
            <div className="feeling-concluzie">{feeling.concluzie}</div>
          </div>

          {feeling.comentarii?.length > 0 && (
            <div className="detail-section">
              <h2 className="section-title">
                Comentarii despre actor ({feeling.comentarii.length})
              </h2>
              <div className="comment-list">
                {feeling.comentarii.map(c => (
                  <div key={c.comentariuId} className="comment-item">
                    <div className="comment-header">
                      <span className="comment-author">{c.client}</span>
                      <span className="comment-date">{c.dataComentariu}</span>
                      <span style={{ fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--font-mono)' }}>
                        {c.film}
                      </span>
                      {c.sentiment && (
                        <span className={`sentiment-badge ${sentimentClass(c.sentiment)}`}>
                          {c.sentiment}
                        </span>
                      )}
                    </div>
                    <p className="comment-text">{c.text}</p>
                  </div>
                ))}
              </div>
            </div>
          )}
        </>
      )}

      {!loading && !error && !feeling && (
        <div className="state-empty">Nu există date de sentiment pentru acest actor.</div>
      )}
    </div>
  );
}
