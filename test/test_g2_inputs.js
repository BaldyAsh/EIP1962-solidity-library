require('dotenv').config()
const chai = require('chai');
const {deployContract, solidity} = require('ethereum-waffle');
const ethers = require('ethers');

const TEST_CONTRACT = require('../build/TestG2Inputs');

chai.use(solidity);
const {expect} = chai;

describe('Test G2 Inputs', () => {
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

  it('G2 Add Input lengths for BLS12-384-M curve', async () => {
    let result = await contract.testAddG2InputLengthsBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G2 Mul Input lengths for BLS12-384-M curve', async () => {
    let result = await contract.testMulG2InputLengthsBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G2 MultiExp Input lengths for BLS12-384-M curve', async () => {
    let result = await contract.testMultiExpG2InputLengthsBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G2 Add Input for BLS12-384-M curve', async () => {
    let result = await contract.testFormAddG2InputBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G2 Mul Input for BLS12-384-M curve', async () => {
    let result = await contract.testFormMulG2InputBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G2 MultiExp Input for BLS12-384-M curve', async () => {
    let result = await contract.testFormMultiExpG2InputBLS12_384_M();
    expect(result).to.eq(true);
  });
});