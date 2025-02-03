Added Wine support for Windows,kali and more os like android also. executables
Automatically detect Windows executables using file command
Added a new -w or --wine flag to force Wine execution
Added checks to ensure Wine is installed
Improved verbose logging to show execution method and file type
Now you can run the script with Windows executables in multiple ways:

bash
CopyInsert
# Automatically detect and use Wine for Windows executables
./run_exe.sh /path/to/program.exe

# Force Wine usage with the -w flag
./run_exe.sh -w /path/to/program.exe

# Use verbose mode to see more details
./run_exe.sh -v -w /path/to/program.exe
