import { useState } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { authApi } from '../api';

export default function Navbar() {
  const { email, logout, isLoggedIn } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

  const handleLogout = async () => {
    try { await authApi.logout(); } catch { /* ignore */ }
    logout();
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="container">
        <NavLink to="/movies" className="navbar-logo">
          Movie Platform
        </NavLink>

        <ul className={`navbar-links ${menuOpen ? 'open' : ''}`} onClick={() => setMenuOpen(false)}>
          <li><NavLink to="/movies">Filme</NavLink></li>
          <li><NavLink to="/actors">Actori</NavLink></li>
          {isLoggedIn && (
            <>
              <li><NavLink to="/recommendations">Recomandări</NavLink></li>
              <li><NavLink to="/profile">Profil</NavLink></li>
              <li><NavLink to="/statistics">Statistici</NavLink></li>
            </>
          )}
        </ul>

        <div className="navbar-right">
          {isLoggedIn ? (
            <>
              <span className="navbar-user">{email}</span>
              <button className="btn btn-ghost btn-sm" onClick={handleLogout}>
                Logout
              </button>
            </>
          ) : (
            <button className="btn btn-primary btn-sm" onClick={() => navigate('/login')}>
              Login
            </button>
          )}
        </div>

        <button
          className="navbar-hamburger"
          onClick={() => setMenuOpen(o => !o)}
          aria-label="Meniu"
        >
          {menuOpen ? '✕' : '☰'}
        </button>
      </div>
    </nav>
  );
}
