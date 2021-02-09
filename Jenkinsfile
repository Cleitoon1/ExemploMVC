pipeline {
			agent any
			stages {
				stage('Build') {
    					steps {
    					    bat "\"${tool 'MSBuild'}\" ExemploMVC.sln /p:DeployOnBuild=true /p:DeployDefaultTarget=WebPublish /p:WebPublishMethod=FileSystem /p:SkipInvalidConfigurations=true /t:build /p:Configuration=Release /p:Platform=\"Any CPU\" /p:DeleteExistingFiles=True /p:publishUrl=C:\\inetpub\\wwwroot\\HelloWorldPoc"
    					}
				}
			}
}