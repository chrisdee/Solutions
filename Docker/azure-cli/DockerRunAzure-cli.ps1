## Docker: PowerShell Script to Run an azure-cli Image ##

<#

Overview: Script to pull and run an azure-cli Image.

Information: The CLI is installed on the image as the az command in /usr/local/bin.

Note: You will need to register your "Microsoft Azure Cross-platform Command Line Interface" session via: https://login.microsoftonline.com/common/oauth2/deviceauth using the "code" generated when you run the "az login command"

Resources: 

https://docs.microsoft.com/en-us/cli/azure/run-azure-cli-docker?view=azure-cli-latest

#>

## Run the machine

docker run -it microsoft/azure-cli

## Login to Azure Instance

az login

## Update the azure-cli image

docker pull microsoft/azure-cli

## Remove the azure-cli image

docker rmi microsoft/azure-cli