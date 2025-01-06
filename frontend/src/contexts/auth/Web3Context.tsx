// src/contexts/auth/Web3Context.tsx
import React, { createContext, useContext, useEffect, useState } from 'react';
import { Web3Provider } from '@ethersproject/providers';
import { ethers } from 'ethers';

interface Web3ContextType {
  provider: Web3Provider | null;
  address: string | null;
  chainId: number | null;
  connectWallet: () => Promise<void>;
  disconnectWallet: () => void;
}

const Web3Context = createContext<Web3ContextType | null>(null);

export const Web3Provider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [provider, setProvider] = useState<Web3Provider | null>(null);
  const [address, setAddress] = useState<string | null>(null);
  const [chainId, setChainId] = useState<number | null>(null);

  const connectWallet = async () => {
    if (window.ethereum) {
      try {
        // Request account access
        const accounts = await window.ethereum.request({ 
          method: 'eth_requestAccounts' 
        });
        
        const web3Provider = new ethers.providers.Web3Provider(window.ethereum);
        const network = await web3Provider.getNetwork();
        
        setProvider(web3Provider);
        setAddress(accounts[0]);
        setChainId(network.chainId);
      } catch (error) {
        console.error('Error connecting wallet:', error);
      }
    } else {
      alert('Please install MetaMask to use this application!');
    }
  };

  const disconnectWallet = () => {
    setProvider(null);
    setAddress(null);
    setChainId(null);
  };

  useEffect(() => {
    // Handle account changes
    if (window.ethereum) {
      window.ethereum.on('accountsChanged', (accounts: string[]) => {
        if (accounts.length > 0) {
          setAddress(accounts[0]);
        } else {
          disconnectWallet();
        }
      });

      // Handle chain changes
      window.ethereum.on('chainChanged', (newChainId: string) => {
        setChainId(parseInt(newChainId));
      });
    }

    return () => {
      if (window.ethereum) {
        window.ethereum.removeListener('accountsChanged', () => {});
        window.ethereum.removeListener('chainChanged', () => {});
      }
    };
  }, []);

  return (
    <Web3Context.Provider value={{ 
      provider, 
      address, 
      chainId, 
      connectWallet, 
      disconnectWallet 
    }}>
      {children}
    </Web3Context.Provider>
  );
};

export const useWeb3 = () => {
  const context = useContext(Web3Context);
  if (!context) {
    throw new Error('useWeb3 must be used within a Web3Provider');
  }
  return context;
};