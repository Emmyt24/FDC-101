# Sports Score Oracle

A decentralized oracle for sports match results built using Flare's Data Connector (FDC) Web2Json attestations. This contract enables trustless sports betting, prediction markets, and fantasy sports applications on the blockchain.

## Overview

The Sports Score Oracle fetches verified sports match data from external APIs and stores it on-chain using Flare's decentralized verification system. It demonstrates how to bring real-world sports data onto the blockchain in a trust-minimized way.

## Features

- **Decentralized Verification**: Uses FDC validators to verify sports data independently
- **Web2Json Integration**: Fetches data from Football-Data.org API (free tier)
- **On-chain Storage**: Permanently stores verified match results
- **Multiple Sports Support**: Easily extensible to different sports/leagues
- **Timestamp Tracking**: Records match completion times for settlement

## Contract Structure

### Data Structures

```solidity
struct MatchResult {
    string homeTeam;
    string awayTeam;
    uint256 homeScore;
    uint256 awayScore;
    uint256 matchId;
    uint256 timestamp;
}
```

### Functions

- `addMatchResult(IWeb2Json.Proof calldata data)`: Adds a verified match result to the contract
- `getAllMatchResults() view returns (MatchResult[] memory)`: Returns all stored match results

## How It Works

1. **Data Request**: Script submits attestation request to FDC Hub with Football-Data.org API URL
2. **Decentralized Verification**: Flare validators fetch and verify match data independently
3. **Proof Generation**: DA Layer creates cryptographic proof of consensus
4. **On-chain Storage**: Contract verifies proof and stores match result permanently

## Usage

### Prerequisites

- Node.js v16+
- Yarn package manager
- Flare testnet tokens (Coston2)
- Football-Data.org API key (free sign-up)

### Running the Example

```bash
# Install dependencies
yarn install

# Set up environment
cp .env.example .env
# Edit .env with your PRIVATE_KEY and API keys

# Run the sports oracle
yarn hardhat run scripts/sportsScoreOracle/SportsScoreOracle.ts --network coston2
```

### Expected Output

```
SportsScoreOracle deployed to 0x...
Proof hex: 0x...
Decoded proof: {...}
Transaction: 0x...
Sports Match Results:
[
  {
    homeTeam: "Manchester United",
    awayTeam: "Liverpool",
    homeScore: 2,
    awayScore: 1,
    matchId: 123456,
    timestamp: 1640995200
  }
]
```

## API Integration

### Football-Data.org

- **URL**: `https://api.football-data.org/v4/matches/{matchId}`
- **Authentication**: `X-Auth-Token` header (free tier available)
- **Data Format**: JSON with match details, scores, and timestamps

### JQ Processing

```javascript
{
  homeTeam: .homeTeam.name,
  awayTeam: .awayTeam.name,
  homeScore: .score.fullTime.home,
  awayScore: .score.fullTime.away,
  matchId: .id,
  timestamp: .utcDate | strptime("%Y-%m-%dT%H:%M:%SZ") | strftime("%s") | tonumber
}
```

## Use Cases

### Sports Betting
- Decentralized betting platforms
- Prediction markets for match outcomes
- Over/under betting on scores

### Fantasy Sports
- Automated scoring systems
- Real-time player statistics
- League management

### Gaming
- Sports-themed blockchain games
- Achievement systems
- Tournament brackets

## Configuration

### Environment Variables

```bash
# Required
PRIVATE_KEY=your_private_key_here
VERIFIER_API_KEY_TESTNET=your_verifier_key

# Optional
FLARE_RPC_API_KEY=your_flare_api_key
FOOTBALL_DATA_API_KEY=your_football_data_key
```

### Network Support

- **Coston2 Testnet**: Primary testing network
- **Flare Mainnet**: Production deployment ready

## Security Considerations

- **Proof Verification**: All data is cryptographically verified by FDC
- **Validator Consensus**: Requires supermajority agreement
- **Timestamp Validation**: Prevents replay attacks with timestamp checks
- **Duplicate Prevention**: Match IDs prevent duplicate entries

## Extending the Oracle

### Adding New Sports

1. Update API endpoint in the script
2. Modify JQ filter for new data structure
3. Adjust ABI signature for new fields
4. Test with sample data

### Multiple Matches

The contract can store multiple match results. Consider pagination for large datasets.

### Real-time Updates

For live score updates, implement event-driven architecture with off-chain monitoring.

## Contributing

1. Test thoroughly on Coston2 testnet
2. Follow existing code patterns
3. Update documentation
4. Submit PR with clear description

## Links

- [FDC Documentation](https://dev.flare.network/fdc/)
- [Football-Data.org API](https://www.football-data.org/)
- [Flare Developer Hub](https://dev.flare.network/)
- [Coston2 Explorer](https://coston2-explorer.flare.network/)