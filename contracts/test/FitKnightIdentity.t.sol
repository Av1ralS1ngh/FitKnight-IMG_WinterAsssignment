// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/FitKnightIdentity.sol";

contract FitKnightIdentityTest is Test {
    FitKnightIdentity public fitKnightIdentity;
    address public constant AVI_ADDRESS = 0x3144D220a79e663d64AE81a2CAf1954ff89b416a;
    address public user1;
    address public user2;

    function setUp() public {
        fitKnightIdentity = new FitKnightIdentity();
        user1 = address(0x1);
        user2 = address(0x2);
    }

    function testCreateIdentity() public {
        vm.startPrank(user1);

        IFitKnightIdentity.FitnessPreferences memory prefs = IFitKnightIdentity.FitnessPreferences({
            fitnessLevel: 1,
            preferredActivities: "Running, Weightlifting",
            availableTimes: "Evenings",
            locationPreference: "Outdoor"
        });

        fitKnightIdentity.createIdentity("User1", "ipfs://user1", true, prefs);

        IFitKnightIdentity.UserProfile memory profile = fitKnightIdentity.getProfile(user1);

        assertEq(profile.walletAddress, user1);
        assertEq(profile.username, "User1");
        assertEq(profile.profileURI, "ipfs://user1");
        assertEq(profile.isBuddy, true);

        vm.stopPrank();
    }

    function testUpdateProfile() public {
        vm.startPrank(user1);

        // First, create an identity
        IFitKnightIdentity.FitnessPreferences memory prefs = IFitKnightIdentity.FitnessPreferences({
            fitnessLevel: 1,
            preferredActivities: "Running",
            availableTimes: "Mornings",
            locationPreference: "Indoor"
        });
        fitKnightIdentity.createIdentity("User1", "ipfs://user1", false, prefs);

        // Now update the profile
        fitKnightIdentity.updateProfile("ipfs://user1_updated");

        IFitKnightIdentity.UserProfile memory updatedProfile = fitKnightIdentity.getProfile(user1);
        assertEq(updatedProfile.profileURI, "ipfs://user1_updated");

        vm.stopPrank();
    }

    function testUpdatePreferences() public {
        vm.startPrank(user1);

        // First, create an identity
        IFitKnightIdentity.FitnessPreferences memory prefs = IFitKnightIdentity.FitnessPreferences({
            fitnessLevel: 1,
            preferredActivities: "Running",
            availableTimes: "Mornings",
            locationPreference: "Indoor"
        });
        fitKnightIdentity.createIdentity("User1", "ipfs://user1", false, prefs);

        // Now update the preferences
        IFitKnightIdentity.FitnessPreferences memory newPrefs = IFitKnightIdentity.FitnessPreferences({
            fitnessLevel: 2,
            preferredActivities: "Swimming",
            availableTimes: "Evenings",
            locationPreference: "Outdoor"
        });
        fitKnightIdentity.updatePreferences(newPrefs);

        IFitKnightIdentity.UserProfile memory updatedProfile = fitKnightIdentity.getProfile(user1);
        bytes32 newPrefsHash = keccak256(abi.encode(newPrefs));
        assertEq(updatedProfile.preferencesHash, newPrefsHash);

        vm.stopPrank();
    }

    function testFailCreateDuplicateIdentity() public {
        vm.startPrank(user1);

        IFitKnightIdentity.FitnessPreferences memory prefs = IFitKnightIdentity.FitnessPreferences({
            fitnessLevel: 1,
            preferredActivities: "Running",
            availableTimes: "Mornings",
            locationPreference: "Indoor"
        });
        fitKnightIdentity.createIdentity("User1", "ipfs://user1", false, prefs);

        // This should fail
        fitKnightIdentity.createIdentity("User1Duplicate", "ipfs://user1_duplicate", true, prefs);

        vm.stopPrank();
    }

    function testFailUpdateNonExistentProfile() public {
        vm.prank(user2);
        fitKnightIdentity.updateProfile("ipfs://nonexistent");
    }

    function testOwnership() public {
        assertEq(fitKnightIdentity.owner(), AVI_ADDRESS);
    }
}