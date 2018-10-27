# Installation

1. install truffle
`sudo npm install -g truffle`

2. install npm modules
`npm install`

# Deploy smart contract

1. run testrpc on port 8545 
`testrpc -p 8545`

2. Set addresses 
	set team wallet address in `migrations/2_deploy_contracts.js` file, line 22
	
	set reservation wallet address in `migrations/2_deploy_contracts.js` file, line 23
	
	set bounty wallet address in `migrations/2_deploy_contracts.js` file, line 24
	
	set wallet address in `migrations/2_deploy_contracts.js` file, line 35
	

3. Deploy contract
`truffle migrate`

# How to unit test smart contract with mocha

1. set addresses
set owner address in `test/test1.js` file, line 7 (default: accounts[0])
set team wallet address in `test/test1.js` file, line 8 (same as `migrations/2_deploy_contracts.js file, line 22`)
set reservation wallet address in `test/test1.js` file, line 9 (same as `migrations/2_deploy_contracts.js file, line 23`)
set bounty wallet address in `test/test1.js` file, line 10 (same as `migrations/2_deploy_contracts.js file, line 24`)

2. run unit test
`truffle test`
