#opt-out of telemetry
[System.Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1");
[System.Environment]::SetEnvironmentVariable('KOMOREBI_CONFIG_HOME', "$HOME\.config\komorebi", "User")
[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', "$HOME\.config", "User")
[System.Environment]::SetEnvironmentVariable('WGPU_BACKEND', "gl", "User")

# Editor Configuration
$EDITOR = "nvim"
$SHELL = "pwsh"

function ep
{
  & $EDITOR $PROFILE.CurrentUserAllHosts
}

function unzip ($file)
{
  Write-Output("Extracting", $file, "to", $pwd)
  $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
  Expand-Archive -Path $fullFile
}

function sed($file, $find, $replace)
{
  (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name)
{
  Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value)
{
  set-item -force -path "env:$name" -value $value;
}

function pkill($name)
{
  Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name)
{
  Get-Process $name
}

function trash($path)
{
  $fullPath = (Resolve-Path -Path $path).Path

  if (Test-Path $fullPath)
  {
    $item = Get-Item $fullPath

    if ($item.PSIsContainer)
    {
      # Handle directory
      $parentPath = $item.Parent.FullName
    } else
    {
      # Handle file
      $parentPath = $item.DirectoryName
    }

    $shell = New-Object -ComObject 'Shell.Application'
    $shellItem = $shell.NameSpace($parentPath).ParseName($item.Name)

    if ($item)
    {
      $shellItem.InvokeVerb('delete')
      Write-Host "Item '$fullPath' has been moved to the Recycle Bin."
    } else
    {
      Write-Host "Error: Could not find the item '$fullPath' to trash."
    }
  } else
  {
    Write-Host "Error: Item '$fullPath' does not exist."
  }
}

function config
{
  param (
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$args
  )
  git --git-dir=$HOME\.dots --work-tree=$HOME @args
}

function flushdns
{
  Clear-DnsClientCache
  Write-Host "DNS has been flushed"
}

function su
{
  if ($args.Count -gt 0)
  {
    $argList = $args -join ' '
    Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
  } else
  {
    Start-Process wt -Verb runAs
  }
}

function pbcopy
{
  Set-Clipboard $args[0]
}

function pbpaste
{
  Get-Clipboard
}

$PSROptions = @{
  EditMode = "vi"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  Colors = @{
    Command = '#87CEEB'  # SkyBlue (pastel)
    Parameter = '#98FB98'  # PaleGreen (pastel)
    Operator = '#FFB6C1'  # LightPink (pastel)
    Variable = '#DDA0DD'  # Plum (pastel)
    String = '#FFDAB9'  # PeachPuff (pastel)
    Number = '#B0E0E6'  # PowderBlue (pastel)
    Type = '#F0E68C'  # Khaki (pastel)
    Comment = '#D3D3D3'  # LightGray (pastel)
    Keyword = '#8367c7'  # Violet (pastel)
    Error = '#FF6347'  # Tomato (keeping it close to red for visibility)
  }
  PredictionSource = 'History'
  BellStyle = 'None'
}
Set-PSReadLineOption @PSROptions

# Custom key handlers
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -AddToHistoryHandler {
  param($line)
  $sensitive = @('password', 'secret', 'token', 'apikey', 'connectionstring')
  $hasSensitive = $sensitive | Where-Object { $line -match $_ }
  return ($null -eq $hasSensitive)
}

# Improved prediction settings
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -MaximumHistoryCount 10000

# Custom completion for common commands
$scriptblock = {
  param($wordToComplete, $commandAst, $cursorPosition)
  $customCompletions = @{
    'git' = @('status', 'add', 'commit', 'push', 'pull', 'clone', 'checkout')
  }

  $command = $commandAst.CommandElements[0].Value
  if ($customCompletions.ContainsKey($command))
  {
    $customCompletions[$command] | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
  }
}
Register-ArgumentCompleter -Native -CommandName git, dotnet -ScriptBlock $scriptblock
