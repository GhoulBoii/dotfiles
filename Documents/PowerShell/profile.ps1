#opt-out of telemetry
[System.Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1");
[System.Environment]::SetEnvironmentVariable('KOMOREBI_CONFIG_HOME', "$HOME\.config\komorebi", "User")

# Editor Configuration
$EDITOR = "nvim"

function Edit-Profile
{
  & $EDITOR $PROFILE.CurrentUserAllHosts
}
Set-Alias -Name ep -Value Edit-Profile

function touch($file)
{
  "" | Out-File $file -Encoding ASCII
}

function reload-profile
{
  & $profile
}

function unzip ($file)
{
  Write-Output("Extracting", $file, "to", $pwd)
  $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
  Expand-Archive -Path $fullFile
}

function grep($regex, $dir)
{
  if ( $dir )
  {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}

function df
{
  get-volume
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

function head
{
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail
{
  param($Path, $n = 10, [switch]$f = $false)
  Get-Content $Path -Tail $n -Wait:$f
}

# Directory Management
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

Set-Alias -Name ls -Value eza

function ln
{
  param (
    [string]$Source,
    [string]$Link
  )

  if (Test-Path $Link)
  {
    Remove-Item $Link -Force
  }
  if ($item.PSIsContainer)
  {
    cmd /c mklink /J $Link $Source
  } else
  {
    cmd /c mklink /d $Link $Source
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

# Networking Utilities
function flushdns
{
  Clear-DnsClientCache
  Write-Host "DNS has been flushed"
}

# System Utilities
function admin
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
Set-Alias -Name su -Value admin


# Clipboard Utilities
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
# Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
# Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
# Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function DeleteWord
# Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
# Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
# Set-PSReadLineKeyHandler -Chord 'Ctrl+z' -Function Undo
# Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Redo

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

if (Get-Command zoxide -ErrorAction SilentlyContinue)
{
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
} else
{
  Write-Host "zoxide command not found. Attempting to install via winget..."
  try
  {
    winget install -e --id ajeetdsouza.zoxide
    Write-Host "zoxide installed successfully. Initializing..."
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
  } catch
  {
    Write-Error "Failed to install zoxide. Error: $_"
  }
}

Set-Alias -Name j -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name ji -Value __zoxide_zi -Option AllScope -Scope Global -Force
Import-Module gsudoModule
Invoke-Expression (&starship init powershell)
