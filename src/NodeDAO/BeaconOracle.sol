// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.8;

/**
 * @title Beacon Oracle and Dao
 *
 * BeaconOracle data acquisition and verification
 * Dao management
 */
contract BeaconOracle
{

    /// ...

    // Use the maximum value of uint256 as the index that does not exist
    uint256 internal constant MEMBER_NOT_FOUND = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    /// ...

    /// The bitmask of the oracle members that pushed their reports (default:0)
    uint256 public reportBitMaskPosition;

    // current reportBeacon beaconValidators
    uint256 public beaconValidators;

    uint256 public oracleMemberCount;

    // reportBeacon storge
    bytes[] internal currentReportVariants;

    // oracle commit members
    address[] internal oracleMembers;

    /// ...

    /**
     * Return `_member` index in the members list or MEMBER_NOT_FOUND
     */
    function getMemberId(address _member) public view returns (uint256) {
        uint256 length = oracleMembers.length;
        for (uint256 i = 0; i < length; ++i) {
            if (oracleMembers[i] == _member) {
                return i;
            }
        }
        return MEMBER_NOT_FOUND;
    }
    //...
    /**
     * Add oracle member
     */
    function addOracleMember(address _oracleMember) external {//audit cr
        require(address(0) != _oracleMember, "BAD_ARGUMENT");
        require(MEMBER_NOT_FOUND == getMemberId(_oracleMember), "MEMBER_EXISTS");

        bool isAdd = false;
        for (uint256 i = 0; i < oracleMembers.length; ++i) {
            if (oracleMembers[i] == address(0)) {
                oracleMembers[i] = _oracleMember;
                isAdd = true;
                break;
            }
        }

        if (!isAdd) {
            oracleMembers.push(_oracleMember);
        }

        oracleMemberCount++;

    }

    /**
     * @return {bool} is oracleMember
     */
    function isOracleMember(address _oracleMember) external view returns (bool) {
        require(address(0) != _oracleMember, "BAD_ARGUMENT");
        return _isOracleMember(_oracleMember);
    }

    function _isOracleMember(address _oracleMember) internal view returns (bool) {
        uint256 index = getMemberId(_oracleMember);
        return index != MEMBER_NOT_FOUND;
    }

    /// ...

    /**
     * description: The oracle service reports beacon chain data to the contract
     * @param _epochId The epoch Id expected by the current frame
     * @param _beaconBalance Beacon chain balance
     * @param _beaconValidators Number of beacon chain validators
     * @param _validatorRankingRoot merkle root
     */
    function reportBeacon(
        uint256 _epochId,
        uint256 _beaconBalance,
        uint256 _beaconValidators,
        bytes32 _validatorRankingRoot
    ) external {
        //...
        // make sure the oracle is from members list and has not yet voted
        uint256 index = getMemberId(msg.sender);
        require(index != MEMBER_NOT_FOUND, "MEMBER_NOT_FOUND");

        uint256 bitMask = reportBitMaskPosition;
        uint256 mask = 1 << index;
        require(bitMask & mask == 0, "ALREADY_SUBMITTED");
        // reported, set the bitmask to the specified bit
        reportBitMaskPosition = bitMask | mask;
        //...
    }

    /**
     * Whether the address of the caller has performed reportBeacon
     */
    function isReportBeacon(address _oracleMember) external view returns (bool) {
        require(_oracleMember != address(0), "Address invalid");
        // make sure the oracle is from members list and has not yet voted
        uint256 index = getMemberId(_oracleMember);
        require(index != MEMBER_NOT_FOUND, "MEMBER_NOT_FOUND");
        uint256 bitMask = reportBitMaskPosition;
        uint256 mask = 1 << index;
        return bitMask & mask != 0;
    }
}
