import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import Navbar from './components/Navbar';
import ProtectedRoute from './components/ProtectedRoute';

import LoginPage         from './pages/LoginPage';
import MoviesPage        from './pages/MoviesPage';
import MovieDetailPage   from './pages/MovieDetailPage';
import ActorsPage        from './pages/ActorsPage';
import ActorDetailPage   from './pages/ActorDetailPage';
import ProfilePage       from './pages/ProfilePage';
import RecommendationsPage from './pages/RecommendationsPage';
import StatisticsPage    from './pages/StatisticsPage';

function Layout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Navbar />
      {children}
    </>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Layout>
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/movies" element={<MoviesPage />} />
            <Route path="/movies/:id" element={<MovieDetailPage />} />
            <Route path="/actors" element={<ActorsPage />} />
            <Route path="/actors/:id" element={
              <ActorDetailPage />
            } />
            <Route path="/recommendations" element={
              <ProtectedRoute><RecommendationsPage /></ProtectedRoute>
            } />
            <Route path="/profile" element={
              <ProtectedRoute><ProfilePage /></ProtectedRoute>
            } />
            <Route path="/statistics" element={
              <ProtectedRoute><StatisticsPage /></ProtectedRoute>
            } />
            <Route path="*" element={<Navigate to="/movies" replace />} />
          </Routes>
        </Layout>
      </AuthProvider>
    </BrowserRouter>
  );
}
