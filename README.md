# Basic Staking dApp - Road To Web3 by Alchemy - Week 6

Install project dependencies with `yarn install`

Run the project with the following commands, You'll have three terminals up for:

```bash
yarn chain   (hardhat backend)
yarn deploy  (to compile, deploy, and publish your contracts to the frontend)
yarn start   (react app frontend)
```

1. Rewards are calculated using a very basic quadratic function.
2. Users can stake any amount of ETH greater than `0.1`
3. Owner account (white-listed) in ExampleExternalContract can withdraw the balance back to Staker contract once staking is completed (executed)
4. Helper function to reset times in Staker contract is included.
