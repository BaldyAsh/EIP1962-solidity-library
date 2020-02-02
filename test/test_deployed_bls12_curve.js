require('dotenv').config()
const chai = require('chai');
const {deployContract, solidity} = require('ethereum-waffle');
const ethers = require('ethers');

const TEST_CONTRACT = require('../build/TestDeployedBLS12Curve');

chai.use(solidity);
const {expect} = chai;

describe('Test Deployed BLS12 Curve', () => {
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

  it('G1 Add', async () => {
    let result = await contract.testAddG1();
    expect(result).to.eq(true);
  });

  // it('G1 Mul', async () => {
  //   let result = await contract.testMulG1();
  //   expect(result).to.eq(true);
  // });

  // it('G1 MultiExp', async () => {
  //   let result = await contract.testMultiExpG1();
  //   expect(result).to.eq(true);
  // });

  // it('G2 Add', async () => {
  //   let result = await contract.testAddG2();
  //   expect(result).to.eq(true);
  // });

  // it('G2 Mul', async () => {
  //   let result = await contract.testMulG2();
  //   expect(result).to.eq(true);
  // });

  // it('G2 MultiExp', async () => {
  //   let result = await contract.testMultiExpG2();
  //   expect(result).to.eq(true);
  // });

  // it('Pairing', async () => {
  //   let result = await contract.testPairing();
  //   expect(result).to.eq(true);
  // });
});