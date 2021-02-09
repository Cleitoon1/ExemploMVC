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
				bat 'dotnet publish -p:DeployOnBuild=true -p:DeployDefaultTarget=WebPublish -p:WebPublishMethod=FileSystem -p:SkipInvalidConfigurations=true -p:Configuration=Release -p:Platform=\"Any CPU\" -p:DeleteExistingFiles=True -p:publishUrl=C:\\inetpub\\wwwroot\\HelloWorldPoc'
			}
		}
	}
}

