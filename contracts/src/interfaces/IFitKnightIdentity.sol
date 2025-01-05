// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IFitKnightIdentity {
    struct UserProfile {
        address walletAddress;
        string username;
        string profileURI;
        uint256 reputationScore;
    }
    
    event IdentityCreated(address indexed user, string username);
    event ProfileUpdated(address indexed user, string profileURI);
    
    function createIdentity(string memory username, string memory profileURI) external;
    function updateProfile(string memory profileURI) external;
    function getProfile(address user) external view returns (UserProfile memory);
}