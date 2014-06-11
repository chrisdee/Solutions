function Download-PhotoFromFotolia{
	[CmdletBinding()]
		Param(	 
				[parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$Url,
				[parameter(Mandatory=$true)][object]$InternetExplorer,
				[parameter(Mandatory=$true)][object]$BaseImageId,
				[parameter(Mandatory=$true)][object]$FileDirectoryPath
			)	
	#Get the page (of search results) using the provided URL
	$InternetExplorer.Navigate($Url)
	while ($InternetExplorer.ReadyState -ne 4)            
	{
		Write-Host "Downloading page. Please wait..." -foregroundcolor DarkYellow;
		sleep -Milliseconds 500            
	} 
	Write-Host "Getting a collection of images.";
	#Get a collection of all the images on the page
	$images = $InternetExplorer.Document.getElementsByTagName("img")
	Write-Host "Getting all of the portrait thumbnails.";
	#Get a collection of all the images with a src attribute that starts with http://t - this will be the collection of thumbnail photos from the search results.
	#By examining the search page using Internet Explorer tools, you can see that all of the thumbnail photos are on a CDN network, starting with the URL http://t1, or http://t2
	#Other images on the page (logos, etc), have a src attribute starting with http://s
	$imageCollection = $images | ?{$_.src -like "http://t*"} 	
	$wc = new-object System.Net.WebClient
	#Download each image and save it to the specified directory
	foreach($image in $imageCollection )
	{
		Write-Host "Downloading"$image.Src -foregroundcolor DarkYellow
		$filePath = ([String]::Format("{0}\{1}.jpg",$FileDirectoryPath,$BaseImageId));
		try
		{
			$wc.downloadfile($image.Src,$filePath);
			Write-Host "Successfully downloaded"$image.Src"to $filePath" -foregroundcolor Green
			$BaseImageId++;
		}
		catch
		{	
			Write-Host "Failed to downloaded"$image.Src"to $filePath. Error:"$_.Exception.Message -foregroundcolor Red
		}		
	}	
	#Return the baseimageid (with has been incremented), if images where found on the page. 
	#If no images where found, return -1
	if($imageCollection.Count -eq 0)
	{return -1}
	else
	{return $BaseImageId;}
}

function Add-ActiveDirectoryUser{
	Param(	 
			[parameter(Mandatory=$true, ValueFromPipeline=$true)][object]$userObject,
			[parameter(Mandatory=$false)][object]$profilePhotoFilePath
		)	
	$password = ConvertTo-SecureString -String "1HopeThi$isS3cure" -AsPlainText -Force
	$path = ([String]::Format("OU={0},OU={1},OU=Locations,DC=PANTS,DC=COM",$userObject.Department.Trim(),$userObject.City.Trim()));
	Ensure-OUExists $path	
	$currentUser = $null;
	try
	{
		$currentUser = Get-ADUSer $userObject.SamAccount -ErrorAction:SilentlyContinue;
		Write-Host "User"([String]::Format("{0} {1}",$userObject.FirstName,$userObject.LastName))"exists." -foregroundcolor Green;
	}
	catch
	{
		Write-Host "User"([String]::Format("{0} {1}",$userObject.FirstName,$userObject.LastName))"does not exist. The user will be created." -foregroundcolor DarkYellow;
	}	
	if($currentUser -eq $null){
		New-ADUser -UserPrincipalName $userObject.SamAccount -SamAccountName $userObject.SamAccount -Name $userObject.SamAccount -City $userObject.City -AccountPassword $password  -Surname $userObject.LastName -OfficePhone $userObject.DDI -MobilePhone $userObject.Mobile -GivenName $userObject.FirstName -Division $userObject.Department -Department $userObject.Department  -Enabled $true  -OtherAttributes @{'ipPhone'=$userObject.Ext;'physicalDeliveryOfficeName'=$userObject.Location;'employeeType'=$userObject.Gender;'co'=$userObject.Country} -EmployeeID $userObject.SamAccount -Path $path -DisplayName ([String]::Format("{0} {1}",$userObject.FirstName,$userObject.LastName)) -Title $userObject.JobTitle -Country $userObject.CountryCode;
		$currentUser = Get-ADUSer $userObject.SamAccount -ErrorAction:SilentlyContinue;
		Write-Host "Created"([String]::Format("{0} {1}",$userObject.FirstName,$userObject.LastName)) -foregroundcolor Green;
	}	
	if(([String]::IsNullOrEmpty($profilePhotoFilePath))-eq $false)
	{
		Add-PhotoToUserAccount $currentUser $profilePhotoFilePath
		Write-Host "Added profile picture for "([String]::Format("{0} {1}",$userObject.FirstName,$userObject.LastName)) -foregroundcolor Green;
	}	
}

function Add-PhotoToUserAccount
{
	Param(	 
			[parameter(Mandatory=$true, ValueFromPipeline=$true)][Microsoft.ActiveDirectory.Management.ADAccount]$Identity,
			[parameter(Mandatory=$true)][object]$fileName
		)
	try
	{
		$Identity | Set-ADUser -Replace @{thumbnailPhoto=([byte[]](Get-Content $fileName -Encoding byte))}
		Write-Host "Set $fileName as the picture for"$Identity.Name"" -foregroundcolor Green;
	}
	catch
	{
		Write-Host "Failed to set $fileName as the picture for"$Identity.Name -foregroundcolor DarkYellow;
	}	
}

function Ensure-OUExists{
	Param(	 
			[parameter(Mandatory=$true, ValueFromPipeline=$true)][object]$path			
		)
	$ou = $null;
	$domain = get-addomain
	if($domain.DistinguishedName -eq $path){return;}
	try
	{
		$ou = Get-ADOrganizationalUnit -Identity $path -ErrorAction SilentlyContinue;
	}
	catch
	{	
		Write-Host "OU $path does not exist." -foregroundcolor DarkYellow;
	}	
	if($ou -eq $null){
		$ouParent = [String]$path.Substring($path.IndexOf(",")+1);
		$ouName = [String]$path.Substring(0,$path.IndexOf(",")).Replace("OU=","");
		Ensure-OUExists $ouParent
		New-ADOrganizationalUnit -Name $ouName -Path $ouParent
		Write-Host "Created OU: $path" -foregroundcolor Green;		
	}
}



#Get first names and last names into objects
$ffn = Get-Content C:\Temp\NameDb\femalefirstnames.txt
$mfn = Get-Content C:\Temp\NameDb\malefirstnames.txt
$ln = Get-Content C:\Temp\NameDb\surnames.txt

$userobject = New-Object psobject
$userobject | Add-Member -MemberType NoteProperty -Name "FirstName" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "LastName" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "SamAccount" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "Location" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "Country" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "CountryCode" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "City" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "Mobile" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "DDI" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "Ext" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "Department" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "JobTitle" -value ""
$userobject | Add-Member -MemberType NoteProperty -Name "Gender" -value ""

#Create an array to hold the user objects
$users = $null;
$users = @();
#Get the number of names in each name file.
$ffnCount = $ffn.Count;
$mfnCount = $mfn.Count;
$lnCount = $ln.Count;
#Set a based number that will be used when creating the users Sam Account.
$sabase = 1000;
#Get the TextInfo class. This will be used with the name files to change the casing of names to title case. E.g. john will be changed to John.
$cI = Get-Culture;
$tI = $cI.TextInfo;
$i=1;
#Create 2000 random users
while($i -le 2000){			
	#Create a new user object
	$nu = $userobject | Select-Object *;
	#Set a random index value for the last name
	$lnIndex = Get-Random -minimum 0 -maximum ($lnCount -1);
	#Make sure the row (in the last names array) contains a value
	while($ln[$lnIndex].Length -eq 1)
	{
		$lnIndex = Get-Random -minimum 0 -maximum ($lnCount -1);
	}
	#Set the last name, using Title casing
	$nu.LastName = $tI.ToTitleCase($ln[$lnIndex].ToLower());
	#Create a unique value for the SAM Account
	$nu.SamAccount = ([String]::Format("u{0}",$sabase));
	#Randomly select the gender
	$gender = Get-Random -minimum 0 -maximum 2;
	#Set a random index value for the female name	
	$ffnIndex = Get-Random -minimum 0 -maximum ($ffnCount -1);
	#Set a random index value for the male name
	$mfnIndex = Get-Random -minimum 0 -maximum ($mfnCount -1);
	if($gender -eq 0){
		#Make sure the row (in the male names array) contains a value
		while($mfn[$mfnIndex].Length -eq 1)
		{
			$mfnIndex = Get-Random -minimum 0 -maximum ($mfnCount -1);
		}
		#Set the fornename, using Title casing
		$nu.FirstName = $tI.ToTitleCase($mfn[$mfnIndex].ToLower());
		#Set the gender
		$nu.Gender = "Male";
	}
	else{
		#Make sure the row (in the female names array) contains a value
		while($ffn[$ffnIndex].Length -eq 1)
		{
			$ffnIndex = Get-Random -minimum 0 -maximum ($ffnCount -1);
		}
		#Set the fornename, using Title casing
		$nu.FirstName = $tI.ToTitleCase($ffn[$ffnIndex].ToLower());
		#Set the gender
		$nu.Gender = "Female";
	}
	#Use a random number to set the location of the user.
	$li = Get-Random -minimum 0 -maximum 100;
	if($li -le 25){$nu.Location = "Melbourne";$nu.City="Melbourne";$nu.Country="Australia";$nu.CountryCode="AU";}
	if($li -gt 25 -and $li -le 40){$nu.Location = "Hong Kong";$nu.City="Hong Kong";$nu.Country="Hong Kong";$nu.CountryCode="HK";}
	if($li -gt 40 -and $li -le 80){$nu.Location = "London";$nu.City="London";$nu.Country="England";$nu.CountryCode="UK";}
	if($li -gt 80){$nu.Location = "New York";$nu.City="New York";$nu.Country="United States of America";$nu.CountryCode="US";}
	#Set the users phone numbers using the unique base number $sabase
	$nu.DDI = ([String]::Format("555-{0}",$sabase));
	$nu.Ext = ([String]::Format("{0}",$sabase));
	$nu.Mobile = ([String]::Format("07555-66{0}",$sabase));	
	#Set the Department of the user
	if($i -le 20){$nu.Department = "Executive"};
	if($i -gt 20 -and $i -le 100){$nu.Department = "Middle Management";$nu.JobTitle="Manager";};
	if($i -gt 100 -and $i -le 200){$nu.Department = "Accounts";$nu.JobTitle="Accountant";};
	if($i -gt 200 -and $i -le 250){$nu.Department = "Marketing";$nu.JobTitle="Marketing Executive";};
	if($i -gt 250 -and $i -le 400){$nu.Department = "Sales";$nu.JobTitle="Salesman";};
	if($i -gt 400 -and $i -le 450){$nu.Department = "Information Technology";$nu.JobTitle="IT Support";};	
	if($i -gt 450 -and $i -le 475){$nu.Department = "Human Resources";$nu.JobTitle="HR Support";};
	if($i -gt 475 -and $i -le 575){$nu.Department = "Engineering";$nu.JobTitle="Engineer";};
	if($i -gt 575 -and $i -le 675){$nu.Department = "Supervisors";$nu.JobTitle="Supervisor";};
	if($i -gt 675 -and $i -le 875){$nu.Department = "Team Leaders";$nu.JobTitle="Team Leader";}
	if($i -gt 875){$nu.Department = "Manufacturing"};
	$users += $nu;
	Write-Host "Added"$nu.FirstName $nu.LastName
	$sabase++;
	$i++;
}

$page = 1;
$baseImageId = 1;
#Get a reference to Internet Explorer
$ie = New-Object -ComObject "InternetExplorer.Application" 
#Set the directories for storing the female and male images (create the directories if they don't exist)
$femailPhotoDirectory = "C:\temp\femalephotos";
if((Test-Path -Path $femailPhotoDirectory) -eq $false){New-Item -Path $femailPhotoDirectory -ItemType Directory}
$mailPhotoDirectory = "C:\temp\malephotos";
if((Test-Path -Path $mailPhotoDirectory) -eq $false){New-Item -Path $mailPhotoDirectory -ItemType Directory}
#Set the baseImageId - this is used to create a unique file name for each photo downloaded
$baseImageId = 1;
#Attempt to download 1000 female images. The search query specifies orientation = square, contenttype = photo, using the keyword "woman"
#The Download-PhotoFromFotolia function returns -1 if there are no more images to download.
while($baseImageId -ge 1 -and $baseImageId -le 1000)
{	 
	$baseImageId = Download-PhotoFromFotolia -Url ([String]::Format("http://au.fotolia.com/search?colors=&filters%5Bage%5D=all&filters%5Bcollection%5D=all&filters%5Bhas_releases%5D=true&filters%5Borientation%5D=square&filters%5Bmax_price_xs%5D=all&filters%5Bmax_price_x%5D=&filters%5Bcontent_type%3Aphoto%5D=1&ca=3000000&cca=20000000&k=woman&offset={0}", $baseImageId)) -InternetExplorer $ie -BaseImageId $baseImageId -FileDirectoryPath $femailPhotoDirectory	
}
#Reset the baseimageid
$baseImageId = 1;
#Attempt to download 1000 male images. The search query specifies orientation = square, contenttype = photo, using the keyword "man"
#The Download-PhotoFromFotolia function returns -1 if there are no more images to download.
while($baseImageId -ge 1 -and $baseImageId -le 1000)
{	 
	$baseImageId = Download-PhotoFromFotolia -Url ([String]::Format("http://au.fotolia.com/search?colors=&filters%5Bage%5D=all&filters%5Bcollection%5D=all&filters%5Bhas_releases%5D=true&filters%5Borientation%5D=square&filters%5Bmax_price_xs%5D=all&filters%5Bmax_price_x%5D=&filters%5Bcontent_type%3Aphoto%5D=1&ca=3000000&cca=20000000&k=man&offset={0}", $baseImageId)) -InternetExplorer $ie -BaseImageId $baseImageId -FileDirectoryPath $mailPhotoDirectory	
}
#Close the Internet Explorer application
$ie.Quit();


$femalepictureIndex = 1;
$femaleMaxPhotos = (Get-ChildItem -Path $femailPhotoDirectory  -Filter *.jpg).Count
$malepictureIndex = 1;
$maleMaxPhotos = (Get-ChildItem -Path $mailPhotoDirectory  -Filter *.jpg).Count
foreach($u in $users)
{	
	if($u.Gender -eq "Female")
	{
		if($femalepictureIndex -gt $femaleMaxPhotos){$femalepictureIndex=1;}
		$filePath = ([String]::Format("{0}\{1}.jpg",$femailPhotoDirectory,$femalepictureIndex))		
		Add-ActiveDirectoryUser $u $filePath 
		$femalepictureIndex++;
	}
	else
	{
		if($malepictureIndex -gt $maleMaxPhotos){$malepictureIndex=1;}
		$filePath = ([String]::Format("{0}\{1}.jpg",$mailPhotoDirectory,$malepictureIndex))
		Add-ActiveDirectoryUser $u $filePath 
		$malepictureIndex++;
	}	
}
