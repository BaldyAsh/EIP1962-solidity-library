require('dotenv').config()
const chai = require('chai');
const {deployContract, solidity} = require('ethereum-waffle');
const ethers = require('ethers');

const TEST_CONTRACT = require('../build/TestBytes');

chai.use(solidity);
const {expect} = chai;

describe('Test Bytes', () => {
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

  it('Equal', async () => {
    let result = await contract.testEqual();
    expect(result).to.eq(true);
  });

  it('Not equal', async () => {
    let result = await contract.testNotEqual();
    expect(result).to.eq(false);
  });

  it('To bytes from uint8 correct', async () => {
    let result = await contract.testToBytesFromUInt8Correct();
    expect(result).to.eq(true);
  });

  it('To bytes from uint8 not correct', async () => {
    let result = await contract.testToBytesFromUInt8NotCorrect();
    expect(result).to.eq(false);
  });

  it('Concat correct', async () => {
    let result = await contract.testConcatEqual();
    expect(result).to.eq(true);
  });

  it('Concat not correct', async () => {
    let result = await contract.testConcatNotEqual();
    expect(result).to.eq(false);
  });
});