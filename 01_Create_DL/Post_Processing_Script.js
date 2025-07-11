

function execute(inputs, outputs) {
    // Fetch output from PowerShell script
    var result = inputs.result || "";

    if (result) {
        var lines = result.split('\n'); // Split output into lines
        var result_json = {};

        // Parse the last line of output as JSON
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
