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
        //添加一个Oracle Member
        beaconOracle.addOracleMember(address(uint160(1)));
        //伪装成address(1)调用后续的函数
        vm.startPrank(address(1));
        //使用address(1)调用 isReportBeacon()函数, 默认时为false
        assertEq(beaconOracle.isReportBeacon(address(1)), false);
        //调用 reportBeacon() 函数更新 address(1)的状态为 true
        beaconOracle.reportBeacon(147375, 64000000000000000000, 2, '');
        //状态更新成功, 这时 address(1) 的状态已经修改为 true 了
        assertEq(beaconOracle.isReportBeacon(address(1)), true);
        //结束伪装address(1)
        vm.stopPrank();

        //批量添加255个Member ，一共有256个 Oracle members
        vm.startPrank(address(1));
        for(uint i = 0; i < 255; i++) {
            beaconOracle.addOracleMember(address(uint160(1000+i)));
        }      
        vm.stopPrank();
        //添加第257个Oracle member
        beaconOracle.addOracleMember(address(uint160(1255)));
        //对address(1255)重复上面address(1)的操作，但最终 address(1255)查询得到的状态确实false
        vm.startPrank(address(1255));
       
        assertEq(beaconOracle.isReportBeacon(address(1255)), false);
        console.log("reportBitMaskPosition() 1255:", beaconOracle.reportBitMaskPosition());
        beaconOracle.reportBeacon(147375, 64000000000000000000, 2, '');
        // 调用isReportBeacon()函数, 返回结果还是false
        assertEq(beaconOracle.isReportBeacon(address(1255)), false);
        vm.stopPrank();
    }

}
