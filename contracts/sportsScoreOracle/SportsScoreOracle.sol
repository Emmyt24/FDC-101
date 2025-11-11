// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ContractRegistry} from "@flarenetwork/flare-periphery-contracts/coston2/ContractRegistry.sol";
import {IWeb2Json} from "@flarenetwork/flare-periphery-contracts/coston2/IWeb2Json.sol";

struct MatchResult {
    string homeTeam;
    string awayTeam;
    uint256 homeScore;
    uint256 awayScore;
    uint256 matchId;
    uint256 timestamp;
}

struct DataTransportObject {
    string homeTeam;
    string awayTeam;
    uint256 homeScore;
    uint256 awayScore;
    uint256 matchId;
    uint256 timestamp;
}

interface ISportsScoreOracle {
    function addMatchResult(IWeb2Json.Proof calldata data) external;
    function getAllMatchResults()
        external
        view
        returns (MatchResult[] memory);
}

contract SportsScoreOracle {
    mapping(uint256 => MatchResult) public matchResults;
    uint256[] public matchIds;

    function addMatchResult(IWeb2Json.Proof calldata data) public {
        require(isJsonApiProofValid(data), "Invalid proof");

        DataTransportObject memory dto = abi.decode(
            data.data.responseBody.abiEncodedData,
            (DataTransportObject)
        );

        require(matchResults[dto.matchId].matchId == 0, "Match result already exists");

        MatchResult memory result = MatchResult({
            homeTeam: dto.homeTeam,
            awayTeam: dto.awayTeam,
            homeScore: dto.homeScore,
            awayScore: dto.awayScore,
            matchId: dto.matchId,
            timestamp: dto.timestamp
        });

        matchResults[dto.matchId] = result;
        matchIds.push(dto.matchId);
    }

    function getAllMatchResults()
        public
        view
        returns (MatchResult[] memory)
    {
        MatchResult[] memory result = new MatchResult[](
            matchIds.length
        );
        for (uint256 i = 0; i < matchIds.length; i++) {
            result[i] = matchResults[matchIds[i]];
        }
        return result;
    }

    function abiSignatureHack(DataTransportObject calldata dto) public pure {}

    function isJsonApiProofValid(
        IWeb2Json.Proof calldata _proof
    ) private view returns (bool) {
        return ContractRegistry.getFdcVerification().verifyJsonApi(_proof);
    }
}