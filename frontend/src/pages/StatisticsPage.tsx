import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { statisticsApi } from '../api';
import type { SeasonalStatisticsResponse } from '../types/statistics';

const SEASON_COLORS: Record<string, string> = {
  PRIMAVARA: '#22c55e',
  VARA:      '#f59e0b',
  TOAMNA:    '#f97316',
  IARNA:     '#60a5fa',
};

function SeasonChip({ season }: { season: string }) {
  const color = SEASON_COLORS[season?.toUpperCase()] ?? 'var(--blue-light)';
  return (
    <span
      className="season-badge"
      style={{ color, borderColor: `${color}40`, background: `${color}15` }}
    >
      {season}
    </span>
  );
}

export default function StatisticsPage() {
  const [stats,   setStats]   = useState<SeasonalStatisticsResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    statisticsApi.getSeasonalStatistics()
      .then(setStats)
      .catch(() => setError('Nu s-au putut încărca statisticile.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return (
    <div className="page">
      <div className="state-loading"><div className="state-spinner" />Se încarcă statisticile...</div>
    </div>
  );
  if (error || !stats) return <div className="page"><div className="state-error">{error || 'Eroare.'}</div></div>;

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Statistici sezoniere</h1>
        <p className="page-subtitle">Top filme și categorii per sezon</p>
      </div>

      <div className="stats-grid">
        {/* Top movies per season */}
        {stats.topFilme?.length > 0 && (
          <div className="detail-section" style={{ marginBottom: 0 }}>
            <h2 className="section-title">Top filme</h2>
            <div className="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Sezon</th>
                    <th>Film</th>
                    <th>Rating</th>
                    <th>Vizualizări</th>
                  </tr>
                </thead>
                <tbody>
                  {stats.topFilme.map(m => (
                    <tr
                      key={`${m.sezon}-${m.filmId}`}
                      style={{ cursor: 'pointer' }}
                      onClick={() => navigate(`/movies/${m.filmId}`)}
                    >
                      <td className="stat-rank-cell">{m.locInSezon}</td>
                      <td><SeasonChip season={m.sezon} /></td>
                      <td style={{ fontFamily: 'var(--font-body)', color: 'var(--text)', fontSize: 13 }}>
                        {m.titlu}
                      </td>
                      <td>
                        <span className="rating-badge">★ {m.rating?.toFixed(1)}</span>
                      </td>
                      <td>{m.nrVizualizari?.toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Top categories per season */}
        {stats.topCategorii?.length > 0 && (
          <div className="detail-section" style={{ marginBottom: 0 }}>
            <h2 className="section-title">Top categorii</h2>
            <div className="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Sezon</th>
                    <th>Categorie</th>
                    <th>Vizualizări</th>
                  </tr>
                </thead>
                <tbody>
                  {stats.topCategorii.map((c, i) => (
                    <tr key={`${c.sezon}-${c.categorie}-${i}`}>
                      <td><SeasonChip season={c.sezon} /></td>
                      <td style={{ fontFamily: 'var(--font-body)', color: 'var(--text)', fontSize: 13 }}>
                        {c.categorie}
                      </td>
                      <td>{c.nrVizualizari?.toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
