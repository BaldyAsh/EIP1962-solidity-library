require('dotenv').config()
const chai = require('chai');
const {deployContract, solidity} = require('ethereum-waffle');
const ethers = require('ethers');

const TEST_CONTRACT = require('../build/TestRaw');

chai.use(solidity);
const {expect} = chai;

describe('Test Raw', () => {
  let provider = new ethers.providers.JsonRpcProvider(process.env.JSON_RPC_URL);
  let wallet = new ethers.Wallet(process.env.WALLET_PK, provider);
  let contract;

  beforeEach(async () => {
    contract = await deployContract(wallet, TEST_CONTRACT, [], {
      gasLimit: 8000000
    });
    expect(contract.address).to.be.properAddress;
    console.log("Test address:" + contract.address);
    contract = new ethers.Contract(contract.address, TEST_CONTRACT.abi, provider);
  });

  it('testG1Add_BLS12_384_M', async () => {
    let result = await contract.testG1Add_BLS12_384_M();
    expect(result).to.eq(true);
  });

  it('testG1Mul_BLS12_384_M', async () => {
    let result = await contract.testG1Mul_BLS12_384_M();
    expect(result).to.eq(true);
  });

  it('testG1Multiexp_BLS12_384_M', async () => {
    let result = await contract.testG1Multiexp_BLS12_384_M();
    expect(result).to.eq(true);
  });

  it('testG2Add_BLS12_384_M', async () => {
    let result = await contract.testG2Add_BLS12_384_M();
    expect(result).to.eq(true);
  });

  it('testG2Mul_BLS12_384_M', async () => {
    let result = await contract.testG2Mul_BLS12_384_M();
    expect(result).to.eq(true);
  });

  it('testG2Multiexp_BLS12_384_M', async () => {
    let result = await contract.testG2Multiexp_BLS12_384_M();
    expect(result).to.eq(true);
  });

  it('testPairing_BLS12_384_M', async () => {
    let result = await contract.testPairing_BLS12_384_M();
    expect(result).to.eq(true);
  });
});