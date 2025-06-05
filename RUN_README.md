# Quick Start Guide - Mental Health Chatbot Frontend

This directory contains a complete automation script that handles setup, running, and opening the Mental Health Chatbot Frontend application.

## 🚀 One-Command Launch

To get the application running with a single command:

```bash
./run.sh
```

This will automatically:
1. ✅ **Setup** - Run the setup script to install Node.js and dependencies
2. 🚀 **Start** - Launch the development server on http://localhost:3000
3. 🌐 **Open** - Automatically open your browser to the running application

## Usage Options

### Basic Usage
```bash
# Run with automatic browser opening
./run.sh

# Run without opening browser
./run.sh --no-browser

# Show help
./run.sh --help
```

### What It Does

#### Step 1: Setup
- Detects your operating system
- Installs Node.js if needed (version 14+)
- Installs all project dependencies
- Verifies the installation

#### Step 2: Start Development Server
- Starts the Nuxt.js development server
- Runs on port 3000 by default
- Monitors server health
- Displays server status and PID

#### Step 3: Open Browser
- Automatically detects your OS
- Opens the default browser
- Navigates to http://localhost:3000
- Works on Linux, macOS, and Windows

## Supported Operating Systems

### Browser Opening Support
- **Linux** - Uses `xdg-open`, `gnome-open`, or fallback browsers
- **macOS** - Uses the `open` command
- **Windows** - Uses the `start` command

### Node.js Installation Support
- **Ubuntu/Debian** - apt-get with NodeSource repository
- **CentOS/RHEL** - yum with NodeSource repository
- **Arch Linux** - pacman package manager
- **macOS** - Homebrew (installs if not present)
- **Windows** - Manual installation guidance

## Features

### 🛡️ Error Handling
- Comprehensive error checking at each step
- Graceful failure with helpful error messages
- Process cleanup on script termination

### 🎨 Colored Output
- Color-coded status messages for easy reading
- Clear progress indicators
- Distinct message types (INFO, SUCCESS, WARNING, ERROR)

### 🔄 Smart Detection
- Checks if server is already running
- Waits for server to become responsive
- Detects if dependencies are already installed

### 🛑 Clean Shutdown
- Properly terminates development server on Ctrl+C
- Cleanup function ensures no orphaned processes
- Graceful exit handling

## Stopping the Application

To stop the development server:
- Press `Ctrl+C` in the terminal where the script is running
- The script will automatically clean up and stop the server

## Troubleshooting

### If the script fails:
1. **Permission Issues**: Make sure the script is executable
   ```bash
   chmod +x run.sh
   ```

2. **Setup Issues**: The script will show detailed error messages from the setup phase

3. **Server Issues**: If the development server fails to start, try running manually:
   ```bash
   npm run dev
   ```

4. **Browser Issues**: If the browser doesn't open automatically, manually navigate to:
   ```
   http://localhost:3000
   ```

### Common Issues

**Port Already in Use**
- The script checks if port 3000 is already in use
- If detected, it will attempt to open the browser to the existing server

**Missing Dependencies**
- The setup script will automatically install all required dependencies
- If setup fails, check your internet connection and permissions

**Browser Won't Open**
- Some systems may not have the required browser opening commands
- The script will display the URL for manual opening

## Manual Alternative

If you prefer to run steps manually:

```bash
# 1. Run setup
./setup.sh

# 2. Start development server
npm run dev

# 3. Open browser manually to http://localhost:3000
```

## Files

- `run.sh` - Main automation script
- `setup.sh` - Dependency installation script
- `package.json` - Project dependencies and scripts
- `SETUP_README.md` - Detailed setup documentation

## Support

For issues or questions:
1. Check the error messages - they often contain helpful information
2. Verify your internet connection
3. Ensure you have the required permissions
4. Try running the individual scripts manually

---

**Ready to start?** Simply run `./run.sh` and you'll be up and running in minutes! 🎉 