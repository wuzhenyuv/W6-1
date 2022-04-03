let { ethers } = require("hardhat");

async function main() {
  let [owner] = await ethers.getSigners();
  //部署期权代币，用atToken兑换期权代币，atToken也用来兑换目标代币bat
  let atToken = "0x30BE9592439516A433f77924Fb34ca14ac675686";
  let bat = "0x2d12186Fbb9f9a8C28B3FfdD4c42920f8539D738";
  // getting timestamp
  const blockNumCurrent = await ethers.provider.getBlockNumber();
  const blockCurrent = await ethers.provider.getBlock(blockNumCurrent);
  const blockTimestamp = blockCurrent.timestamp;
  let OptionToken = await ethers.getContractFactory("OptionToken");
  //设置部署完5分钟后可以行权，行权时间也是5分钟，5分钟后超时,设置兑换目标代币bat的兑换价格为1000个atToken
  let optionToken = await OptionToken.deploy(blockTimestamp+600,bat,atToken,1000, { gasLimit: 8000000 });
  await optionToken.deployed();
  console.log("optionToken:" + optionToken.address);

   //部署期权合约
   let OptionContract = await ethers.getContractFactory("OptionContract");
   let optionContract = await OptionContract.deploy(optionToken.address, { gasLimit: 8000000 });
   await optionContract.deployed();
   console.log("optionContract:" + optionContract.address);

   //把期权代币合约的管理员权限转到期权合约上
   await optionToken.transferOwnership(optionContract.address);
   console.log("已把期权代币合约权限转移");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
