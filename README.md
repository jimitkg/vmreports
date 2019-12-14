# vmreports

This sample code uses PowerCLI and PowerShell's Convertto-html function along with a basic css file to generate a list of offline VMs from the on-premesis VMware setup. 

## Sample
Sample HTML report can be found in the repo.

![alt text](https://github.com/jimitkg/vmreports/blob/master/sample%20report%20image.PNG)

## Prerequisits

- Needs VMware vSphere PowerCLI installed
- smtp server

## Steps

- Create c:\temp folder
- copy Stlye.css in c:\temp\
- Save script on the server
- Change variables in script 
  - vcenter server
  - smtp server
  - to email list
  - from email address
  - html post content message (optional)
