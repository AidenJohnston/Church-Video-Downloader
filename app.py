import streamlit as st
import yt_dlp
import tempfile
import os

#completely vibe-coded for anyone reading

st.set_page_config(page_title="Video Downloader", page_icon="🎥")
st.title("🎥 Video Downloader")
st.caption("Paste a YouTube link, click Download, then save the file.")

url = st.text_input("YouTube Link")

if st.button("Download", type="primary"):
    if not url.strip():
        st.warning("Please paste a link first.")
    else:
        try:
            with st.spinner("Downloading... this may take a minute."):
                tmpdir = tempfile.mkdtemp()
                ydl_opts = {
                    "outtmpl": os.path.join(tmpdir, "%(title)s.%(ext)s"),
                    "format": "bestvideo[ext=mp4]+bestaudio[ext=m4a]"
                    "/best[ext=mp4]/best",
                    "merge_output_format": "mp4",
                    "extractor_args": {
                        "youtube": {
                            "player_client": ["web", "web_embedded"],
                        }
                    },
                    "http_headers": {
                        "User-Agent": (
                            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                            "AppleWebKit/537.36 (KHTML, like Gecko) "
                            "Chrome/131.0.0.0 Safari/537.36"
                        ),
                    },
                    "socket_timeout": 30,
                    "retries": 3,
                }

                with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                    info = ydl.extract_info(url, download=True)
                    title = info.get("title", "video")

                files = [
                    f for f in os.listdir(tmpdir) if not f.endswith(".part")
                ]
                filepath = os.path.join(tmpdir, files[0])

                with open(filepath, "rb") as f:
                    video_bytes = f.read()

                os.remove(filepath)
                os.rmdir(tmpdir)

            st.success(f"**{title}** is ready!")
            st.download_button(
                label="📥 Save to your computer",
                data=video_bytes,
                file_name=f"{title}.mp4",
                mime="video/mp4",
            )
        except Exception as e:
            st.error(f"Something went wrong: {e}")