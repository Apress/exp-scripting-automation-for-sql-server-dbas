$i = 0
while (1 -eq 1)
    {
     Try
        {
         $i++
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
