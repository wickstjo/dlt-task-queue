pragma solidity ^0.7.0;
// SPDX-License-Identifier: MIT

contract Task {

    // OWNER & ASSIGNED DEVICE
    address public creator;
    string public device;

    // PUBLIC ENCRYPTION KEY
    string public encryption_key;

    // TASK MANAGER REFERENCE
    address task_manager;

    // WHEN CREATED..
    constructor(
        address _creator,
        string memory _device,
        string memory _encryption_key
    ) {

        // SET STATIC PARAMS
        creator = _creator;
        device = _device;
        encryption_key = _encryption_key;
        task_manager = msg.sender;
    }

    // SELF DESTRUCT
    function destroy() public {

        // IF THE SENDER IS THE TASK MANAGER
        require(msg.sender == task_manager, 'permission denied');

        // DESTROY THE TASK
        selfdestruct(address(uint160(address(this))));
    }
}