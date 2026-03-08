@echo off
pip install yt-dlp >nul 2>&1
set /p URL="Paste YouTube Link: "
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 -o "%USERPROFILE%\Downloads\%%(title)s.%%(ext)s" %URL%
pause