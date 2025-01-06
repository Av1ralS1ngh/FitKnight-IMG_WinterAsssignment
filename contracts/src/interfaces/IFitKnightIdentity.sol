// contracts/src/interfaces/IFitKnightIdentity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IFitKnightIdentity {
    // Data structures
    struct UserProfile {
        address walletAddress;
        string username;
        string profileURI;
        uint256 reputationScore;
        bool isBuddy;          // true for buddy, false for group organizer
        bytes32 preferencesHash;
    }

    struct FitnessPreferences {
        uint8 fitnessLevel;
        string preferredActivities;
        string availableTimes;
        string locationPreference;
    }

    // Events
    event IdentityCreated(address indexed user, string username, bool isBuddy);
    event ProfileUpdated(address indexed user, string profileURI);
    event PreferencesUpdated(address indexed user, bytes32 preferencesHash);

    // Core functions
    function createIdentity(
        string memory username,
        string memory profileURI,
        bool isBuddy,
        FitnessPreferences memory preferences
    ) external;

    function updateProfile(string memory profileURI) external;
    function updatePreferences(FitnessPreferences memory preferences) external;
    function getProfile(address user) external view returns (UserProfile memory);
}