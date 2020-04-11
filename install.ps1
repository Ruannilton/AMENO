function choco {
    $executionPolicy = Get-ExecutionPolicy

    if ($executionPolicy -eq "Restricted") {
        Set-ExecutionPolicy AllSigned
    }

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    Write-Output "Chocolatey installed"
    Write-Output ""
}

function java {
    $javaVersion = powershell java -version

    if ($javaVersion) {
        Write-Output "Java already installed"
        Write-Output ""
        return
    }

    $chocoVersion = powershell choco -v

    if (-not($chocoVersion)) {
        Write-Output "Installing chocolatey..."
        Write-Output ""
        choco
    }
    else {
        Write-Output "Installing JRE..."
        Write-Output ""
        powershell choco install javaruntime
        Write-Output "JRE installed" 
        Write-Output ""
    }
}

function git {
    powershell git clone https://github.com/Ruannilton/AMENO
}

function shignima {
    Clear-Host
    Write-Output "1. Coloque o seu nick, clique em 'save username' e depois em 'play', esse mesmo nick sera utilizado para permitir que voce se conecte com o servidor"
    Write-Output ""
    Write-Output "2. Clique em 'edit profile'"
    Write-Output ""
    Write-Output "3. Clique em 'use version' e selecione a 1.12.2"
    Write-Output ""
    Write-Output "4. Depois habilite a JVM arguments e no primeiro parametro onde tem Xmx1G coloque a quantidade de RAM que você quer que a jvm possa alocar (de preferencia no minimo 3Gb)"
    Write-Output ""
    Write-Output "5. Salve as configuracoes, clique em jogar, espere o jogo abrir, depois feche-o"
    
    $proc = Start-Process 'Shiginima Launcher SE v4400.exe' -PassThru
    $proc.WaitForExit()
}

function shignimaFinish {
    Clear-Host
    Write-Output "Volte para o Shiginima e selecione a versão do forge"
    Write-Output ""

    Start-Process 'Shiginima Launcher SE v4400.exe'
}

function forge {
    Clear-Host
    Write-Output "1. Clique em OK e espere a instalacao concluir"
    Write-Output ""

    Start-Process 'forge-1.12.2-14.23.5.2847-installer-win.exe' -Wait
}

function mods {
    $destinationDirectory = $env:APPDATA + '\.minecraft\mods\'
    $currentLocation = Get-Location
    $sourceDirectory = "$($currentLocation)\mods\"

    Copy-item -Force -Recurse $sourceDirectory -Destination $destinationDirectory | Out-Null
}

function manageInstall {
    java
    git
    Set-Location AMENO
    shignima
    forge
    mods
    shignimaFinish
}

manageInstall

Write-Output "Link do Server: dorime.enxada.host"
Write-Output ""
Write-Output "Se divirta!"
Write-Output ""
powershell -ExecutionPolicy Default

