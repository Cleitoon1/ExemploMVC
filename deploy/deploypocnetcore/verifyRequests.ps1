param ($websitename, [int]$minutesfortimeout=5, [int]$minimumratedoadvance = 40)

Import-Module WebAdministration

if($websitename -eq $null)
{
	Write-Output "Informe o nome do site"
	exit 1
}

$Website = $websitename
$TimeoutAfter = New-TimeSpan -Minutes $minutesfortimeout
$MinRequestPercentToAdvance = $minimumratedoadvance
$CheckAvgAfter = New-TimeSpan -Minutes 1
$WaitBetweenPolling = New-TimeSpan -Seconds 10
$QtdIterations = 5


Write-Output $WebSite
$Timeout = (Get-Date).Add($TimeoutAfter)
$InitialRequestQuantity = (Get-WebRequest -AppPool $WebSite).count

Write-Output "Numero Inicial de Requisicoes $($InitialRequestQuantity) no site $($WebSite)"
if($InitialRequestQuantity -gt 0)
{
	do
	{
		Write-Output "Iniciando Loop Principal"
		$Result = (Get-Counter -Counter "web service($($WebSite))\current connections" -ComputerName $env:COMPUTERNAME | Select-Object -Expand countersamples).Cookedvalue
		if($Result -gt 0)
		{
			$QtdRequests = 0
			Write-Output "Iniciando Loop Secundario"
			For($i = 0; $i -lt $QtdIterations; $i++)
			{
				$Qtd = (Get-Counter -Counter "web service($($WebSite))\current connections" -ComputerName $env:COMPUTERNAME | Select-Object -Expand countersamples).Cookedvalue

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
}