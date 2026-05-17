import { useEffect, useState, type FormEvent } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { moviesApi, commentsApi, interactionsApi } from '../api';
import { useAuth } from '../context/AuthContext';
import type { MovieDetailResponse, MovieFeelingResponse } from '../types/movies';
import type { OptionResponse } from '../types/interactions';

function sentimentClass(s: string) {
  const l = s?.toLowerCase();
  if (l === 'pozitiv') return 'pozitiv';
  if (l === 'negativ') return 'negativ';
  return 'neutru';
}

export default function MovieDetailPage() {
  const { id } = useParams<{ id: string }>();
  const filmId = Number(id);
  const { isLoggedIn } = useAuth();
  const navigate = useNavigate();

  const [movie,             setMovie]             = useState<MovieDetailResponse | null>(null);
  const [feeling,           setFeeling]           = useState<MovieFeelingResponse | null>(null);
  const [options,           setOptions]           = useState<OptionResponse[]>([]);       // optiunile deja salvate pe film
  const [predefinedOptions, setPredefinedOptions] = useState<OptionResponse[]>([]);       // toate optiunile disponibile
  const [selectedIds,       setSelectedIds]       = useState<Set<number>>(new Set());     // selectia locala a userului
  const [optionMsg,         setOptionMsg]         = useState('');
  const [optionLoading,     setOptionLoading]     = useState(false);
  const [loading,           setLoading]           = useState(true);
  const [error,             setError]             = useState('');

  // Watch form
  const [selectedVersion, setSelectedVersion] = useState('');
  const [watchStatus,     setWatchStatus]     = useState('COMPLET');
  const [watchMsg,        setWatchMsg]        = useState('');

  // Vote form
  const [score,   setScore]   = useState('');
  const [voteMsg, setVoteMsg] = useState('');

  // Comment form
  const [commentText, setCommentText] = useState('');
  const [commentMsg,  setCommentMsg]  = useState('');

  // Schimbăm din string[] în number[] pentru a stoca ID-urile actorilor
const [selectedActors, setSelectedActors] = useState<number[]>([]);

const handleActorToggle = (actorId: number) => {
  setSelectedActors(prev =>
    prev.includes(actorId)
      ? prev.filter(id => id !== actorId)
      : [...prev, actorId]
  );
};

  useEffect(() => {
    if (!filmId) return;
    Promise.all([
      moviesApi.getMovieById(filmId),
      moviesApi.getMovieFeeling(filmId).catch(() => null),
      moviesApi.getMovieOptions(filmId).catch(() => [] as OptionResponse[])
    ]).then(([m, f, movieOpts]) => {
      setMovie(m);
      setFeeling(f);
      setOptions(movieOpts ?? []);
      // initializeaza selectia locala cu optiunile deja salvate pe film
      setSelectedIds(new Set((movieOpts ?? []).map(o => o.optiune_id)));
      if (m.versiuni?.length) setSelectedVersion(String(m.versiuni[0].versiuneId));
    }).catch(() => setError('Nu s-au putut încărca detaliile filmului.'))
      .finally(() => setLoading(false));
  }, [filmId]);

  useEffect(() => {
  if (!isLoggedIn || !filmId) return;
  interactionsApi.getOptions()
    .then(setPredefinedOptions)
    .catch(() => {});
}, [isLoggedIn, filmId]);

useEffect(() => {
  if (!isLoggedIn || !filmId) return;
  Promise.all([
    interactionsApi.getOptions().catch(() => [] as OptionResponse[]),
    moviesApi.getMovieOptions(filmId).catch(() => [] as OptionResponse[]),
  ]).then(([predOpts, movieOpts]) => {
    setPredefinedOptions(predOpts);
    setOptions(movieOpts);
    setSelectedIds(new Set(movieOpts.map(o => o.optiune_id)));
  });
}, [isLoggedIn, filmId]);

  
  const toggleOption = (optionId: number) => {
    setSelectedIds(prev => {
      const next = new Set(prev);
      next.has(optionId) ? next.delete(optionId) : next.add(optionId);
      return next;
    });
    setOptionMsg('');
  };

  
  const handleSubmitOptions = async () => {
    setOptionLoading(true);
    setOptionMsg('');
    try {
      const savedIds = new Set(options.map(o => o.optiune_id));
      const toAdd    = [...selectedIds].filter(id => !savedIds.has(id));
      const toRemove = [...savedIds].filter(id => !selectedIds.has(id));

      await Promise.all([
        ...toAdd.map(id    => interactionsApi.addOptionToMovie(filmId, { optionId: id })),
        ...toRemove.map(id => interactionsApi.removeOptionFromMovie(filmId, id)),
      ]);

      
      const updated = await moviesApi.getMovieOptions(filmId).catch(() => [] as OptionResponse[]);
      setOptions(updated);
      setSelectedIds(new Set(updated.map(o => o.optiune_id)));
      setOptionMsg('Opțiunile au fost salvate!');
    } catch {
      setOptionMsg('Eroare la salvarea opțiunilor.');
    } finally {
      setOptionLoading(false);
    }
  };

  const handleWatch = async (e: FormEvent) => {
    e.preventDefault();
    try {
      await interactionsApi.postWatch({ versiuneId: Number(selectedVersion), status: watchStatus });
      setWatchMsg('Vizualizare înregistrată!');
    } catch { setWatchMsg('Eroare la înregistrare.'); }
  };

  const handleVote = async (e: FormEvent) => {
    e.preventDefault();
    const s = Number(score);
    if (!s || s < 1 || s > 10) { setVoteMsg('Scorul trebuie să fie între 1 și 10.'); return; }
    try {
      await interactionsApi.postVote({ filmId, scor: s });
      setVoteMsg('Vot trimis!');
    } catch { setVoteMsg('Ai votat deja sau a apărut o eroare.'); }
  };

  const handleComment = async (e: FormEvent) => {
  e.preventDefault();
  if (!commentText.trim()) { setCommentMsg('Textul este obligatoriu.'); return; }
  try {
    // Trimitem textul și array-ul de ID-uri selectate
    await commentsApi.createComment({ 
      filmId, 
      text: commentText.trim(),
      actorIds: selectedActors 
    });
    
    setCommentText('');
    setSelectedActors([]); 
    setCommentMsg('Comentariu adăugat!');
    
    const updated = await moviesApi.getMovieById(filmId);
    setMovie(updated);
  } catch { 
    setCommentMsg('Eroare la trimiterea comentariului.'); 
  }
};

  if (loading) return (
    <div className="page">
      <div className="state-loading"><div className="state-spinner" />Se încarcă...</div>
    </div>
  );
  if (error || !movie) return <div className="page"><div className="state-error">{error || 'Film negăsit.'}</div></div>;

  const categories = movie.categorii?.split(',').map(c => c.trim()).filter(Boolean) ?? [];

  
  const savedIds   = new Set(options.map(o => o.optiune_id));
  const hasChanges = [...selectedIds].some(id => !savedIds.has(id)) ||
                     [...savedIds].some(id => !selectedIds.has(id));

  return (
    <div className="page">
      <span className="back-link" onClick={() => navigate('/movies')} style={{ cursor: 'pointer' }}>
        ← Înapoi la filme
      </span>

      
      <div className="movie-detail-header">
        <div className="movie-poster">
          {movie.titlu.split(' ').slice(0, 2).map(w => w[0]).join('').toUpperCase()}
        </div>
        <div>
          <h1 className="movie-detail-title">{movie.titlu}</h1>
          <div className="movie-meta-row">
            <span className="rating-badge">★ {movie.rating?.toFixed(1) ?? '—'}</span>
            <span className="meta-chip">{movie.dataLansare?.slice(0, 4) ?? '—'}</span>
          </div>
          <div className="movie-category-tags">
            {categories.map(c => <span key={c} className="tag">{c}</span>)}
          </div>
          {movie.descriere && (
            <p className="movie-description">{movie.descriere}</p>
          )}
          <div className="movie-actions">
            {isLoggedIn ? (
              <>
                <button className="btn btn-secondary btn-sm" onClick={() =>
                  document.getElementById('section-watch')?.scrollIntoView({ behavior: 'smooth' })
                }>Vizionează</button>
                <button className="btn btn-ghost btn-sm" onClick={() =>
                  document.getElementById('section-vote')?.scrollIntoView({ behavior: 'smooth' })
                }> Votează</button>
                <button className="btn btn-ghost btn-sm" onClick={() =>
                  document.getElementById('section-comment')?.scrollIntoView({ behavior: 'smooth' })
                }>Comentează</button>
              </>
            ) : (
              <button className="btn btn-primary btn-sm" onClick={() => navigate('/login')}>
                Loghează-te pentru a interacționa
              </button>
            )}
          </div>
        </div>
      </div>

    
    
      {movie.versiuni?.length > 0 && (
        <div className="detail-section">
          <h2 className="section-title">Versiuni disponibile</h2>
          <div className="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Format</th><th>Limbă</th><th>Rezoluție</th><th>Durată (min)</th>
                </tr>
              </thead>
              <tbody>
                {movie.versiuni.map(v => (
                  <tr key={v.versiuneId}>
                    <td>{v.format}</td>
                    <td>{v.limba}</td>
                    <td>{v.rezolutie}</td>
                    <td>{v.durata}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      
      {isLoggedIn && predefinedOptions.length > 0 && (
        <div className="detail-section">
          <h2 className="section-title">Opțiunile tale</h2>
          <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 14 }}>
            Selectează opțiunile care se potrivesc, apoi apasă{' '}
            <strong style={{ color: 'var(--text-dim)' }}>Salvează</strong>.
          </p>

          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10, marginBottom: 16 }}>
            {predefinedOptions.map(o => {
              const isSelected = selectedIds.has(o.optiune_id);
              return (
                <button
                  key={o.optiune_id}
                  onClick={() => toggleOption(o.optiune_id)}
                  style={{
                    display: 'inline-flex',
                    alignItems: 'center',
                    gap: 7,
                    padding: '8px 18px',
                    borderRadius: 100,
                    border: `1px solid ${isSelected ? 'var(--blue-primary)' : 'var(--border)'}`,
                    background: isSelected ? 'var(--blue-dim)' : 'var(--card)',
                    color: isSelected ? 'var(--blue-light)' : 'var(--text-dim)',
                    fontSize: 13,
                    fontFamily: 'var(--font-body)',
                    cursor: 'pointer',
                  }}
                >
                  <span style={{ fontSize: 14, lineHeight: 1 }}>
                    {isSelected ? '✓' : '○'}
                  </span>
                  {o.denumire}
                </button>
              );
            })}
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button
              className="btn btn-primary btn-sm"
              onClick={handleSubmitOptions}
              disabled={!hasChanges || optionLoading}
            >
              {optionLoading ? 'Se salvează...' : 'Salvează opțiunile'}
            </button>
            {!hasChanges && options.length > 0 && (
              <span style={{ fontSize: 12, color: 'var(--positive)' }}>✓ Salvat</span>
            )}
          </div>

          {optionMsg && (
            <div
              className={`alert ${optionMsg.includes('Eroare') ? 'alert-error' : 'alert-success'}`}
              style={{ marginTop: 12 }}
            >
              {optionMsg}
            </div>
          )}
        </div>
      )}

      
      {feeling && (
        <div className="detail-section">
          <h2 className="section-title">Sentiment public</h2>
          <div className="feeling-concluzie">{feeling.concluzie}</div>
          {feeling.detalii?.length > 0 && (
            <div className="feeling-bars">
              {feeling.detalii.map(d => (
                <div key={d.sursa}>
                  <div style={{ fontSize: 12, color: 'var(--text-dim)', marginBottom: 6, fontFamily: 'var(--font-mono)' }}>
                    {d.sursa} <span style={{ color: 'var(--text-muted)' }}>({d.total} comentarii)</span>
                  </div>
                  {(['pozitiv', 'neutru', 'negativ'] as const).map(type => {
                    const val = d[type] ?? 0;
                    const pct = d.total ? Math.round((val / d.total) * 100) : 0;
                    return (
                      <div key={type} className="feeling-bar-row">
                        <span className="feeling-bar-label">{type}</span>
                        <div className="feeling-bar-track">
                          <div className={`feeling-bar-fill ${type}`} style={{ width: `${pct}%` }} />
                        </div>
                        <span className="feeling-bar-val">{val}</span>
                      </div>
                    );
                  })}
                </div>
              ))}
            </div>
          )}
        </div>
      )}

    
      {movie.comentarii?.length > 0 && (
        <div className="detail-section">
          <h2 className="section-title">Comentarii ({movie.comentarii.length})</h2>
          <div className="comment-list">
            {movie.comentarii.map(c => (
              <div key={c.comentariuId} className="comment-item">
                <div className="comment-header">
                  <span className="comment-author">{c.client}</span>
                  <span className="comment-date">{c.dataComentariu}</span>
                  {c.sentiment && (
                    <span className={`sentiment-badge ${sentimentClass(c.sentiment)}`}>
                      {c.sentiment}
                    </span>
                  )}
                </div>
                <p className="comment-text">{c.text}</p>
                {c.actoriMentionati && (
                  <div className="comment-actors-tag">Actori menționați: {c.actoriMentionati}</div>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      
      {isLoggedIn && (
        <>
          <hr className="divider" />

          {/* Watch */}
          {movie.versiuni?.length > 0 && (
            <div id="section-watch" className="action-form">
              <div className="action-form-title">Înregistrează vizionare</div>
              <form onSubmit={handleWatch}>
                <div className="form-row">
                  <div className="form-group">
                    <label className="form-label">Versiune</label>
                    <select value={selectedVersion} onChange={e => setSelectedVersion(e.target.value)}>
                      {movie.versiuni.map(v => (
                        <option key={v.versiuneId} value={v.versiuneId}>
                          {v.format} — {v.limba} ({v.rezolutie})
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label">Status</label>
                    <select value={watchStatus} onChange={e => setWatchStatus(e.target.value)}>
                      <option value="COMPLET">Văzut complet</option>
                      <option value="PARTIAL">În vizionare</option>
                      <option value="ABANDONAT">Abandonat</option>
                    </select>
                  </div>
                  <button type="submit" className="btn btn-primary" style={{ alignSelf: 'flex-end' }}>
                    Confirmă
                  </button>
                </div>
              </form>
              {watchMsg && (
                <div className={`alert ${watchMsg.includes('Eroare') ? 'alert-error' : 'alert-success'}`}>
                  {watchMsg}
                </div>
              )}
            </div>
          )}

  
          <div id="section-vote" className="action-form">
            <div className="action-form-title">Votează filmul</div>
            <form onSubmit={handleVote}>
              <div className="form-row">
                <div className="form-group">
                  <label className="form-label">Scor (1–10)</label>
                  <input
                    type="number"
                    min={1} max={10}
                    placeholder="Ex: 8"
                    value={score}
                    onChange={e => setScore(e.target.value)}
                    className="score-input"
                  />
                </div>
                <button type="submit" className="btn btn-primary" style={{ alignSelf: 'flex-end' }}>
                  Trimite votul
                </button>
              </div>
            </form>
            {voteMsg && (
              <div className={`alert ${voteMsg.includes('Eroare') || voteMsg.includes('deja') ? 'alert-error' : 'alert-success'}`}>
                {voteMsg}
              </div>
            )}
          </div>

          {/* Comment */}
      <div id="section-comment" className="action-form">
        <div className="action-form-title">Adaugă comentariu</div>
        <form onSubmit={handleComment}>
          <div className="form-group" style={{ marginBottom: 10 }}>
            <label className="form-label">Comentariul tău</label>
            <textarea
              rows={3}
              placeholder="Ce crezi despre acest film?"
              value={commentText}
              onChange={e => setCommentText(e.target.value)}
            />
          </div>

          {/* AICI TREBUIE SĂ FIE MUTAT BLOCUL: */}
          {/* Actori */}
          {movie.actori?.length > 0 && (
            <div className="form-group" style={{ marginBottom: 10 }}>
              <label className="form-label">Menționează actori în comentariu</label>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginTop: 6 }}>
                {movie.actori.map(a => {
                  const isSelected = selectedActors.includes(a.actorId);
                  return (
                    <label
                      key={a.actorId}
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: 6,
                        padding: '5px 12px',
                        borderRadius: 100,
                        border: `1px solid ${isSelected ? 'var(--blue-primary)' : 'var(--border)'}`,
                        background: isSelected ? 'var(--blue-dim)' : 'var(--card)',
                        color: isSelected ? 'var(--blue-light)' : 'var(--text-dim)',
                        fontSize: 13,
                        cursor: 'pointer',
                      }}
                    >
                      <input
                        type="checkbox"
                        checked={isSelected}
                        onChange={() => handleActorToggle(a.actorId)}
                        style={{ display: 'none' }}
                      />
                      {isSelected ? '✓' : '○'} {a.numeComplet}
                    </label>
                  );
                })}
              </div>
            </div>
          )}

          <button type="submit" className="btn btn-primary btn-sm">
            Publică
          </button>
        </form>
        
        {commentMsg && (
          <div className={`alert ${commentMsg.includes('Eroare') ? 'alert-error' : 'alert-success'}`} style={{ marginTop: 10 }}>
            {commentMsg}
          </div>
        )}
      </div>
        </>
      )}
    </div>
  );
}