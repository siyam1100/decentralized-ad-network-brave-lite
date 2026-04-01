// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title AdNetwork
 * @dev Manages ad campaigns and distributes rewards for user attention.
 */
contract AdNetwork is Ownable, ReentrancyGuard {
    struct Campaign {
        address advertiser;
        uint256 budget;
        uint256 rewardPerAction;
        bool active;
    }

    IERC20 public immutable paymentToken;
    mapping(uint256 => Campaign) public campaigns;
    uint256 public nextCampaignId;

    mapping(uint256 => mapping(address => bool)) public hasClaimed;

    event CampaignCreated(uint256 indexed id, address indexed advertiser, uint256 budget);
    event RewardDistributed(uint256 indexed id, address indexed user, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        paymentToken = IERC20(_token);
    }

    function createCampaign(uint256 _budget, uint256 _rewardPerAction) external {
        paymentToken.transferFrom(msg.sender, address(this), _budget);
        
        campaigns[nextCampaignId] = Campaign({
            advertiser: msg.sender,
            budget: _budget,
            rewardPerAction: _rewardPerAction,
            active: true
        });

        emit CampaignCreated(nextCampaignId++, msg.sender, _budget);
    }

    /**
     * @dev Distributes rewards. In production, this would require a ZK-proof 
     * or an Oracle signature to verify the ad was actually viewed.
     */
    function claimReward(uint256 _campaignId) external nonReentrant {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.active, "Campaign inactive");
        require(campaign.budget >= campaign.rewardPerAction, "Budget exhausted");
        require(!hasClaimed[_campaignId][msg.sender], "Already claimed");

        campaign.budget -= campaign.rewardPerAction;
        hasClaimed[_campaignId][msg.sender] = true;
        
        paymentToken.transfer(msg.sender, campaign.rewardPerAction);
        
        emit RewardDistributed(_campaignId, msg.sender, campaign.rewardPerAction);
    }

    function deactivateCampaign(uint256 _campaignId) external {
        require(campaigns[_campaignId].advertiser == msg.sender, "Not your campaign");
        campaigns[_campaignId].active = false;
        
        uint256 remaining = campaigns[_campaignId].budget;
        campaigns[_campaignId].budget = 0;
        paymentToken.transfer(msg.sender, remaining);
    }
}
