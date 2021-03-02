pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

// IMPORTS
import { Device } from './device.sol';
import { UserManager } from './user_manager.sol';

contract DeviceManager {

    // MAP OF ALL DEVICES & DEVICE COLLECTIONS
    mapping (string => Device) devices;
    mapping (address => string[]) collections;

    // INIT STATUS
    bool initialized = false;

    // MANAGER REFERENCE
    UserManager user_manager;
    address task_manager;

    // FETCH DEVICE CONTRACT
    function fetch_device(string memory device_hash) public view returns(Device) {
        return devices[device_hash];
    }

    // FETCH USER DEVICE COLLECTION
    function fetch_collection(address user) public view returns(string[] memory) {
        return collections[user];
    }

    // ADD NEW DEVICE
    function create(string memory device_hash) public {

        // IF THE CONTRACT HAS BEEN INITIALIZED
        // IF THE USER IS REGISTERED
        require(initialized, 'contract has not been initialized');
        require(user_manager.exists(msg.sender), 'you need to be a registered user');

        // INSTANTIATE A NEW DEVICE
        Device device = new Device(msg.sender, task_manager);

        // PUSH IT TO BOTH CONTAINERS
        devices[device_hash] = device;
        collections[msg.sender].push(device_hash);
    }

    // SET STATIC VARIABLES
    function init(
        address _user_manager,
        address _task_manager
    ) public {

        // IF THE CONTRACT HAS NOT BEEN INITIALIZED BEFORE
        require(!initialized, 'contract has already been initialized');

        // SET REFERENCES
        user_manager = UserManager(_user_manager);
        task_manager = _task_manager;

        // BLOCK FURTHER MODIFICATIONS
        initialized = true;
    }

    // CHECK IF DEVICE EXISTS
    function exists(string memory device_address) public view returns(bool) {
        if (address(devices[device_address]) != 0x0000000000000000000000000000000000000000) {
            return true;
        } else {
            return false;
        }
    }
}