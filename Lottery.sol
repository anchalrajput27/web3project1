
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum ETH not sent");
        players.push(msg.sender);
    }
    
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length)));
    }
    
    function pickWinner() public restricted {
        require(players.length > 0, "No players in the lottery");
        uint index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);
        players = new address[](0);
    }
    
    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this");
        _;
    }
}
