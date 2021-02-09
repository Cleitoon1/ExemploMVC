pipeline {
	agent any
	stages {
		stage('Source'){
			steps {
				checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateuserRemoteConfigs: [[url: 'https://github.com/Cleitoon1/ExemploMVC']]])
			}
		}
		stage('Restore') {
			steps {
				bat 'dotnet restore ExemploMVC.sln'
				bat 'npm install'
			}
		}
		stage('Clean') {
			steps {
				bat 'dotnet clean'
			}
		}
		stage('Build') {
			steps {
				bat 'dotnet build --configuration Release'
			}
		}
		stage('Publish') {
			steps {
				powershell '''Import-Module WebAdministration Stop-WebSite -Name \'HelloWorldPoc\''''
				sleep 60
				bat 'dotnet publish -c Release  -o C:\\inetpub\\wwwroot\\HelloWorldPoc'
				powershell '''Import-Module WebAdministration Start-WebSite -Name \'HelloWorldPoc\''''
			}
		}
	}
}

