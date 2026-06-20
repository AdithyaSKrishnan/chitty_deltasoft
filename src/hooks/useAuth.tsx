import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { User } from '../types';
import {
  clearAuthData,
  getAccessToken,
  getStoredUser,
  login as apiLogin,
  mapApiError,
} from '../services/api';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (username: string, password: string) => Promise<User>;
  logout: () => void;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const token = getAccessToken();
    const storedUser = getStoredUser();
    if (token && storedUser) {
      setUser(storedUser);
    } else {
      clearAuthData();
    }
    setIsLoading(false);
  }, []);

  const login = async (username: string, password: string): Promise<User> => {
    try {
      const loggedInUser = await apiLogin(username, password);
      setUser(loggedInUser);
      return loggedInUser;
    } catch (error) {
      throw new Error(mapApiError(error));
    }
  };

  const logout = () => {
    setUser(null);
    clearAuthData();
  };

  return (
    <AuthContext.Provider value={{ user, isAuthenticated: !!user, login, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
