pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

// IMPORTS
import { Task } from './task.sol';
import { DeviceManager } from './device_manager.sol';

contract TaskManager {

    // MAP OF TASKS & RESULTS
    mapping (address => Task) public tasks;
    mapping (address => result) public results;

    // TASK RESULT PARAMS
    struct result {
        string encryption_key;
        string storage_location;
    }

    // INIT STATUS
    bool public initialized = false;

    // DEVICE MANAGER REF
    DeviceManager public device_manager;

    // FETCH SPECIFIC TASK
    function fetch_task(address task) public view returns(Task) {
        return tasks[task];
    }

    // FETCH TASK RESULT
    function fetch_result(address task) public view returns(result memory) {
        return results[task];
    }

    // ADD NEW TASK
    function create(
        string memory device,
        string memory encryption_key,
        string memory params
    ) public {

        // IF CONTRACT HAS BEEN INITIALIZED
        require(initialized, 'contracts have not been initialized');
        
        // IF THE DEVICE EXISTS
        // IF THE DEVICE IS OWNED BY THE SENDER
        // IF THE DEVICE IS SET TO ACTIVE
        require(device_manager.exists(device), 'the device is not registered');
        require(msg.sender == device_manager.fetch_device(device).owner(), 'you are not the device owner');
        require(device_manager.fetch_device(device).active(), 'the device is not active');

        // INSTANTIATE & INDEX NEW TASK
        Task task = new Task(msg.sender, device, encryption_key, params);
        tasks[address(task)] = task;

        // ASSIGN THE TASK TO THE DEVICE
        device_manager.fetch_device(device).assign_task(address(task));
    }

    // COMPLETE TASK BY SUBMITTING RESULT
    function complete(
        address task_address,
        string memory encryption_key,
        string memory storage_location
    ) public {

        // IF THE TASK EXISTS
        require(exists(task_address), 'task does not exist');

        // SHORTHAND FOR TASK
        Task task = fetch_task(task_address);

        // IF THE SENDER IS THE ASSIGNED DEVICE
        require(msg.sender == device_manager.fetch_device(task.device()).account(), 'the task is not assigned to this device');

        // CONSTRUCT & PUSH NEW RESULT
        results[task_address] = result({
            encryption_key: encryption_key,
            storage_location: storage_location
        });

        // CLEAR TASK FROM DEVICE BACKLOG & DESTROY THE TASK
        device_manager.fetch_device(task.device()).clear_task(task_address, true);
        task.destroy();
    }

    // RELEASE THE TASK
    function dissolve(address task_address) public {

        // IF THE TASK EXISTS
        require(exists(task_address), 'task does not exist');

        // SHORTHAND FOR TASK
        Task task = fetch_task(task_address);

        // IF THE SENDER IS THE CREATOR
        require(task.creator() == msg.sender, 'you are not the tasks creator');

        // CLEAR TASK FROM DEVICE BACKLOG & DESTROY THE TASK
        device_manager.fetch_device(task.device()).clear_task(task_address, false);
        task.destroy();
    }

    // INITIALIZE
    function init(address _device_manager) public {

        // IF THE CONTRACT HAS NOT BEEN INITIALIZED
        require(!initialized, 'contract has already been initialized');

        // SET REF
        device_manager = DeviceManager(_device_manager);

        // BLOCK FURTHER MODIFICATION
        initialized = true;
    }

    // CHECK IF TASK EXISTS
    function exists(address _task) public view returns(bool) {
        if (address(tasks[_task]) != 0x0000000000000000000000000000000000000000) {
            return true;
        } else {
            return false;
        }
    }
}