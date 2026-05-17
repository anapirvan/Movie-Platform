import { useState, type FormEvent } from 'react';
import { useNavigate } from 'react-router-dom';
import { authApi } from '../api';
import { useAuth } from '../context/AuthContext';

export default function LoginPage() {
  const [email, setEmail]   = useState('');
  const [error, setError]   = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!email.trim()) { setError('Email-ul este obligatoriu.'); return; }
    setError('');
    setLoading(true);
    try {
      await authApi.login({ email: email.trim() });
      login(email.trim());
      navigate('/movies');
    } catch (err: any) {
      setError(
        err?.response?.data?.message || 'Login eșuat. Verifică email-ul.'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-box">
        <div className="login-logo">CINE<span>DB</span></div>
        <p className="login-tagline">Baza ta de date cinematografică</p>

        {error && <div className="login-error">{error}</div>}

        <form onSubmit={handleSubmit}>
          <div className="login-form-group">
            <label className="login-form-label" htmlFor="email">Email</label>
            <input
              id="email"
              type="email"
              placeholder="exemplu@email.com"
              value={email}
              onChange={e => setEmail(e.target.value)}
              autoFocus
            />
          </div>
          <button
            type="submit"
            className="btn btn-primary btn-lg"
            style={{ width: '100%', marginTop: 8 }}
            disabled={loading}
          >
            {loading ? 'Se conectează...' : 'Intră în cont'}
          </button>
        </form>
      </div>
    </div>
  );
}
