
$null = $PSVersionTable

function prompt
{
    # Get the current directory
    $cwd = Get-Location

    # Set colors (you can modify them as needed)
    $host.UI.RawUI.ForegroundColor = "Red"
    Write-Host "[" -NoNewline

    # User information (whoami in uppercase)
    $host.UI.RawUI.ForegroundColor = "Yellow"
    Write-Host $(whoami).ToUpper() -NoNewline  # Username in uppercase

    # Hostname (@)
    $host.UI.RawUI.ForegroundColor = "Green"
    Write-Host "@" -NoNewline

    # Hostname (full computer name in uppercase)
    $host.UI.RawUI.ForegroundColor = "Blue"
    Write-Host $env:COMPUTERNAME -NoNewline

    # Current directory
    $host.UI.RawUI.ForegroundColor = "Magenta"
    Write-Host " $(Split-Path -Leaf $cwd) " -NoNewline

    # Reset color and close bracket
    $host.UI.RawUI.ForegroundColor = "Red"
    Write-Host "]" -NoNewline

    # Git branch (if inside a Git repo)
    if (Test-Path .git)
    {
        # Get current Git branch
        $branch = git rev-parse --abbrev-ref HEAD
        $status = git status --porcelain
        $host.UI.RawUI.ForegroundColor = "Red"
        Write-Host " [" -NoNewline

        if ($status)
        {
            # If there are uncommitted changes
            $host.UI.RawUI.ForegroundColor = "Red"
            Write-Host $branch -NoNewline
        } else
        {
            # If no changes (clean repo)
            $host.UI.RawUI.ForegroundColor = "Green"
            Write-Host $branch -NoNewline
        }

        $host.UI.RawUI.ForegroundColor = "Red"
        Write-Host "]" -NoNewline
    }

    # Reset color and change prompt symbol to $
    $host.UI.RawUI.ForegroundColor = "White"
    return "$ "  # Change the prompt symbol to $
}

# Right prompt for date
function right_prompt
{
    $date = Get-Date
    $host.UI.RawUI.ForegroundColor = "Magenta"
    Write-Host ($date.ToString("dd/MM/yyyy HH:mm:ss")) -NoNewline
}

# aliases

function rmrf
{
    param(
        [string]$Path
    )
    Remove-Item -Path $Path -Force -Recurse
}

$env:EDITOR = "nvim"


$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

Set-PSReadLineOption -BellStyle None
