const { getChainId, ethers } = require('hardhat');
const { networkConfig } = require('../helper.hardhat.config');
const hre = require('hardhat');

module.exports = async ({ getNamedAccounts, deployments, getChainid }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  console.log(chainId);

  const lendingPoolAddressProvider =
    networkConfig[chainId]['lendingPoolAddressProvider'];
  const usdcToken = networkConfig[chainId]['usdcToken'];
  const networkName = networkConfig[chainId]['name'];

  const args = [
    1642082396,
    1644760796,
    usdcToken,
    lendingPoolAddressProvider,
    '0x0a2ADD061757642cb126FA677cdEF42685B8A791',
    '',
  ];

  // const Campaign = await deploy('Campaign', {
  //   from: deployer,
  //   log: true,
  //   args: args,
  // });

  const CampaignFactory = await deploy('CampaignFactory', {
    from: deployer,
    log: true,
    args: [lendingPoolAddressProvider]
  });

  // const accounts = await hre.ethers.getSigners();
  // const signer = accounts[0];

  // const token = await ethers.getContractFactory("IERC20");
  // const token = await ethers.getContractAt('IERC20', usdcToken);
  // const Token = new ethers.getContractAt("0x4c6E1EFC12FDfD568186b7BAEc0A43fFfb4bCcCf", token.interface, signer);

  // let tx = await token.approve(
  //   Campaign.address,
  //   ethers.BigNumber.from('100000000000000000000')
  // );
  // await tx.wait();
  // console.log(Campaign.address);
  // console.log('Approved');

  // const campaign = await ethers.getContractFactory('Campaign');
  // const campaignContract = new ethers.Contract(
  //   Campaign.address,
  //   campaign.interface,
  //   signer
  // );

  // let tx2 = await campaignContract.donate(ethers.BigNumber.from('100000000'));
  // await tx2.wait();

  // console.log('Donated');

  // let tx3 = await campaignContract.giveMyFoundsBack(50000000);
  // await tx3.wait();

  // console.log("Withdrawed");

  // let tx4= await campaignContract.giveAllMyFoundsBack();
  // await tx4.wait();

  // console.log("Withdrawed all");

  // let tx5 = await campaignContract.endCampaing();
  // tx5.wait();

  // console.log('Campaign ended');

  //   let tx6 = await campaignContract.splitMyFounds(50000000);
  //   await tx6.wait();

  //   console.log('Founds splited');

  // let tx7 = await campaignContract.transferAllMyFoundsToCharity();
  // tx7.wait();

  // console.log("All founds transfered to the charity");

  console.log('Finished');
};
