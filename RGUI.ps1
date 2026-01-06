
.SYNOPSIS
Modern Robocopy GUI
.DESCRIPTION
A PowerShell-based GUI for Robocopy using WPF.
Features: Source/Dest selection, common options, command preview, and real-time execution logging.
.AUTHOR
Valentin MOYSE
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- XAML UI Definition ---
[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Robocopy Modern GUI" Height="650" Width="800"
        Background="#1E1E1E" Foreground="#FFFFFF"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResizeWithGrip">
    
    <Window.Resources>
        <Style TargetType="GroupBox">
            <Setter Property="Foreground" Value="#DDDDDD"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="BorderBrush" Value="#444444"/>
        </Style>
        <Style TargetType="Label">
            <Setter Property="Foreground" Value="#DDDDDD"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="#DDDDDD"/>
            <Setter Property="Margin" Value="0,5,0,5"/>
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#2D2D30"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#444444"/>
            <Setter Property="Padding" Value="3"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#3E3E42"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#555555"/>
            <Setter Property="Padding" Value="10,5"/>
            <Setter Property="Margin" Value="5"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#505050"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>

    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/> <!-- Paths -->
            <RowDefinition Height="Auto"/> <!-- Options -->
            <RowDefinition Height="Auto"/> <!-- Command Preview -->
            <RowDefinition Height="*"/>    <!-- Log -->
            <RowDefinition Height="Auto"/> <!-- Buttons -->
        </Grid.RowDefinitions>

        <!-- 1. Paths Selection -->
        <GroupBox Header="Paths" Grid.Row="0">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <Label Content="Source:" Grid.Row="0" Grid.Column="0"/>
                <TextBox Name="txtSource" Grid.Row="0" Grid.Column="1" Margin="5"/>
                <Button Name="btnBrowseSource" Content="..." Grid.Row="0" Grid.Column="2" Width="40"/>

                <Label Content="Destination:" Grid.Row="1" Grid.Column="0"/>
                <TextBox Name="txtDest" Grid.Row="1" Grid.Column="1" Margin="5"/>
                <Button Name="btnBrowseDest" Content="..." Grid.Row="1" Grid.Column="2" Width="40"/>
            </Grid>
        </GroupBox>

        <!-- 2. Options -->
        <GroupBox Header="Options" Grid.Row="1">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- Col 1: Copy Modes -->
                <StackPanel Grid.Column="0">
                    <CheckBox Name="chkMir" Content="Mirror (/MIR)" ToolTip="Mirror a directory tree (equivalent to /E plus /PURGE)."/>
                    <CheckBox Name="chkSubdirs" Content="Subdirectories (/E)" IsChecked="True" ToolTip="Copy subdirectories, including Empty ones."/>
                    <CheckBox Name="chkSec" Content="Copy Security (/SEC)" ToolTip="Copy files with security (equivalent to /COPY:DATS)."/>
                </StackPanel>

                <!-- Col 2: Retry & Wait -->
                <StackPanel Grid.Column="1">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        
                        <Label Content="Retry (/R):" Grid.Row="0" Grid.Column="0"/>
                        <TextBox Name="txtRetry" Text="3" Grid.Row="0" Grid.Column="1" Margin="2"/>
                        
                        <Label Content="Wait (/W):" Grid.Row="1" Grid.Column="0"/>
                        <TextBox Name="txtWait" Text="5" Grid.Row="1" Grid.Column="1" Margin="2"/>
                    </Grid>
                </StackPanel>

                <!-- Col 3: Performance & Dry Run -->
                <StackPanel Grid.Column="2">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                         <Label Content="Threads (/MT):" Grid.Column="0"/>
                         <TextBox Name="txtThreads" Text="8" Grid.Column="1" Margin="2"/>
                    </Grid>
                    <CheckBox Name="chkDryRun" Content="Dry Run (/L)" Foreground="#FFD700" FontWeight="Bold" Margin="0,10,0,0" ToolTip="List only - don't copy, timestamp or delete any files."/>
                </StackPanel>
            </Grid>
        </GroupBox>

        <!-- 3. Command Preview -->
        <GroupBox Header="Command Preview" Grid.Row="2">
            <TextBox Name="txtCommand" IsReadOnly="True" TextWrapping="Wrap" Height="50" FontFamily="Consolas" Background="#222222"/>
        </GroupBox>

        <!-- 4. Log Output -->
        <GroupBox Header="Output Log" Grid.Row="3">
            <TextBox Name="txtLog" IsReadOnly="True" VerticalScrollBarVisibility="Auto" FontFamily="Consolas" FontSize="11" Background="#000000" Foreground="#00FF00"/>
        </GroupBox>

        <!-- 5. Action Buttons -->
        <Grid Grid.Row="4" Margin="0,10,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            
            <Label Name="lblStatus" Content="Ready" Foreground="#AAAAAA" VerticalAlignment="Center"/>
            
            <Button Name="btnCopyCommand" Content="Copy Command" Grid.Column="1" Width="120"/>
            <Button Name="btnStart" Content="Start Robocopy" Grid.Column="2" Width="150" Background="#007ACC" FontWeight="Bold"/>
        </Grid>
    </Grid>
</Window>
'@

# --- Load XAML ---
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# --- Find Controls ---
$txtSource = $window.FindName("txtSource")
$btnBrowseSource = $window.FindName("btnBrowseSource")
$txtDest = $window.FindName("txtDest")
$btnBrowseDest = $window.FindName("btnBrowseDest")

$chkMir = $window.FindName("chkMir")
$chkSubdirs = $window.FindName("chkSubdirs")
$chkSec = $window.FindName("chkSec")
$chkDryRun = $window.FindName("chkDryRun")

$txtRetry = $window.FindName("txtRetry")
$txtWait = $window.FindName("txtWait")
$txtThreads = $window.FindName("txtThreads")

$txtCommand = $window.FindName("txtCommand")
$txtLog = $window.FindName("txtLog")
$lblStatus = $window.FindName("lblStatus")

$btnCopyCommand = $window.FindName("btnCopyCommand")
$btnStart = $window.FindName("btnStart")

# --- Verify Controls ---
$requiredControls = @(
    "txtSource", "btnBrowseSource", "txtDest", "btnBrowseDest",
    "chkMir", "chkSubdirs", "chkSec", "chkDryRun",
    "txtRetry", "txtWait", "txtThreads",
    "txtCommand", "txtLog", "lblStatus",
    "btnCopyCommand", "btnStart"
)

foreach ($name in $requiredControls) {
    if ($null -eq (Get-Variable -Name $name -ValueOnly)) {
        Write-Error "Failed to find control: $name"
        Read-Host "Press Enter to exit..."
        exit
    }
}

# --- Helper Functions ---

function Get-Folder {
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dialog.ShowDialog() -eq 'OK') {
        return $dialog.SelectedPath
    }
    return $null
}

