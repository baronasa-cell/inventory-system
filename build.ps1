# Ensure src folder exists
if (-not (Test-Path -Path src)) { New-Item -ItemType Directory -Path src | Out-Null }

# 1. app_js.html
$appContent = Get-Content app.js -Raw -Encoding UTF8
$appHtml = "<script>`n" + $appContent + "`n</script>"
Set-Content -Path src/app_js.html -Value $appHtml -Encoding UTF8

# 1.5. appsscript.json (マニフェストファイルをコピー)
if (Test-Path -Path appsscript.json) {
    Copy-Item -Path appsscript.json -Destination src/appsscript.json -Force
}

# 2. style_css.html (style.css の内容をそのまま使用)
$styleContent = Get-Content style.css -Raw -Encoding UTF8
$styleHtml = "<style>`n" + $styleContent + "`n</style>"
Set-Content -Path src/style_css.html -Value $styleHtml -Encoding UTF8

# 3. index.html (GAS用のinclude構文に置換)
$indexContent = Get-Content index.html -Raw -Encoding UTF8
$indexContent = $indexContent -replace '<link rel="stylesheet" href="style.css">', "<?!= include('style_css'); ?>"
$indexContent = $indexContent -replace '<script src="mockData.js"></script>', "<?!= include('mockData_js'); ?>"
$indexContent = $indexContent -replace '<script src="app.js"></script>', "<?!= include('app_js'); ?>"
Set-Content -Path src/index.html -Value $indexContent -Encoding UTF8

# 4. mockData_js.html
$mockContent = Get-Content mockData.js -Raw -Encoding UTF8
$mockHtml = "<script>`n" + $mockContent + "`n</script>"
Set-Content -Path src/mockData_js.html -Value $mockHtml -Encoding UTF8

# 5. backend.gs (ルートのファイルをsrcにコピー)
$backendContent = Get-Content backend.gs -Raw -Encoding UTF8
Set-Content -Path src/backend.gs -Value $backendContent -Encoding UTF8

# 6. GitHub Pages 用のアセット同期 (提案43)
if (Test-Path -Path github_pages_dist) {
    Copy-Item -Path app.js -Destination github_pages_dist/app.js -Force
    Copy-Item -Path style.css -Destination github_pages_dist/style.css -Force
    Copy-Item -Path index.html -Destination github_pages_dist/index.html -Force
    Write-Output "GitHub Pages assets synchronized successfully!"
}
