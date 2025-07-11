// This JavaScript snippet is added in the "Script" section of the PowerShell Action in ServiceNow.

// It:
// - Splits the PowerShell output
// - Parses the last line as JSON
// - Maps the following values into action outputs:
//   - `status` – 0: success, 1: error, 2: already exists
//   - `error_message` – Errors (if any)
//   - `member_count` – Total added members
//   - `members_list` – List of successfully added members
//   - `nonmembers_list` – List of members that couldn’t be added
//   - `dl_id` – GUID of the created DL

function execute(inputs, outputs) {
    // Fetch output from PowerShell script
    var result = inputs.result || "";

    if (result) {
        var lines = result.split('\n'); // Split output into lines
        var result_json = {};

        // Parse the last line of output as JSON(beacause last line contains the desired Output)
        result_json = JSON.parse(lines[lines.length - 1]);

        // Assign parsed values to outputs
        outputs.status = result_json.Status;
        outputs.error_message = result_json.ErrorMessage;
        outputs.member_count = result_json.MembersCount;
        outputs.members_list = result_json.Members;
        outputs.nonmembers_list = result_json.NonMembers;
        outputs.dl_id = result_json.Id;
    } else {
        // Handle case where script output is empty or failed
        outputs.status = 1;
        outputs.error_message = 'Error in PowerShell Script';
        outputs.member_count = 0;
        outputs.members_list = [];
        outputs.nonmembers_list = [];
        outputs.dl_id = '';
    }
})(inputs, outputs);
