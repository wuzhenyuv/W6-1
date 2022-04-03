//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./OptionToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

contract OptionContract is Ownable {
    OptionToken public optToken;
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant UNISWAP_V2_FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    constructor(OptionToken _optToken) {
        optToken = _optToken;
    }

    event IssueOptToken(
        address token_address,
        uint256 balance,
        address optToken_address,
        address tokenByOptAddr
    );
    event ExcuteOption(
        address user_address,
        uint256 optAmount,
        uint256 tokenPrice
    );
    event BurnOptToken(uint256 optBalance, uint256 tokenBalance);

    //根据转入的标的发行期权Token；
    function issueOptToken(uint256 tokenAmount) public onlyOwner {
        require(tokenAmount >= 10 * 10 * 18, "not enough token"); //转入的标的需大于10个
        IERC20(optToken.tokenAddress()).transferFrom(
            msg.sender,
            address(this),
            tokenAmount
        );
        IERC20(optToken.tokenByOptAddr()).transferFrom(
            msg.sender,
            address(this),
            100 * tokenAmount
        );
        optToken.mint(address(this), tokenAmount);
        //按照1:100的比例在uniswap上添加流动性
        optToken.approve(UNISWAP_V2_ROUTER,tokenAmount);
        IERC20(optToken.tokenByOptAddr()).approve(UNISWAP_V2_ROUTER,100 * tokenAmount);
        IUniswapV2Router02(UNISWAP_V2_ROUTER).addLiquidity(
            address(optToken),
            optToken.tokenByOptAddr(),
            tokenAmount,
            100 * tokenAmount,
            1,
            1,
            address(this),
            block.timestamp
        );
        emit IssueOptToken(
            optToken.tokenAddress(),
            tokenAmount,
            address(optToken),
            optToken.tokenByOptAddr()
        );
    }

    //行权方法（用户角色）：在到期日当天，可通过指定的价格兑换出标的资产，并销毁期权Token
    function excuteOption(uint256 optAmount) public {
        uint256 userOptBalance = optToken.balanceOf(msg.sender);
        uint256 userBuyOptBalance = IERC20(optToken.tokenByOptAddr()).balanceOf(
            msg.sender
        );
        require(userOptBalance >= optAmount, "not enough opt");
        require(userBuyOptBalance >= optAmount * optToken.tokenPrice()); //购买标的资产的数量足够
        require(
            block.timestamp >= optToken.optDate() &&
                block.timestamp <= optToken.optDate() + 600,
            "not in opt date"
        ); //设置在5分钟内行权
        optToken.transferFrom(msg.sender, address(this), optAmount);
        optToken.burn(address(this), optAmount);
        IERC20(optToken.tokenByOptAddr()).transferFrom(
            msg.sender,
            address(this),
            optAmount * optToken.tokenPrice()
        );
        IERC20(optToken.tokenAddress()).transfer(msg.sender, optAmount); //按照制定价格发币给用户
        emit ExcuteOption(
            msg.sender,
            optAmount,
            optAmount * optToken.tokenPrice()
        );
    }

    //过期销毁（项目方角色）：销毁所有期权Token 赎回标的。
    function burnOptToken(address devAdd) public onlyOwner {
        require(
            block.timestamp > optToken.optDate() + 600,
            "not exceed opt date"
        );
        //撤销uniswap V2流动性池子
        address pair = IUniswapV2Factory(UNISWAP_V2_FACTORY).getPair(
            address(optToken),
            optToken.tokenByOptAddr()
        );
        uint256 liquidity = IERC20(pair).balanceOf(address(this));
        IERC20(pair).approve(UNISWAP_V2_ROUTER, liquidity);
        IUniswapV2Router02(UNISWAP_V2_ROUTER).removeLiquidity(
            address(optToken),
            optToken.tokenByOptAddr(),
            liquidity,
            1,
            1,
            address(this),
            block.timestamp
        );
        uint256 optBalance = optToken.balanceOf(address(this));
        optToken.burn(address(this), optBalance); //销毁期权token
        uint256 tokenBalance = IERC20(optToken.tokenAddress()).balanceOf(
            address(this)
        );
        IERC20(optToken.tokenAddress()).transfer(devAdd, tokenBalance); //赎回标的到开发者地址
        emit BurnOptToken(optBalance, tokenBalance);
    }
}
