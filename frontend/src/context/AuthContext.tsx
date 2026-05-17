import { createContext, useContext, useState, ReactNode } from 'react';

interface AuthContextType {
  email: string | null;
  login: (email: string) => void;
  logout: () => void;
  isLoggedIn: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [email, setEmail] = useState<string | null>(() =>
    sessionStorage.getItem('userEmail')
  );

  const login = (e: string) => {
    setEmail(e);
    sessionStorage.setItem('userEmail', e);
  };

  const logout = () => {
    setEmail(null);
    sessionStorage.removeItem('userEmail');
  };

  return (
    <AuthContext.Provider value={{ email, login, logout, isLoggedIn: !!email }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used inside AuthProvider');
  return ctx;
}
