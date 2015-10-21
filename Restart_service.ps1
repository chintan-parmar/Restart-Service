Function chkservice ()
{

<#
This for service  check function
#>
	
	$colitems = Get-WmiObject -Class win32_service -Filter "Name = 'SAIG.IS.EPServiceHost.PROD'" -ComputerName auhdc1-ispapp07  -ErrorAction Stop
	foreach($objItems in $colitems)	
	{
	Write-Host "Exit Code  :"$ObjItems.Exitcode
	Write-Host "Name       :"$objItems.Name
	write-Host "Process ID :"$ObjItems.ProcessID
	Write-Host "StartMode  :"$ObjItems.StartMode
	Write-Host "State      :"$objItems.State
	Write-Host "Status     :"$ObjItems.Status
	}
}


Function Mailer ($Error) 
<# 

This is a mailer function
 
#>

 
{ 
   $message = @" 
                                 
Please check the error below.  
 $Error
 Thank you, 
Chintan Parmar 
"@

       

$emailTo = "Chintan.parmar@example.com,michael.peng@example.com,stephen.kinsey@example.com"
$emailFrom = "apac_ispt@saiglobal.com" 
$subject="Service Restart" 
$smtpserver="mail0.saig.frd.global" 
$smtp=new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.Send($emailFrom, $emailTo, $subject, $message) 


} 



$Error.clear()
$servernames = "Server-ex1","Server-ex2","Serverex-3"
$counter = 0
Try
{
    foreach($server in $servernames)
    {
	$colitems = Get-WmiObject -Class win32_service -Filter "Name = 'IS.ServiceHost.PROD'" -ComputerName $server -ErrorAction Stop
	
	

	   if ($colitems.state -eq "Running")
	   {
	
		  
		  $obj1 = $colitems.stopservice()
          Start-Sleep -Seconds 10
		  $obj2 = $colitems.startservice()
		
		      if($obj2.ReturnValue -eq 0)
		      {
              $counter++
		      "Service Started successfully" 
		
		      $test = "Service on  $server Started successfully"
		      mailer($test)
              
		      }
		      else

		      {
		      $test = "Error occured"
		      mailer($test)
		
		      }

		Start-Sleep -s 180
	   }
	   else
	   {
	   "Service is not running"
	   $test = "Service is not runnning"
	   Mailer($test)
	   }
       
       
	
    }
    
	chkservice

}
Catch [System.Management.Automation.PsArgumentException]
{
mailer($error)
}

Catch [System.Exception]
{
	
	mailer($Error)
}


Finally
{
"end of script"
}

