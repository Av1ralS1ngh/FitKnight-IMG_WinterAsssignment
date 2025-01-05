// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IFitKnightIdentity.sol";

contract FitKnightIdentity is IFitKnightIdentity {
    mapping(address => UserProfile) private profiles;
    
    function createIdentity(string memory username, string memory profileURI) external override {
        require(profiles[msg.sender].walletAddress == address(0), "Identity exists");
        
        profiles[msg.sender] = UserProfile({
            walletAddress: msg.sender,
            username: username,
            profileURI: profileURI,
            reputationScore: 0
        });
        
        emit IdentityCreated(msg.sender, username);
    }
    
    function updateProfile(string memory profileURI) external override {
        require(profiles[msg.sender].walletAddress != address(0), "Identity doesn't exist");
        
        profiles[msg.sender].profileURI = profileURI;
        emit ProfileUpdated(msg.sender, profileURI);
    }
    
    function getProfile(address user) external view override returns (UserProfile memory) {
        return profiles[user];
    }
}