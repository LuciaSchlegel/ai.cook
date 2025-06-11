#!/bin/bash

# Default values
API_URL="http://localhost:3000"
ADMIN_UID=""
TARGET_UID=""

# Help function
show_help() {
    echo "Usage: $0 -a <admin_uid> -t <target_uid> [-u <api_url>]"
    echo
    echo "Options:"
    echo "  -a    Admin UID (required) - The UID of an existing admin user"
    echo "  -t    Target UID (required) - The UID of the user to be made admin"
    echo "  -u    API URL (optional) - Default is http://localhost:3000"
    echo "  -h    Show this help message"
    exit 1
}

# Parse command line arguments
while getopts "a:t:u:h" opt; do
    case $opt in
        a) ADMIN_UID="$OPTARG";;
        t) TARGET_UID="$OPTARG";;
        u) API_URL="$OPTARG";;
        h) show_help;;
        \?) echo "Invalid option -$OPTARG" >&2; show_help;;
    esac
done

# Validate required parameters
if [ -z "$ADMIN_UID" ] || [ -z "$TARGET_UID" ]; then
    echo "Error: Both admin UID (-a) and target UID (-t) are required"
    show_help
fi

# Make the API call
echo "Making user $TARGET_UID an admin..."
curl -X PUT \
     -H "Content-Type: application/json" \
     "$API_URL/admin/$TARGET_UID" \
     -H "Authorization: Bearer $ADMIN_UID"

echo # New line after curl output 