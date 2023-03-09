
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

AfterAll {
     $Global:VerbosePreference = $script:curVerbosePref
     $Global:DebugPreference = $script:curDebigPref
     $Global:InformationPreference = $script:curInfoPref
     $Global:WarningPreference = $script:curWarningPref
     $Global:ErrorActionPreference = $script:curErrorActionPref
}

BeforeAll {
    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    $script:curVerbosePref = $Global:VerbosePreference
    $script:curDebigPref = $Global:DebugPreference
    $script:curInfoPref = $Global:InformationPreference
    $script:curWarningPref = $Global:WarningPreference
    $script:curErrorActionPref = $Global:ErrorActionPreference

    $Global:VerbosePreference = $Global:DebugPreference = $Global:InformationPreference = $Global:WarningPreference =
        $Global:ErrorActionPreference = [Management.Automation.ActionPreference]::SilentlyContinue

    $Global:InformationPreference = [Management.Automation.ActionPreference]::Ignore

    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'UCPTestModule' -Resolve) -Force

    $Global:InformationPreference = $script:curInfoPref

    $script:message = ''

    function ThenMessageWritten
    {
        param(
            [Parameter(ValueFromPipeline=$true)] $ActualMessage
        )

        $ActualMessage | Should -Be $script:message
    }

}

Describe 'Use-CallerPreference' {
    BeforeEach {
        $script:message = [Guid]::NewGuid().ToString()
    }

    It 'should write verbose message' {
        function DoIt
        {
            [CmdletBinding()]
            param(
            )

            Write-VerboseMessage -Message $script:message

        }

        DoIt -Verbose 4>&1 | ThenMessageWritten
    }

    It 'should write error message' {
        function DoIt
        {
            [CmdletBinding()]
            param(
            )

            Write-ErrorMessage -Message $script:message
        }

        DoIt -ErrorAction Continue 2>&1 | ThenMessageWritten
    }

    It 'should write debug message' {
        function DoIt
        {
            [CmdletBinding()]
            param(
            )

            Write-DebugMessage -Message $script:message
        }

        $DebugPreference = 'Continue'
        DoIt 5>&1 | ThenMessageWritten
    }

    It 'should write info message' {
        function DoIt
        {
            [CmdletBinding()]
            param(
            )

            Write-InfoMessage -Message $script:message
        }

        # We test for the absence of the message because even silently continue'd messages still show up in the output
        # when redirecting the information stream.
        DoIt -InformationAction Ignore 6>&1 | Should -BeNullOrEmpty
    }

    It 'should support whatif preference' {
        function DoIt
        {
            [Diagnostics.CodeAnalysis.SuppressMessage('PSShouldProcess', '')]
            [CmdletBinding(SupportsShouldProcess)]
            param(
            )

            Invoke-WhatIfAction -Message $script:message
        }

        $output = DoIt -WhatIf
        $output | Should -BeNullOrEmpty
    }

    It 'should support confirm preference' {
        function DoIt
        {
            [Diagnostics.CodeAnalysis.SuppressMessage('PSShouldProcess', '')]
            [CmdletBinding(SupportsShouldProcess)]
            param(
            )

            Invoke-ConfirmedAction -Message $script:message
        }

        $output = DoIt -Confirm:$false
        $output | Should -BeNullOrEmpty
    }

}
