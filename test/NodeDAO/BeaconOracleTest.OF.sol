// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "lib/forge-std/src/Test.sol";
import "src/NodeDAO/BeaconOracle.sol";

contract BeaconOracleTest is Test {

    BeaconOracle beaconOracle;

    address _dao = address(1);
    function setUp() public {
        beaconOracle = new BeaconOracle();
    }

    function testReportBeacon_OverFlow() public {

        beaconOracle.addOracleMember(address(uint160(1)));
        vm.startPrank(address(1));
        assertFalse(beaconOracle.isReportBeacon(address(1)));
        console.log("reportBitMaskPosition() 1:", beaconOracle.reportBitMaskPosition());
        beaconOracle.reportBeacon(147375, 64000000000000000000, 2, '');
        assertEq(beaconOracle.isReportBeacon(address(1)), true);
        vm.stopPrank();

        
        vm.startPrank(address(1));
        for(uint i = 0; i < 255; i++) {
            beaconOracle.addOracleMember(address(uint160(1000+i)));
        }      
        vm.stopPrank();
        
            beaconOracle.addOracleMember(address(uint160(1255)));
        console.log("getMemberId():", beaconOracle.getMemberId(address(1255)));
        vm.startPrank(address(1255));
        assertEq(beaconOracle.isReportBeacon(address(1255)), false);
        // vm.expectRevert("ALREADY_SUBMITTED");
        console.log("reportBitMaskPosition() 1255:", beaconOracle.reportBitMaskPosition());
        beaconOracle.reportBeacon(147375, 64000000000000000000, 2, '');
        assertEq(beaconOracle.isReportBeacon(address(1255)), false);
        vm.stopPrank();
    }

}
