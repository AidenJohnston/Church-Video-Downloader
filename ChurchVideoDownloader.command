#!/bin/bash

DIR="$HOME/.church-downloader"
YT_DLP="$DIR/yt-dlp"
FFMPEG="$DIR/ffmpeg"
DENO="$DIR/deno"

mkdir -p "$DIR"

# First-time setup: download yt-dlp
if [ ! -f "$YT_DLP" ]; then
    echo "First time setup — downloading yt-dlp..."
    curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos" -o "$YT_DLP"
    chmod +x "$YT_DLP"
    xattr -d com.apple.quarantine "$YT_DLP" 2>/dev/null
fi

# First-time setup: download ffmpeg
if [ ! -f "$FFMPEG" ]; then
    echo "Downloading ffmpeg..."
    curl -L "https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip" -o "$DIR/ffmpeg.zip"
    unzip -o "$DIR/ffmpeg.zip" -d "$DIR"
    rm "$DIR/ffmpeg.zip"
    chmod +x "$FFMPEG"
    xattr -d com.apple.quarantine "$FFMPEG" 2>/dev/null
fi

# First-time setup: download deno (required JS runtime for yt-dlp)
if [ ! -f "$DENO" ]; then
    echo "Downloading deno..."
    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        DENO_URL="https://github.com/denoland/deno/releases/latest/download/deno-aarch64-apple-darwin.zip"
    else
        DENO_URL="https://github.com/denoland/deno/releases/latest/download/deno-x86_64-apple-darwin.zip"
    fi
    curl -L "$DENO_URL" -o "$DIR/deno.zip"
    unzip -o "$DIR/deno.zip" -d "$DIR"
    rm "$DIR/deno.zip"
    chmod +x "$DENO"
    xattr -d com.apple.quarantine "$DENO" 2>/dev/null
fi

# Put our tools on PATH so yt-dlp finds deno
export PATH="$DIR:$PATH"

# Auto-update yt-dlp
"$YT_DLP" --update 2>/dev/null

clear
echo "========================================="
echo "     🎥 Church Video Downloader 🎥"
echo "========================================="
echo ""
read -p "Paste YouTube link here: " URL
echo ""
echo "Downloading... this may take a minute."
echo ""

"$YT_DLP" \
    --ffmpeg-location "$DIR" \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
    --merge-output-format mp4 \
    -o "$HOME/Downloads/%(title)s.%(ext)s" \
    "$URL"

echo ""
echo "✅ Done! Check your Downloads folder."
echo ""
read -p "Press Enter to close..."