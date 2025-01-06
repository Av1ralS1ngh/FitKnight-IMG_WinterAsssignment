// contracts/src/FitKnightIdentity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IFitKnightIdentity.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

address constant AviAddress = 0x3144D220a79e663d64AE81a2CAf1954ff89b416a;
contract FitKnightIdentity is IFitKnightIdentity, Ownable(AviAddress), ReentrancyGuard {
    // State variables
    mapping(address => UserProfile) private profiles;
    mapping(bytes32 => FitnessPreferences) public preferences;
    
    // Helper function to hash preferences
    function hashPreferences(FitnessPreferences memory _prefs) internal pure returns (bytes32) {
        return keccak256(abi.encode(_prefs));
    }
    
    // Implementation of createIdentity
    function createIdentity(
        string memory username,
        string memory profileURI,
        bool isBuddy,
        FitnessPreferences memory _preferences
    ) external override nonReentrant {
        require(profiles[msg.sender].walletAddress == address(0), "Identity exists");
        
        bytes32 prefsHash = hashPreferences(_preferences);
        preferences[prefsHash] = _preferences;
        
        profiles[msg.sender] = UserProfile({
            walletAddress: msg.sender,
            username: username,
            profileURI: profileURI,
            reputationScore: 0,
            isBuddy: isBuddy,
            preferencesHash: prefsHash
        });
        
        emit IdentityCreated(msg.sender, username, isBuddy);
    }
    
    // Implementation of updateProfile
    function updateProfile(string memory profileURI) external override nonReentrant {
        require(profiles[msg.sender].walletAddress != address(0), "Identity doesn't exist");
        
        profiles[msg.sender].profileURI = profileURI;
        emit ProfileUpdated(msg.sender, profileURI);
    }
    
    // Implementation of updatePreferences
    function updatePreferences(FitnessPreferences memory _preferences) external override nonReentrant {
        require(profiles[msg.sender].walletAddress != address(0), "Identity doesn't exist");
        
        bytes32 newPrefsHash = hashPreferences(_preferences);
        preferences[newPrefsHash] = _preferences;
        profiles[msg.sender].preferencesHash = newPrefsHash;
        
        emit PreferencesUpdated(msg.sender, newPrefsHash);
    }
    
    // Implementation of getProfile
    function getProfile(address user) external view override returns (UserProfile memory) {
        return profiles[user];
    }

        function getPreferences(address user) external view returns (FitnessPreferences memory) {
        bytes32 prefsHash = profiles[user].preferencesHash;
        return preferences[prefsHash];
    }
}