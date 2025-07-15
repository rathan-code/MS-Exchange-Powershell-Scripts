// This JavaScript snippet is added in the "Script" section of the PowerShell Action in ServiceNow for "Update DL Owners".

// It:
// - Splits the PowerShell output by line
// - Parses the last line as JSON (final result from PowerShell)
// - Maps the following values into action outputs:
//   - `status` – 0: success, 1: error, 2: DL not found
//   - `error_message` – Errors if any occurred
//   - `added_members_count` – Count of owners successfully added
//   - `removed_members_count` – Count of owners successfully removed
//   - `added_members` – List of owners added successfully
//   - `not_added_members` – Owners who failed to be added
//   - `removed_members` – List of owners successfully removed
//   - `not_removed_members` – Owners who failed to be removed


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
        outputs.added_members_count = result_json.AddedOwnersCount;
        outputs.removed_members_count = result_json.RemovedOwnersCount;
        outputs.added_members = result_json.OwnersAdded;
        outputs.not_added_members = result_json.OwnersNotAdded;
        outputs.removed_members = result_json.OwnersRemoved;
        outputs.not_removed_members = result_json.OwnersNotRemoved;
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
