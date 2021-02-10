pipeline {
	agent any
	stages {
		stage('Source'){
			steps {
				checkout([$class: 'GitSCM', 
					branches: [[name: '*/master']]
				])
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
		stage('VerifyRequests') {
			steps {
			powershell '''Import-Module WebAdministration

				$Website = "helloworldpoc"
				$TimeoutAfter = New-TimeSpan -Minutes 5
				$MinRequestPercentToAdvance = 50
				$WaitBetweenPolling = New-TimeSpan -Seconds 10
				$QtdIterations = 5


				$Timeout = (Get-Date).Add($TimeoutAfter)
				$InitialRequestQuantity = (Get-WebRequest -AppPool $WebSite).count

				Write-Output "Numero Inicial de Requisicoes $($InitialRequestQuantity) site $($WebSite)"
				if($InitialRequestQuantity -gt 0)
				{
					do
					{
						Write-Output "Iniciando Loop Principal"
						$Result = (Get-WebRequest -AppPool $WebSite).count
						if($Result -gt 0)
						{
							$QtdRequests = 0
							Write-Output "Iniciando Loop Secundario"
							For($i = 0; $i -lt $QtdIterations; $i++)
							{
								$Qtd = (Get-WebRequest -AppPool $WebSite).count
								Write-Output "Verificacao $($i) de $($QtdIterations) quantidade atual de requisicoes $($Qtd)"
								if($Qtd -eq 0)
								{
									$QtdRequests = 0
									break
								}
								else
								{
									$QtdRequests = $QtdRequests + $Qtd
								}
								Start-Sleep -Seconds $WaitBetweenPolling.Seconds
							}
							Write-Output "Saiu do Loop Secundario"
							if($QtdRequests -eq 0)
							{
								Write-Output "0 requisições"
								$Result = 0
								break;
							}
							else
							{
								$RequestAvg = $QtdRequests / $QtdIterations
								Write-Output "Media de Requisicoes $($RequestAvg) - Qtd Iteracoes $($QtdIterations) - Tempo entre as requisicoes $($WaitBetweenPolling) - Quantidade Inicial de Requisicoes $($InitialRequestQuantity)"
								$Result = ($RequestAvg * 100) / $InitialRequestQuantity
								Write-Output "Qtde Inicial de Reqs $($InitialRequestQuantity) - Percentual de baixa minimo para avancar $($MinRequestPercentToAdvance) - Percentual Atual $($Result)"
							}			
						}		
					}
					while (($Result -gt $MinRequestPercentToAdvance) -or ((Get-Date) -lt $Timeout))
					Write-Output "Saiu do loop principal"
					Write-Output $Result
				}

				if ($Result -gt $MinPercentageToAdvance)
				{
					exit 1
				}'''
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

