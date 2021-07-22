pragma solidity ^0.8.0;

contract Election {
    struct Candidate {
        string name;
        uint voteCount;
    }
    
    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }
    
    address public owner;
    string public electionName;
    
    mapping(address => Voter) private voters;
    Candidate[] private candidates;
    uint private totalVotes;
    
    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }
    
    
    constructor(string memory _name) public {
        owner = msg.sender;
        electionName = _name;
    }
    
    function addCandidate(string memory _name) ownerOnly public {
        candidates.push(Candidate(_name, 0));
    }
    
    function getCandidates() public view returns(Candidate[] memory){
        return candidates;
    }
    
    function getNumCandidate() public view returns(uint){
        return candidates.length;
    }
    
    function authorize(address _person) ownerOnly public {
        voters[_person].authorized = true;
    }
    
    function vote(uint _voteIndex) public {
        require(voters[msg.sender].authorized);
        require(!voters[msg.sender].voted);
        
        voters[msg.sender].vote = _voteIndex;
        voters[msg.sender].voted = true;
    
        candidates[_voteIndex].voteCount += 1;
        totalVotes += 1;
    }
    
    function end() ownerOnly public{
        selfdestruct(payable(owner));
    }
}