// src/components/auth/WalletConnect.tsx
import React from 'react';
import { useWeb3 } from '../../contexts/auth/Web3Context';

export const WalletConnect: React.FC = () => {
  const { address, connectWallet, disconnectWallet } = useWeb3();

  return (
    <div className="flex flex-col items-center gap-4 p-6 bg-white rounded-lg shadow">
      <h2 className="text-2xl font-bold text-gray-800">Connect Your Wallet</h2>
      {!address ? (
        <button
          onClick={connectWallet}
          className="px-6 py-2 text-white bg-blue-600 rounded hover:bg-blue-700"
        >
          Connect MetaMask
        </button>
      ) : (
        <div className="flex flex-col items-center gap-2">
          <p className="text-gray-600">
            Connected: {address.slice(0, 6)}...{address.slice(-4)}
          </p>
          <button
            onClick={disconnectWallet}
            className="px-6 py-2 text-white bg-red-600 rounded hover:bg-red-700"
          >
            Disconnect
          </button>
        </div>
      )}
    </div>
  );
};

// src/components/auth/SignUpForm.tsx
import React, { useState } from 'react';
import { useWeb3 } from '../../contexts/auth/Web3Context';

interface SignUpFormProps {
  onSubmit: (formData: any) => void;
}

export const SignUpForm: React.FC<SignUpFormProps> = ({ onSubmit }) => {
  const { address } = useWeb3();
  const [formData, setFormData] = useState({
    username: '',
    isBuddy: true,
    preferredActivities: '',
    fitnessLevel: '1',
    availableTimes: '',
    locationPreference: ''
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!address) {
      alert('Please connect your wallet first!');
      return;
    }
    onSubmit({ ...formData, walletAddress: address });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6 max-w-md mx-auto p-6">
      <div>
        <label className="block text-gray-700 mb-2">Username</label>
        <input
          type="text"
          value={formData.username}
          onChange={(e) => setFormData({ ...formData, username: e.target.value })}
          className="w-full p-2 border rounded"
          required
        />
      </div>

      <div>
        <label className="block text-gray-700 mb-2">I want to be a:</label>
        <select
          value={formData.isBuddy.toString()}
          onChange={(e) => setFormData({ 
            ...formData, 
            isBuddy: e.target.value === 'true' 
          })}
          className="w-full p-2 border rounded"
        >
          <option value="true">Fitness Buddy</option>
          <option value="false">Group Organizer</option>
        </select>
      </div>

      {/* Add more form fields for fitness preferences */}
      
      <button
        type="submit"
        className="w-full py-2 px-4 bg-blue-600 text-white rounded hover:bg-blue-700"
        disabled={!address}
      >
        Sign Up
      </button>
    </form>
  );
};