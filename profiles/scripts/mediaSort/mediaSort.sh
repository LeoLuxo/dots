
SRC=$1
DST=$2

MEDIA_EXTS="jpg|jpeg|png|gif|bmp|tiff|webp|heic|heif|raw|cr2|nef|arw|mp4|mkv|avi|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|mts|m2ts"

# Files whose path contains any of these strings will be deleted instead of synced
BLACKLIST=(
	".thumbnails"
	".Thumbnails"
	"Thumbs"
	"@eaDir"
	".DS_Store"
	".trashed"
)

# find files
# |                   only media extensions
# |                   |                             ignore .st* (.stfolder, .stversions) etc
# |                   |                             |                      for all files
find "$SRC" -type f | grep -iE "\.($MEDIA_EXTS)$" | grep -vw '\.st[^/]*' | while read -r file; do
	echo
	echo "Processing file: $file"
	
	# Check if the file path contains any blacklisted fragment
	blacklisted=false
	for fragment in "''${BLACKLIST[@]}"; do
		if [[ "$file" == *"$fragment"* ]]; then
				echo "Blacklisted, deleting."
				rm -f "$file"
				blacklisted=true
				break
		fi
	done

	if $blacklisted; then
		continue
	fi

	year=$(date -r "$file" +%Y)
	month=$(date -r "$file" +%m)
	target="$DST/$year/$month"
	
	echo "Copying to destination: $target"
	mkdir --parents "$target"
	rsync --archive --human-readable --progress --remove-source-files "$file" "$target/"
done

# Remove empty directories from sources
# Syncthing folders wouldn't get deleted anyway because they contain a .txt file
echo "Removing empty directories"
find "$SRC" -type d -empty -delete