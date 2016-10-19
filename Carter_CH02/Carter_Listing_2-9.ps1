for($i=1
     $i -le 3
     $i++
    )
     {
     Try
        {
        get-content c:\ExpertScripting.txt -ErrorAction Stop
        "Attempt " + $i + " Succeeded"
        Break
        }
     Catch 
        {
        "Attempt " + $i + " Failed"
        Start-Sleep -s 30
        }
     }
