#// Start of script 
#// Get year and month for csv export file
# variables 
$s3_bucket_prod= 's3://nikhil-ad-backup/'
$s3_bucket_pre_prod = 's3://opis-preprod-audit/ADBackup/'
# Backup Path
$path = Split-Path -parent "c:\temp\ADBackup\*.*"
$DateTime = Get-Date -f yyyy-MM-dd 
# Creating a temp  path 
New-Item $path -ItemType Directory
New-Item $path\$DateTime -ItemType Directory

 
#// Set CSV file name 
$CSVFileGroups = $path+"\"+$DateTime+"\AD_Groups-"+$DateTime+".csv" 
$CSVFileUsers = $path+"\"+$DateTime+"\AD_Users-"+$DateTime+".csv"
# echo $CSVFileUsers
#// Create emy array for CSV data 
$CSVOutputGroups = @() 
$CSVOutputUsers = @() 

#// Get all AD groups in the domain 
$ADGroups = Get-ADGroup -Filter * 
$ADUsers = Get-ADUser -Filter * 

#echo $ADGroup
 
foreach ($ADGroup in $ADGroups) { 
      #// Ensure Members variable is empty 
    $Members = "" 
 
    #// Get group members which are also groups and add to string 
    $MembersArr = Get-ADGroup -filter {Name -eq $ADGroup.Name} | Get-ADGroupMember |  select Name 
    if ($MembersArr) { 
        foreach ($Member in $MembersArr) { 
            $Members = $Members + "," + $Member.Name 
        } 
        $Members = $Members.Substring(1,($Members.Length) -1) 
    } 
 
    #// Set up hash table and add values 
    $HashTab = $NULL 
    $HashTab = [ordered]@{ 
        "Name" = $ADGroup.Name 
        "Category" = $ADGroup.GroupCategory 
        "Scope" = $ADGroup.GroupScope 
        "Members" = $Members 
    } 
 
    #// Add hash table to CSV data array 
    $CSVOutputGroups += New-Object PSObject -Property $HashTab 
} 
#//User backup
#echo $CSVOutputGroups
foreach($User in $ADUsers){
	$HashTab1 = $NULL 
	$HashTab1 = [ordered]@{ 
        "FirstName" = $User.GivenName 
        "LastName" = $User.SurName 
        "DisplayName" = $User.Name 
        "FullName" = $User.UserPrincipalName
        "SamAccountLogonName" =$User.SamAccountName 		
    } 
$CSVOutputUsers += New-Object PSObject -Property $HashTab1	

}
#echo $CSVOutputUsers
 
#// Export to CSV files 
$CSVOutputGroups | Sort-Object Name | Export-Csv $CSVFileGroups -NoTypeInformation 
$CSVOutputUsers  | Sort-Object Name | Export-Csv $CSVFileUsers -NoTypeInformation
 
#upload to s3
#aws s3 cp $CSVFileUsers $s3_bucket_pre_prod --recursive --sse AES256
#aws s3 cp $CSVFileGroups $s3_bucket_pre_prod --recursive --sse AES256

aws s3 cp $path\$DateTime\  $s3_bucket_prod --recursive --sse AES256
aws s3 cp $path\$DateTime\  $s3_bucket_prod --recursive --sse AES256

#deleteing files older than 14 days
echo  "deleting the the files created before 14 days" 
$Daysback = "-14"

$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -recurse
