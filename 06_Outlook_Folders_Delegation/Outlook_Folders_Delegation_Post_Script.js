// This JavaScript snippet is used in the Post-Processing Script section in ServiceNow PowerShell Action.
//
// It performs the following:
// - Captures the output returned from the PowerShell script.
// - Parses the last line of output as JSON, since it contains the result object.
// - Maps important result values to action outputs:
//   - 'status': Returns the execution status (0 - Success, 1 - Error, 2 - Validation error, 3 - Already exists).
//   - 'error_message': Captures any error or validation message.
// - If the PowerShell output is empty or invalid, it assigns default error values.

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
    }else{
        outputs.status = 1;
        outputs.error_message = "Error in PowerShell Script";
    }

})(inputs, outputs);
