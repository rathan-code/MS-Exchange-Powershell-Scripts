// This JavaScript snippet is added in the "Script" section of the PowerShell Action in ServiceNow for "Delete DL".

// It:
// - Splits the PowerShell output by line
// - Parses the last line of the output as JSON (final result from PowerShell)
// - Maps the following values into action outputs:
//   - `status` – 0: success, 1: error, 2: DL not found
//   - `error_message` – Provides error details or confirmation message

(function execute(inputs, outputs) {

    //Fetch output from PowerShell script.
    var result = inputs.result || '';
    
    if(result){
        var lines = result.split('\n');  // Split into lines.
    
        //var trimmed = lines.slice(13); // Skip first 14 lines
        var result_json = {};
        //result_json = JSON.parse(trimmed.join('\n'));
        result_json = JSON.parse(lines[lines.length-1]);
    
        outputs.status = result_json.Status;
        outputs.error_message = result_json.ErrorMessage;
    }else{
        outputs.status = 1;
        outputs.error_message = 'Error in PowerShell script';
    }


})(inputs, outputs);
