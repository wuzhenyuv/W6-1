let { ethers } = require("hardhat");
const json_optionToken = require("../artifacts/contracts/OptionToken.sol/OptionToken.json");
const json_Token = require("../artifacts/@openzeppelin/contracts/token/ERC20/ERC20.sol/ERC20.json");
const json_optionContract = require("../artifacts/contracts/OptionContract.sol/OptionContract.json");


async function main() {
  let [owner] = await ethers.getSigners();
  let optionTokenAddr = "0xa34308e31f79b8f5Eef2e92e6E1949307a3E68Cf";
  let optionContractAddr = "0x3Ea076bd9dae3fF545d1aD38646eBaAE4c688588";
  let batAddr = "0x2d12186Fbb9f9a8C28B3FfdD4c42920f8539D738";
  let atTokenAddr = "0x30BE9592439516A433f77924Fb34ca14ac675686";
  let devAddress = "0x9F25398f8aCd39aa8d476a2F057F5CB6255371D4";
  let optionToken = new ethers.Contract(optionTokenAddr, json_optionToken["abi"], owner);
  let optionContract = new ethers.Contract(optionContractAddr, json_optionContract["abi"], owner);
  let batToken = new ethers.Contract(batAddr, json_Token["abi"], owner);
  let atToken = new ethers.Contract(atTokenAddr, json_Token["abi"], owner);
  //转入1000个
  await batToken.approve(optionContractAddr, ethers.constants.MaxUint256);
  await atToken.approve(optionContractAddr, ethers.constants.MaxUint256);
  console.log("完成授权");
  let tokenAmount = ethers.utils.parseUnits("1000", 18);
  await optionContract.issueOptToken(tokenAmount, { gasLimit: 8000000 });
  console.log("完成发行1000个期权代币");
  //行权
  await optionToken.approve(optionContractAddr, ethers.constants.MaxUint256);
  let tokenAmount = ethers.utils.parseUnits("1", 18);
  await optionContract.excuteOption(tokenAmount, { gasLimit: 8000000 })
  console.log("完成行权");
  await optionContract.burnOptToken(devAddress);
  console.log("完成过期销毁");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
