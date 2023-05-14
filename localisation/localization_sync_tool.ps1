#Made by 'The Dadinator', the author of 'EAC: At War' mod.

Set-Location -Path "english"
$sourceDirectory = "$PWD"
$languages = @{"braz_por" = "l_braz_por"; "french" = "l_french"; "german" = "l_german"; "polish" = "l_polish"; "russian" = "l_russian"; "spanish" = "l_spanish"; "simp_chinese" = "l_simp_chinese"; "japanese" = "l_japanese"; "korean" = "l_korean"}
$language = ""

foreach($folderName in $($languages.keys)){
    $language = $languages[$folderName]
    $targetDirectory = $sourceDirectory.Replace("english", $folderName)

    #Delete Existing Language Files
    Remove-Item -Recurse -Force $targetDirectory

    #Copy English Files
    Copy-Item $sourceDirectory $targetDirectory -recurse

    #Change to the directory
    cd $targetDirectory

    #Rename Files
    Get-ChildItem -Recurse -file | 
        ForEach-Object{
            Rename-Item -Path $_.Fullname -NewName $_.Name.Replace("l_english",$language)  
        }

    #Replace in Files
    $configFiles = Get-ChildItem . *.yml -Recurse
    foreach ($file in $configFiles)
    {
        (Get-Content $file.PSPath) |
        Foreach-Object { $_ -replace "l_english", "$language" } |
        Set-Content $file.PSPath -encoding UTF8
    }

}