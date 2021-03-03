pragma solidity ^0.7.0;
// SPDX-License-Identifier: MIT

contract Task {

    // OWNER & ASSIGNED DEVICE
    address public creator;
    string public device;

    // PUBLIC ENCRYPTION KEY & ADDITIONAL PARAMS
    string public encryption_key;
    string public params;

    // TASK MANAGER REFERENCE
    address public task_manager;

    // WHEN CREATED..
    constructor(
        address _creator,
        string memory _device,
        string memory _encryption_key,
        string memory _params
    ) {

        // SET STATIC PARAMS
        creator = _creator;
        device = _device;
        encryption_key = _encryption_key;
        params = _params;
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