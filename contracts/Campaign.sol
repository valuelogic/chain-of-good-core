pragma solidity ^0.8.11;

import "./ILendingPool.sol";
import "./ILendingPoolAddressProvider.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Campaign {
    struct Info {
        uint32 startTime;
        uint32 endTime;
        address beneficiaryWallet;
        uint256 donationPool;
        uint256 collectedReward;
        uint256 additionalPassedFounds;
        string metadataUrl;
    }

    bool campaignEnded;
    IERC20 public token;
    ILendingPool public lendingPool;
    Info public info;

    mapping(address => uint256) public donorsToDonation;

    event Donated(address indexed who, uint256 amount);
    event CampaignEnded(uint256 reward);

    constructor(
        uint32 _startTime,
        uint32 _endTime,
        address _token,
        address _lendingPool,
        address _beneficiaryWallet,
        string memory _metadataUrl
    ) {
        info.startTime = _startTime;
        info.endTime = _endTime;
        info.beneficiaryWallet = _beneficiaryWallet;
        info.metadataUrl = _metadataUrl;

        token = IERC20(_token);
        lendingPool = ILendingPool(_lendingPool);

        token.approve(address(lendingPool), type(uint256).max);
    }

    //The donation token needs to be approved by donor, before this method is called
    function donate(uint256 amount) external {
        require(
            block.timestamp >= info.startTime && block.timestamp < info.endTime,
            "The campaign is not int progress."
        );

        token.transferFrom(msg.sender, address(this), amount);
        lendingPool.deposit(address(token), amount, address(this), 0);

        info.donationPool += amount;
        donorsToDonation[msg.sender] += amount;

        emit Donated(msg.sender, amount);
    }

    function endCampaing() external {
        require(
            block.timestamp >= info.endTime,
            "The campaign hasn't ended yet."
        );

        uint256 amount = lendingPool.withdraw(
            address(token),
            type(uint256).max,
            address(this)
        );

        info.collectedReward = amount - info.donationPool;

        token.transfer(info.beneficiaryWallet, info.collectedReward);
        campaignEnded = true;
    }

    //to remove
    function forceEnd() external {
        uint256 amount = lendingPool.withdraw(
            address(token),
            type(uint256).max,
            address(this)
        );

        info.collectedReward = amount - info.donationPool;
        token.transfer(info.beneficiaryWallet, info.collectedReward);
        campaignEnded = true;
    }

    function giveMyFoundsBack(uint256 amount) public {
        require(
            amount <= donorsToDonation[msg.sender],
            "You donated less than you want to get back"
        );

        if (!campaignEnded) {
            lendingPool.withdraw(address(token), amount, address(this));
        }

        token.transfer(msg.sender, amount);
        info.donationPool -= amount;
        donorsToDonation[msg.sender] -= amount;
    }

    function giveAllMyFoundsBack() external {
        giveMyFoundsBack(donorsToDonation[msg.sender]);
    }

    function splitMyFounds(uint256 toCharity) public {
        require(
            toCharity <= donorsToDonation[msg.sender],
            "You've donanted less than you want to split"
        );
        require(campaignEnded, "The campaign hasn't edned yet");

        token.transfer(info.beneficiaryWallet, toCharity);

        uint256 difference = donorsToDonation[msg.sender] - toCharity;

        if (difference > 0) {
            token.transfer(msg.sender, difference);
        }

        info.donationPool -= donorsToDonation[msg.sender];
        donorsToDonation[msg.sender] -= 0;
        info.additionalPassedFounds += toCharity;
    }

    function transferAllMyFoundsToCharity() external {
        splitMyFounds(donorsToDonation[msg.sender]);
    }
}
