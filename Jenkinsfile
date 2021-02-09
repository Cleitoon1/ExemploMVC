pipeline {
			agent any
			stages {
				stage('Source'){
					steps {
						checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateuserRemoteConfigs: [[url: 'https://github.com/Cleitoon1/ExemploMVC']]])
					}
				}
				stage('Build') {
					steps {
						bat 'dotnet restore ExemploMVC.sln'
						bat 'npm install'
						bat 'npm install grunt'
						bat 'cd ExemploMVC && grunt default minifyHtml'
						bat "\"${tool 'MSBuild'}\" ExemploMVC.sln /p:DeployOnBuild=true /p:DeployDefaultTarget=WebPublish /p:WebPublishMethod=FileSystem /p:SkipInvalidConfigurations=true /t:build /p:Configuration=Release /p:Platform=\"Any CPU\" /p:DeleteExistingFiles=True /p:publishUrl=C:\\inetpub\\wwwroot\\HelloWorldPoc"
					}
				}
			}
}

