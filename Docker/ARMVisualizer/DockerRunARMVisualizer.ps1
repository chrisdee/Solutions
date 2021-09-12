## Docker: PowerShell Script to Run an arm-visualizer Image ##

<#

Overview: Script to pull and run an arm-visualizer Image.

Resources: 

https://github.com/shenglol/arm-visualizer

http://armviz.io

http://old.armviz.io

Note: Works best when tested on Chrome and FireFox browsers

#>

## Run the machine

docker run -i -d -P ytechie/armviz:v2

## Check and confirm which Port armviz is running on

docker ps

## Launch the browser on the local host with the port obtained from running the "docker ps" command - example: http://localhost:32768