# Media Object Manager #

## The Media Object Manager is a system dedicated to the management of media libraries of various types.

### Use Cases

1. Index media

2. Remove lower quality duplicates of the same format

3. Remove same-quality duplicates in recent downloads, complete, temp and random folders

4. Determine when a download has been completed
	- file is flac, mp3 version exists, duplicate hierarchy in flac folder
	- artist exists on compilation(s) but has no albums, move to the albums/genre folder that matches compilations/genre

5. Move completed downloads to proper location based on existing file locations

6. Move mp3 duplicates of flac files to noscan folder system

7. Suggest placement for files and folders based on existing file locations and move them on agreement
	- move recent downloads into albums and compilations
	- find compilations not in compilations folder
	- find albums not in albums folder
	- find badly placed folders
