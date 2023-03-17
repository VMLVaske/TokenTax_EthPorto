// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FundingTracker {
    struct Sender {
        uint256 totalAmountSent;
        bool isStored;
    }

    mapping(address => Sender) private senders;
    address public taxManagerContract;
    uint256 public minerMaintenanceCost; // in percentage (e.g. 5%)

    function isAddressStored(
        address _senderAddress
    ) public view returns (bool) {
        return senders[_senderAddress].isStored;
    }

    function getTotalAmountSent(
        address _senderAddress
    ) public view returns (uint256) {
        require(
            senders[_senderAddress].isStored,
            "Sender address is not stored"
        );
        return senders[_senderAddress].totalAmountSent;
    }

    function invokeTaxes(address _senderAddress) public {
        Sender storage sender = senders[_senderAddress];
        require(sender.isStored, "Sender address is not stored");
        require(sender.totalAmountSent > 0, "Sender has not sent any funds");
        uint256 totalAmountSent = sender.totalAmountSent;
        uint256 maintenanceFee = (totalAmountSent * minerMaintenanceCost) / 100;
        uint256 remainingAmount = totalAmountSent - maintenanceFee;
        sender.totalAmountSent = 0;
        if (remainingAmount > 0) {
            require(
                taxManagerContract != address(0),
                "Tax manager contract address is not set"
            );
            (bool success, ) = taxManagerContract.call{value: remainingAmount}(
                ""
            );
            require(success, "Tax transfer failed");
        }
    }

    function sendFunds() public payable {
        Sender storage sender = senders[msg.sender];
        if (!sender.isStored) {
            sender.isStored = true;
        }
        sender.totalAmountSent += msg.value;
    }

    function setTaxManagerContract(address _taxManagerContract) public {
        require(
            _taxManagerContract != address(0),
            "Invalid tax manager contract address"
        );
        taxManagerContract = _taxManagerContract;
    }

    function setMinerMaintenanceCost(uint256 _minerMaintenanceCost) public {
        minerMaintenanceCost = _minerMaintenanceCost;
    }
}
