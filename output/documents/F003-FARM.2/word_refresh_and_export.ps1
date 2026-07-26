param(
    [Parameter(Mandatory = $true)]
    [string]$InputDocx,
    [Parameter(Mandatory = $true)]
    [string]$OutputPdf
)

$wordApp = $null
$document = $null
try {
    $wordApp = New-Object -ComObject Word.Application
    $wordApp.Visible = $false
    $wordApp.DisplayAlerts = 0
    $document = $wordApp.Documents.Open($InputDocx, $false, $false)
    foreach ($toc in $document.TablesOfContents) {
        $toc.Update()
    }
    [void]$document.Fields.Update()
    foreach ($story in $document.StoryRanges) {
        $range = $story
        while ($null -ne $range) {
            [void]$range.Fields.Update()
            $range = $range.NextStoryRange
        }
    }
    $document.Repaginate()
    $document.Save()
    $document.ExportAsFixedFormat($OutputPdf, 17)
    Write-Output "DOCX=$InputDocx"
    Write-Output "PDF=$OutputPdf"
}
finally {
    if ($null -ne $document) {
        $document.Close($false)
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($document)
    }
    if ($null -ne $wordApp) {
        $wordApp.Quit()
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($wordApp)
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
