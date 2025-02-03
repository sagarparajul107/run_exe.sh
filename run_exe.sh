#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <executable_path> [arguments]"
    echo "This script helps run executable files on Kali Linux with additional options."
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Enable verbose mode (show detailed execution information)"
    echo "  -p, --permissions  Check and modify file permissions before execution"
    echo "  -w, --wine     Force use of Wine for Windows executables"
    echo ""
    echo "Examples:"
    echo "  $0 ./myprogram"
    echo "  $0 /path/to/executable arg1 arg2"
    echo "  $0 -v ./myprogram"
    echo "  $0 -p ./myprogram"
    echo "  $0 -w program.exe"
}

# Initialize variables
VERBOSE=false
CHECK_PERMISSIONS=false
USE_WINE=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -p|--permissions)
            CHECK_PERMISSIONS=true
            shift
            ;;
        -w|--wine)
            USE_WINE=true
            shift
            ;;
        *)
            EXECUTABLE="$1"
            shift
            break
            ;;
    esac
done

# Check if executable is provided
if [ -z "$EXECUTABLE" ]; then
    echo "Error: No executable specified"
    usage
    exit 1
fi

# Check if file exists
if [ ! -f "$EXECUTABLE" ]; then
    echo "Error: File '$EXECUTABLE' does not exist"
    exit 1
fi

# Check and modify permissions if requested
if [ "$CHECK_PERMISSIONS" = true ]; then
    echo "Checking file permissions for $EXECUTABLE..."
    current_permissions=$(stat -c "%a" "$EXECUTABLE")
    
    # If not executable, add execute permissions
    if [[ ! -x "$EXECUTABLE" ]]; then
        echo "Adding execute permissions to $EXECUTABLE"
        chmod +x "$EXECUTABLE"
    fi
fi

# Detect file type
FILETYPE=$(file -b "$EXECUTABLE")

# Determine execution method
EXECUTE_CMD=("$EXECUTABLE")
if [[ "$FILETYPE" == *"Windows executable"* ]] || [[ "$USE_WINE" = true ]]; then
    # Check if Wine is installed
    if ! command -v wine &> /dev/null; then
        echo "Error: Wine is not installed. Please install Wine to run Windows executables."
        echo "You can install it using: sudo apt-get install wine"
        exit 1
    fi
    EXECUTE_CMD=("wine" "$EXECUTABLE")
fi

# Verbose mode logging
if [ "$VERBOSE" = true ]; then
    echo "Executable: $EXECUTABLE"
    echo "Execution Method: ${EXECUTE_CMD[@]}"
    echo "Additional Arguments: $@"
    echo "Verbose mode: ON"
    echo "Permission Check: $CHECK_PERMISSIONS"
    echo "File Type: $FILETYPE"
    echo "----------------------------"
fi

# Run the executable
if [ "$VERBOSE" = true ]; then
    echo "Executing: ${EXECUTE_CMD[@]} $@"
    time "${EXECUTE_CMD[@]}" "$@"
else
    "${EXECUTE_CMD[@]}" "$@"
fi

# Capture and display exit status
exit_status=$?
if [ "$VERBOSE" = true ]; then
    echo "----------------------------"
    echo "Execution completed with exit status: $exit_status"
fi

exit $exit_status
