// This JavaScript snippet is added in the "Script" section of the PowerShell Action in ServiceNow for "Create Shared Mailbox".

// It:
// - Splits the PowerShell output line by line
// - Parses the last line which contains the final JSON result
// - Maps the following values into action outputs:
//   - `status` – 0: success, 1: failure, 2: already exists
//   - `error_message` – Error details (if any)
//   - `sendas_count` – Number of users successfully granted SendAs permission
//   - `full_access_count` – Number of users successfully granted Full Access
//   - `sendas_added_list` – List of users granted SendAs permission
//   - `sendas_not_added_list` – Users who failed to get SendAs permission
//   - `full_access_added_list` – Users granted Full Access permission
//   - `full_access_not_added_list` – Users who failed to get Full Access permission
//   - `id` – GUID of the created Shared Mailbox

(function execute(inputs, outputs) {
    
    //Fetch output from PowerShell script.
    var result = inputs.result || '';
    
    if(result){
        var lines = result.split('\n');  // Split into lines
    
        //var trimmed = lines.slice(13); // Skip first 14 lines
        
        var result_json = {};
        
        result_json = JSON.parse(lines[lines.length - 1]);
    
        outputs.status = result_json.Status;
        outputs.error_message = result_json.ErrorMessage;
        outputs.sendas_count = result_json.SendAsCount;
        outputs.full_access_count = result_json.FullAccessCount;
        outputs.sendas_added_list = result_json.SendAsAddedList;
        outputs.sendas_not_added_list = result_json.SendAsNotAddedList;
        outputs.full_access_added_list = result_json.FullAccessAddedList;
        outputs.full_access_not_added_list = result_json.FullAccessNotAddedList;
        outputs.id = result_json.Id;
    }else{
        outputs.status = 1;
        outputs.error_message = 'Error in PowerShell Script';
        outputs.sendas_count = 0;
        outputs.full_access_count = 0;
        outputs.sendas_added_list = [];
        outputs.sendas_not_added_list = [];
        outputs.full_access_added_list = [];
        outputs.full_access_not_added_list = [];
        outputs.id = '';
    }


})(inputs, outputs);
