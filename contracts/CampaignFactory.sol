pragma solidity ^0.8.9;

import "./Campaign.sol";
import "./ILendingPoolAddressProvider.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CampaignFactory is Ownable {

    ILendingPoolAddressProvider public lendingPoolAddressPovider;
    Campaign[] public campaigns;

    event CampaignCreated(address addr, uint32 startTime, uint32 endTime, address indexed beneficiaryWallet);

    constructor(address _lendingPoolAddressProvider) {
        lendingPoolAddressPovider = ILendingPoolAddressProvider(_lendingPoolAddressProvider);
    }

    function createCampaign( 
        uint32 _startTime,
        uint32 _endTime,
        address _token,
        address _beneficiaryWallet,
        string memory _metadataUrl) external onlyOwner {

            Campaign campaign = new Campaign(_startTime, _endTime, _token, lendingPoolAddressPovider.getLendingPool(), _beneficiaryWallet, _metadataUrl); 
            campaigns.push(campaign);

            emit CampaignCreated(address(campaign), _startTime, _endTime, _beneficiaryWallet);
    }

    function setLendingPoolAddressProvider(address _lendingPoolAddressProvider) external onlyOwner{
        lendingPoolAddressPovider = ILendingPoolAddressProvider(_lendingPoolAddressProvider);
    } 

    function getAllCampaign() external view returns(Campaign[] memory) {
        return campaigns;
    }
    
}