
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\..\Muse' -Resolve) -Force

function Write-VerboseMessage
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Message
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    Write-Verbose -Message $Message
}

function Write-ErrorMessage
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Message
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    Write-Error -Message $Message
}

function Write-DebugMessage
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Message
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    Write-Debug -Message $Message
}

function Write-InfoMessage
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Message
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    Write-Information -Message $Message -InformationAction $InformationPreference
}

function Invoke-WhatIfAction
{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $Message
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if( $PSCmdlet.ShouldProcess($Message) )
    {
        $Message
    }
}

function Invoke-ConfirmedAction
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSShouldProcess', '')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $Message
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    if( $ConfirmPreference -ne 'None' )
    {
        $Message
    }
}

Export-ModuleMember -Function '*'