function Build-Command {
    $src = $txtSource.Text
    $dst = $txtDest.Text
    
    if ([string]::IsNullOrWhiteSpace($src)) { $src = "C:\Source" }
    if ([string]::IsNullOrWhiteSpace($dst)) { $dst = "C:\Dest" }

    # Quote paths if they contain spaces
    if ($src -match " ") { $src = "`"$src`"" }
    if ($dst -match " ") { $dst = "`"$dst`"" }

    $cmd = "robocopy $src $dst"

    if ($chkMir.IsChecked) { $cmd += " /MIR" }
    elseif ($chkSubdirs.IsChecked) { $cmd += " /E" }

    if ($chkSec.IsChecked) { $cmd += " /SEC" }
    
    if ($txtRetry.Text -match "^\d+$") { $cmd += " /R:$($txtRetry.Text)" }
    if ($txtWait.Text -match "^\d+$") { $cmd += " /W:$($txtWait.Text)" }
    if ($txtThreads.Text -match "^\d+$") { $cmd += " /MT:$($txtThreads.Text)" }

    if ($chkDryRun.IsChecked) { $cmd += " /L" }

    # Standard logging options for cleaner output in GUI
    $cmd += " /NP /NDL /TEE" 

    return $cmd
}

function Update-Preview {
    $txtCommand.Text = Build-Command
}

# --- Event Handlers ---

$btnBrowseSource.Add_Click({
        $path = Get-Folder
        if ($path) { 
            $txtSource.Text = $path 
            Update-Preview
        }
    })

$btnBrowseDest.Add_Click({
        $path = Get-Folder
        if ($path) { 
            $txtDest.Text = $path 
            Update-Preview
        }
    })

# Update preview on any option change
$controlsToWatch = @($txtSource, $txtDest, $chkMir, $chkSubdirs, $chkSec, $chkDryRun, $txtRetry, $txtWait, $txtThreads)
foreach ($ctrl in $controlsToWatch) {
    if ($ctrl -is [System.Windows.Controls.TextBox]) {
        $ctrl.Add_TextChanged({ Update-Preview })
    }
    elseif ($ctrl -is [System.Windows.Controls.CheckBox]) {
        $ctrl.Add_Checked({ Update-Preview })
        $ctrl.Add_Unchecked({ Update-Preview })
    }
}

$btnCopyCommand.Add_Click({
        $cmd = Build-Command
        try {
            Set-Clipboard -Value $cmd
            $lblStatus.Content = "Command copied to clipboard!"
        }
        catch {
            $lblStatus.Content = "Failed to copy to clipboard."
        }
    })

$btnStart.Add_Click({
        try {
            $cmd = Build-Command
            $lblStatus.Content = "Running in new window..."
            $txtLog.Clear()
            $txtLog.AppendText("Launching external process for: $cmd`r`n")
            $txtLog.AppendText("Check the new window for progress details.`r`n")
        
            $pinfo = New-Object System.Diagnostics.ProcessStartInfo
            $pinfo.FileName = "cmd.exe"
            # /k keeps the window open after completion so user can see results
            # /c would close it immediately
            $pinfo.Arguments = "/k $cmd" 
            $pinfo.RedirectStandardOutput = $false
            $pinfo.RedirectStandardError = $false
            $pinfo.UseShellExecute = $true
            $pinfo.CreateNoWindow = $false
        
            $p = New-Object System.Diagnostics.Process
            $p.StartInfo = $pinfo
        
            $p.Start() | Out-Null
        
            $lblStatus.Content = "Process started."
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error starting process: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

# --- Show Window ---
try {
    $window.ShowDialog() | Out-Null
}
catch {
    Write-Error "An error occurred: $_"
    Read-Host "Press Enter to exit..."
}
