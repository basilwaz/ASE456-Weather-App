"""Put a real recording and GitHub link into the Canvas submission ZIP."""
import argparse
from pathlib import Path
from urllib.parse import urlparse
import zipfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('repository_url', help='URL of your published GitHub repository')
parser.add_argument('video', type=Path, help='Path to the app demonstration video')
args = parser.parse_args()
url = urlparse(args.repository_url)
if url.scheme != 'https' or url.hostname != 'github.com' or len(url.path.strip('/').split('/')) != 2:
    parser.error('Use a full repository URL: https://github.com/username/repository')
if not args.video.is_file() or args.video.stat().st_size == 0:
    parser.error('The video file does not exist or is empty.')
if args.video.suffix.lower() not in {'.mp4', '.mov', '.webm', '.m4v'}:
    parser.error('Choose an MP4, MOV, WEBM, or M4V video.')

folder = Path(__file__).resolve().parent / 'submission'
folder.mkdir(exist_ok=True)
link = folder / 'GitHub_Link.txt'
link.write_text(args.repository_url.rstrip('/') + '\n')
output = folder / 'ASE456_Weather_Submission.zip'
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as archive:
    archive.write(link, link.name)
    archive.write(args.video, 'Weather_Demo' + args.video.suffix.lower())
print(f'Created {output}')
