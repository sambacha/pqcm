/// SPDX-License-Identifier: SSPL-1.0
pragma solidity >=0.5.7 <0.6.0;

/// @title Mapping
import "./CallMarket.sol";

contract Mapping {
    address payable addr;

    constructor(address _callmarket) public {
        address callmarket = address(address(_callmarket));
        addr = address(uint160(callmarket));
    }

    mapping(address => uint256) public UnavailableTokenBalance;
    mapping(address => uint256) public UnavailableEtherBalance;

    //address payable callmarket = address(uint160(address(Call_Market)));
    function destroy() public {
        selfdestruct(addr);
    }

    function addToken(address _sender, uint256 _volume) public {
        UnavailableTokenBalance[_sender] += _volume;
    }

    function addEther(
        address _sender,
        uint256 _price,
        uint256 _volume
    ) public {
        UnavailableEtherBalance[_sender] += _volume * _price;
    }

    function readToken(address _sender) public returns (uint256) {
        return UnavailableTokenBalance[_sender];
    }

    function readEther(address _sender) public returns (uint256) {
        return UnavailableEtherBalance[_sender];
    }
}
