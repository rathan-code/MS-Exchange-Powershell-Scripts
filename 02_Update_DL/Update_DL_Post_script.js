// This JavaScript snippet is added in the "Script" section of the PowerShell Action in ServiceNow for "Update DL".

// It:
// - Splits the PowerShell output by line
// - Parses the last line as JSON (contains the final result)
// - Maps the following values into action outputs:
//   - `status` – 0: success, 1: error, 2: DL not found
//   - `error_message` – Errors if any occurred
//   - `added_members_count` – Number of members successfully added
//   - `removed_members_count` – Number of members successfully removed
//   - `added_members` – List of members added
//   - `not_added_members` – Members that failed to add
//   - `removed_members` – Members removed successfully
//   - `not_removed_members` – Members that failed to remove


(function execute(inputs, outputs) {
    
    //Fetch output from PowerShell script.
    var result = inputs.result || '';
    if(result){
        var lines = result.split('\n');  // Split into lines
    
        //var trimmed = lines.slice(13); // Skip first 14 lines
        var result_json = {};
        //result_json = JSON.parse(trimmed.join('\n'));
        result_json = JSON.parse(lines[lines.length-1]);
    
        outputs.status = result_json.Status;
        outputs.error_message = result_json.ErrorMessage;
        outputs.added_members_count = result_json.AddedMembersCount;
        outputs.removed_members_count = result_json.RemovedMembersCount;
        outputs.added_members = result_json.MembersAdded;
        outputs.not_added_members = result_json.MembersNotAdded;
        outputs.removed_members = result_json.MembersRemoved;
        outputs.not_removed_members = result_json.MembersNotRemoved;
    }else{
        outputs.status = 1;
        outputs.error_message = "Error in PowerShell Script";
        outputs.added_members_count = 0;
        outputs.removed_members_count = 0;
        outputs.added_members = [];
        outputs.not_added_members = [];
        outputs.removed_members = [];
        outputs.not_removed_members = [];
    }

})(inputs, outputs);
