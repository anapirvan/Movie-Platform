import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { moviesApi } from '../api';
import type { MovieResponse } from '../types/movies';

function initials(title: string) {
  return title.split(' ').slice(0, 2).map(w => w[0]).join('').toUpperCase();
}

export default function MoviesPage() {
  const [movies, setMovies]   = useState<MovieResponse[]>([]);
  const [search, setSearch]   = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError]     = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    moviesApi.getMovies()
      .then(setMovies)
      .catch(() => setError('Nu s-au putut încărca filmele.'))
      .finally(() => setLoading(false));
  }, []);

  const filtered = movies.filter(m =>
    m.titlu.toLowerCase().includes(search.toLowerCase()) ||
    m.categorii?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Filme</h1>
        <p className="page-subtitle">{movies.length} titluri disponibile</p>
      </div>

      <div className="search-bar">
        <div className="search-input-wrap">
          <span className="search-icon">🔍</span>
          <input
            type="text"
            placeholder="Caută după titlu sau categorie..."
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
      </div>

      {loading && (
        <div className="state-loading">
          <div className="state-spinner" />
          Se încarcă filmele...
        </div>
      )}

      {error && <div className="state-error">{error}</div>}

      {!loading && !error && filtered.length === 0 && (
        <div className="state-empty">Niciun film găsit.</div>
      )}

      <div className="movies-grid">
        {filtered.map(movie => (
          <div
            key={movie.filmId}
            className="movie-card"
            onClick={() => navigate(`/movies/${movie.filmId}`)}
          >
            <div className="movie-card-thumb">{initials(movie.titlu)}</div>
            <div className="movie-card-body">
              <div className="movie-card-title">{movie.titlu}</div>
              <div className="movie-card-meta">
                <span className="rating-badge">★ {movie.rating?.toFixed(1) ?? '—'}</span>
                <span>{movie.dataLansare?.slice(0, 4) ?? '—'}</span>
              </div>
              {movie.categorii && (
                <div className="movie-card-categories">{movie.categorii}</div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
