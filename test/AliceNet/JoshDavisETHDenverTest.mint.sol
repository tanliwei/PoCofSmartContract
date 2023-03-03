// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "src/AliceNet/collections/JoshDavisETHDenver.sol";

contract JoshDavisETHDenverTest is Test {

    JoshDavisETHDenver denver;

    address _dao = address(1);

    function setUp() public {
        denver = new JoshDavisETHDenver(address(100), address(101));
    }

    function testAnyOneCanMintAnyamount() public {
        vm.startPrank(address(22));
        denver.mint(address(22));
        vm.stopPrank();
        assertEq(denver.balanceOf(address(22)), 1);
        vm.startPrank(address(33));
        denver.mint(address(33));
        denver.mint(address(33));
        vm.stopPrank();
        assertEq(denver.balanceOf(address(33)), 2);
    }

}
