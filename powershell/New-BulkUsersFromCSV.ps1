<#
.SYNOPSIS
    Creación masiva de usuarios en Active Directory a partir de un archivo CSV.
.AUTHOR
    Álvaro Blanco Garay
#>

$CsvPath = "C:\Scripts\usuarios_nuevos.csv"
$TargetOU = "OU=Empleados,DC=empresa,DC=local"

if (-not (Test-Path $CsvPath)) {
    Write-Host "[ERROR] No se encuentra el archivo CSV en $CsvPath" -ForegroundColor Red
    exit
}

$Usuarios = Import-Csv -Path$CsvPath -Delimiter ";"

foreach ($Usuario in$Usuarios) {
    $SamAccountName =$Usuario.SamAccountName
    $Nombre =$Usuario.Nombre
    $Apellido =$Usuario.Apellido
    $Email =$Usuario.Email
    $Password = ConvertTo-SecureString "PassTmp2026!" -AsPlainText -Force

    # Verificar si el usuario ya existe
    if (Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'") {
        Write-Host "[INFO] El usuario $SamAccountName ya existe en Active Directory." -ForegroundColor Yellow
    } else {
        New-ADUser `
            -SamAccountName $SamAccountName `
            -Name "$Nombre$Apellido" `
            -GivenName $Nombre `
            -Surname $Apellido `
            -UserPrincipalName "$SamAccountName@empresa.local" `
            -EmailAddress $Email `
            -Path $TargetOU `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        Write-Host "[ÉXITO] Usuario $SamAccountName creado correctamente." -ForegroundColor Green
    }
}
