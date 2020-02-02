require('dotenv').config()
const chai = require('chai');
const {deployContract, solidity} = require('ethereum-waffle');
const ethers = require('ethers');

const TEST_CONTRACT = require('../build/TestCurveParams');

chai.use(solidity);
const {expect} = chai;

describe('Test Curve Params', () => {
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

  it('Curve params lengths BLS12-384-M curve', async () => {
    let result = await contract.testCurveParamsLengthsBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G1 op_data for BLS12-384-M curve', async () => {
    let result = await contract.testG1OpDataBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('G2 op_data for BLS12-384-M curve', async () => {
    let result = await contract.testG2OpDataBLS12_384_M();
    expect(result).to.eq(true);
  });

  it('Pairing op_data for BLS12-384-M curve', async () => {
    let result = await contract.testPairingOpDataBLS12_384_M();
    expect(result).to.eq(true);
  });
});