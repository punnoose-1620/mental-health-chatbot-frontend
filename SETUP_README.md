# Mental Health Chatbot Frontend Setup

This directory contains a setup script that automatically installs Node.js and all required dependencies for the Mental Health Chatbot Frontend.

## Quick Start

1. **Make the script executable** (if not already done):
   ```bash
   chmod +x setup.sh
   ```

2. **Run the setup script**:
   ```bash
   ./setup.sh
   ```

## What the Script Does

The `setup.sh` script will:

1. **Detect your operating system** automatically
2. **Check if Node.js is installed** (requires version 14 or higher)
3. **Install Node.js** if not present or if version is too old
4. **Install all project dependencies** from `package.json`
5. **Verify the installation** to ensure everything is working

## Supported Operating Systems

- **Ubuntu/Debian** - Uses apt-get package manager
- **CentOS/RHEL** - Uses yum package manager  
- **Arch Linux** - Uses pacman package manager
- **macOS** - Uses Homebrew (installs it if not present)
- **Windows** - Provides manual installation instructions

## Requirements

- **Internet connection** for downloading Node.js and dependencies
- **Administrative privileges** (sudo) on Linux/macOS for Node.js installation
- **Homebrew** on macOS (script will install it if not present)

## Manual Installation (Alternative)

If the script doesn't work for your system, you can install manually:

1. **Install Node.js 14+** from [nodejs.org](https://nodejs.org/)
2. **Install dependencies**:
   ```bash
   npm install
   ```

## After Installation

Once setup is complete, you can use these commands:

```bash
# Start development server (http://localhost:3000)
npm run dev

# Build for production
npm run build

# Start production server
npm run start

# Generate static files
npm run generate
```

## Troubleshooting

### Permission Errors
- On Linux/macOS, make sure you have sudo privileges
- On Windows, run the terminal as Administrator

### Network Issues
- Check your internet connection
- If behind a corporate firewall, you may need to configure npm proxy settings

### Node.js Version Issues
- The script requires Node.js 14 or higher
- You can check your version with: `node --version`

### npm Cache Issues
- The script clears npm cache automatically
- If you still have issues, try: `npm cache clean --force`

## Getting Help

If you encounter issues:

1. **Check the error messages** - they often contain helpful information
2. **Verify your internet connection**
3. **Make sure you have the required permissions**
4. **Try running the script again** - sometimes temporary network issues resolve themselves

For persistent issues, please check the main project README or create an issue in the project repository. 