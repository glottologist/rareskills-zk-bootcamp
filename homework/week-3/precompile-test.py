import json
from web3 import Web3, AsyncWeb3, HTTPProvider

abi_file_path = "output/precompile.abi"

# Read the ABI file
with open(abi_file_path, "r") as abi_file:
    contract_abi = json.load(abi_file)


bytecode_file_path = "output/precompile.bin"

# Read the bytecode file
with open(bytecode_file_path, "r") as bytecode_file:
    contract_bytecode = bytecode_file.read().strip()


w3 = AsyncWeb3(AsyncWeb3.AsyncHTTPProvider("http://127.0.0.1:8545"))

assert w3.is_connected()

PrecompileContract = w3.eth.contract(abi=contract_abi, bytecode=contract_bytecode)


tx_hash = PrecompileContract.constructor().transact()
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

# Get the deployed contract instance by its address
deployed_contract = w3.eth.contract(
    address=tx_receipt.contractAddress, abi=contract_abi
)
