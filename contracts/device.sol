pragma solidity ^0.7.0;
// SPDX-License-Identifier: MIT

contract Device {

    // THE OWNER OF THE DEVICE
    address public owner;

    // ACTIVE STATUS
    bool public active;

    // THE DEVICES UNIQUE ETH ACCOUNT
    address public account;

    // ITERABLE TASK BACKLOG
    address[] public backlog;

    // ITERABLE LIST OF TASK RESULTS
    address[] public results;

    // TASK MANAGER REFERENCE
    address public task_manager;

    // CONTRACT MODIFICATION EVENT
    event modification(address[] backlog);

    // UPON CREATION, SET STATIC PARAMS
    constructor(
        address _owner,
        address _account,
        address _task_manager
    ) {
        owner = _owner;
        account = _account;
        task_manager = _task_manager;
    }

    // TOGGLE ACTIVE STATUS
    function toggle_active() public {

        // IF THE SENDER IS THE OWNER
        require(msg.sender == owner, 'permission denied');

        // TOGGLE ACTIVE STATUS
        active = !active;
    }

    // ASSIGN TASK TO DEVICE
    function assign_task(address _task) public {

        // IF THE SENDER IS THE TASK MANAGER
        require(msg.sender == task_manager, 'permission denied');

        // ADD TASK TO BACKLOG & EMIT EVENT
        backlog.push(_task);
        emit modification(backlog);
    }

    // CLEAR FINISHED TASK FROM BACKLOG
    function clear_task(address task_address, bool approved) public {

        // IF THE SENDER IS THE TASK MANAGER
        require(msg.sender == task_manager, 'permission denied');

        // LOOP & ATTEMPT TO FIND THE TASK
        for(uint index = 0; index < backlog.length; index++) {

            // IF ITS FOUND
            if (address(backlog[index]) == task_address) {

                // DELETE TARGET
                delete backlog[index];

                // ADD RESULT REFERENCE WHEN TASK MANAGER APPROVES IT
                if (approved) {
                    results.push(task_address);
                }

                // EMIT EVENT
                emit modification(backlog);
            }
        }
    }
}