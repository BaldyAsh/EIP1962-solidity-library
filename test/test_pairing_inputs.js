require('dotenv').config()
const chai = require('chai');
const {deployContract, solidity} = require('ethereum-waffle');
const ethers = require('ethers');

const TEST_CONTRACT = require('../build/TestPairingInputs');

chai.use(solidity);
const {expect} = chai;

describe('Test Pairing Inputs', () => {
  let provider = new ethers.providers.JsonRpcProvider(process.env.JSON_RPC_URL);
  let wallet = new ethers.Wallet(process.env.WALLET_PK, provider);
  let contract;

  beforeEach(async () => {
    contract = await deployContract(wallet, TEST_CONTRACT, [], {
      gasLimit: 8000000
    });
    expect(contract.address).to.be.properAddress;
    console.log("Test address:" + contract.address);
  });

  it('Pairing Input lengths for BLS12-384-M curve', async () => {
    let result = await contract.testPairingInputLengthsBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('Pairing Input for BLS12-384-M curve', async () => {
    let result = await contract.testFormPairingInputBLS12_384_M();
    expect(result).to.eq(true);
  });
});