


function s3_configure {

SECRET_FILE="/${HOME}/code/git.ourworld.tf/despiegk/hero_secrets/mysecrets.sh"
if [ -f "$SECRET_FILE" ]; then
    echo get secrets
    source "$SECRET_FILE"
fi    

# Check if environment variables are set
if [ -z "$S3KEYID" ] || [ -z "$S3APPID" ]; then
    echo "Error: S3KEYID or S3APPID is not set"
    exit 1
fi

# Create rclone config file
mkdir -p "${HOME}/.config/rclone"
cat > "${HOME}/.config/rclone/rclone.conf" <<EOL
[b2]
type = b2
account = $S3KEYID
key = $S3APPID
hard_delete = true
EOL

echo "made S3 config on: ${HOME}/.config/rclone/rclone.conf"

cat ${HOME}/.config/rclone/rclone.conf

}

function hero_upload {
    set -e    
    hero_path=$(which hero 2>/dev/null)
    if [ -z "$hero_path" ]; then
        echo "Error: 'hero' command not found in PATH" >&2
        exit 1
    fi
    set -x
    s3_configure
    # rclone_config=$(get_rclone_config) || { echo "$rclone_config"; exit 1; }
    rclone --config="${HOME}/.config/rclone/rclone.conf" lsl b2:threefold/$MYPLATFORMID/
    rclone --config="${HOME}/.config/rclone/rclone.conf" copy "$hero_path" b2:threefold/$MYPLATFORMID/
}
    