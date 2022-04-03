//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OptionToken is ERC20("Option token", "OPT"), Ownable {
    //创建期权Token 时，确认标的的价格与行权日期；
    uint256 public optDate; //行权日期
    address public tokenAddress; //期权对应的币
    address public tokenByOptAddr; //用什么币买期权
    uint256 public tokenPrice; //以什么价格购买期权

    constructor(
        uint256 _optDate,
        address _tokenAddress,
        address _tokenByOptAddr,
        uint256 _tokenPrice
    ) {
        optDate = _optDate;
        tokenAddress = _tokenAddress;
        tokenByOptAddr = _tokenByOptAddr;
        tokenPrice = _tokenPrice;
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function burn(address _to, uint256 _amount) public onlyOwner {
        _burn(_to, _amount);
    }
}
