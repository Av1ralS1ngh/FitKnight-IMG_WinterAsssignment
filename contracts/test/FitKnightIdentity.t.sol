// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/FitKnightIdentity.sol";

contract FitKnightIdentityTest is Test {
    FitKnightIdentity public identity;
    address public user = address(1);
    
    function setUp() public {
        identity = new FitKnightIdentity();
    }
    
    function testCreateIdentity() public {
        vm.prank(user);
        identity.createIdentity("testUser", "ipfs://test");
        
        FitKnightIdentity.UserProfile memory profile = identity.getProfile(user);
        assertEq(profile.username, "testUser");
        assertEq(profile.profileURI, "ipfs://test");
    }
}