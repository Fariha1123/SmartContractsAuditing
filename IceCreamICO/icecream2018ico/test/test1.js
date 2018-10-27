const RecToken = artifacts.require("RecToken");
const RecTokenCrowdsale = artifacts.require("RecTokenCrowdsale");

contract('RecToken ICO', function(accounts) {
    console.log("\n----------- Test Case  ------------\n");

    const owner = accounts[0];
    const team = accounts[9];
    const reservation = accounts[8];
    const bounty = accounts[7];
    var token;
    var crowdsale;

    it("Create Token", async () => { 
        await RecToken.deployed().then( async (instance) => {
            token = instance;
        });
    })

    it("Token Name", async () => { 
       const name = await token.name();
       console.log('\n1.1) Token name:', name);
       assert.equal(name, 'REC COIN', 'token name is wrong');
    });

    it("Token Symbol", async () => { 
       const symbol = await token.symbol();
       console.log('\n1.2) Token Symbol:', symbol);
       assert.equal(symbol, 'REC', 'token symbol is wrong');
    });

    it("Token Decimals", async () => { 
        const decimal = await token.decimals();
        console.log('\n1.3) Token Decimal:', decimal.toNumber());
        assert.equal(decimal.toNumber(), 18, 'Decimals is wrong');
    });

    it("Token Total Supply", async () => { 
        const totalSupply = await token.totalSupply.call();
        console.log('\n1.4) Token Total supply:', totalSupply);
        assert.equal(totalSupply.toNumber(), 10E26, 'Total supply is wrong');
    });

    it("Create CrowdSale", async () => {
        crowdsale = await RecTokenCrowdsale.deployed();
        console.log("\n\n2. Created CrowdSale:");
    });

    it("Owner Balance", async () => {
        let ownerBalance =  await token.balanceOf.call(owner);
        console.log('\n2.1) Owner Balance:', ownerBalance.toNumber());
        assert.equal(ownerBalance, 2E26, 'owner balance is wrong');
    });

    it("Team Balance", async () => {
        const teamBalance =  await token.balanceOf.call(team);
        console.log('\n2.2) Team Balance:', teamBalance.toNumber());
        assert.equal(teamBalance, 1E26, 'team wallet balance is wrong');
    });

    it("Reservation Balance", async () => {
        const reservationBalance =  await token.balanceOf.call(reservation);
        console.log('\n2.3) Reservation Balance:', reservationBalance.toNumber());
        assert.equal(reservationBalance, 5E26, 'Reservation wallet balance is wrong');
    });

    it("Bounty Balance", async () => {
        const bountyBalance =  await token.balanceOf.call(bounty);
        console.log('\n2.4) Bounty Balance:', bountyBalance.toNumber());
        assert.equal(bountyBalance, 2E26, 'Bounty wallet balance is wrong');
    });

    it("Transfer", async () => {
        await token.transfer(accounts[1], 500000);
        ownerBalance = await token.balanceOf.call(owner);
        const test1Balance = await token.balanceOf.call(accounts[1]);
        console.log('\n2.5) Transfer 500000 to account[1], current account[1] balance:', test1Balance.toNumber());
        assert.equal(test1Balance.toNumber(), 500000, 'accounts[1] balance is wrong');
    });
        /** Approve **/
    it("Approve", async () => {
        await token.approve(accounts[1], 200000);
        const allowance = await token.allowance.call(accounts[0], accounts[1]);
        assert.equal(allowance.toNumber(), 200000, 'allowance is wrong');
        console.log('\n2.6) Allowance 200000 to account[1], current account[1] allowance:', allowance.toNumber());
    });

    it("Transfer From", async () => {
        /** TransferFrom **/
        console.log('\n2.7) 200000 TransferFrom to account[0] to account[2]:');

        let account0Balance = await token.balanceOf.call(accounts[0]);
        let account2Balance = await token.balanceOf.call(accounts[2]);
        console.log('\n Before transferFrom account[0] balance:', account0Balance.toNumber(), 'acccount[2] balance:', account2Balance.toNumber());

        await token.transferFrom(accounts[0], accounts[2], 200000, {from: accounts[1]});
        account0Balance = await token.balanceOf.call(accounts[0]);
        account2Balance = await token.balanceOf.call(accounts[2]);
        console.log('\n After transferFrom account[0] to balance:', account0Balance.toNumber(), 'acccount[2] balance:', account2Balance.toNumber());
    });
});