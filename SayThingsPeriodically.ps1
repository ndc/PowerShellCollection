Add-Type -AssemblyName System.Speech
while (1) {
    (New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer).Speak("Don't get stuck, keep moving!")
    $delay = Get-Random -Minimum 300 -Maximum 900
    Write-Output "$($delay) seconds delay. Will play next at $((Get-Date).AddSeconds($delay))"
    Start-Sleep -Seconds $delay
    #break
}
