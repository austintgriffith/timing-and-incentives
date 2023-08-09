//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
// import "hardhat/console.sol";

// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract YourContract {

	uint256 public round;
	uint256 public roundStart;
	uint8 public constant ROUND_TIME = 60;

	uint256 public payout;

	mapping(address => bool) public player;

	address public immutable owner = 0x98AfB7982F8E86AC8944Bd3c1b6376D1B8033944;

	function addPlayer(address _player) public {
		require(round == 0, "The game has already started");
		require(msg.sender == owner, "Only the owner can add a player");
		player[_player] = true;
	}

 	function startGame() public payable {
		require(msg.sender == owner, "Only the owner can start the game");
		require(round == 0, "The game has already started");
		require(msg.value > 0.001 ether , "plz send funds ser");
		payout = msg.value/10;
		round = 1;
		roundStart = block.timestamp;
	}

	function checkIn() public {
		require(round > 0, "game has not started");
		require(player[msg.sender], "You are not a player");
		require(block.timestamp - roundStart > ROUND_TIME, "You are too early");
		round++;
		roundStart = block.timestamp;
		//send funds to msgsender
		(bool sent, ) = msg.sender.call{value: payout}("");
        require(sent, "Failed to send Ether");
	}

	function timeLeft() public view returns(uint256) {
		if (block.timestamp - roundStart > ROUND_TIME) {
			return 0;
		}
		return ROUND_TIME - (block.timestamp - roundStart);
	}

}
