#!/bin/bash

# Mental Health Chatbot Frontend Setup Script
# This script detects the OS and installs Node.js and required dependencies

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            OS="ubuntu"
        elif command -v yum >/dev/null 2>&1; then
            OS="centos"
        elif command -v pacman >/dev/null 2>&1; then
            OS="arch"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
}

# Function to check if Node.js is installed and get version
check_node() {
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$MAJOR_VERSION" -ge 14 ]; then
            print_success "Node.js $NODE_VERSION is already installed"
            return 0
        else
            print_warning "Node.js $NODE_VERSION is installed but version 14+ is recommended"
            return 1
        fi
    else
        print_status "Node.js is not installed"
        return 1
    fi
}

# Function to check if npm is installed
check_npm() {
    if command -v npm >/dev/null 2>&1; then
        NPM_VERSION=$(npm --version)
        print_success "npm $NPM_VERSION is available"
        return 0
    else
        print_error "npm is not available"
        return 1
    fi
}

# Function to install Node.js based on OS
install_node() {
    print_status "Installing Node.js..."
    
    case $OS in
        "ubuntu")
            print_status "Installing Node.js on Ubuntu/Debian..."
            # Install Node.js 18.x LTS
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
        "centos")
            print_status "Installing Node.js on CentOS/RHEL..."
            # Install Node.js 18.x LTS
            curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
            sudo yum install -y nodejs npm
            ;;
        "arch")
            print_status "Installing Node.js on Arch Linux..."
            sudo pacman -S --noconfirm nodejs npm
            ;;
        "macos")
            print_status "Installing Node.js on macOS..."
            if command -v brew >/dev/null 2>&1; then
                brew install node
            else
                print_error "Homebrew not found. Please install Homebrew first or install Node.js manually from https://nodejs.org/"
                print_status "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                brew install node
            fi
            ;;
        "windows")
            print_status "Installing Node.js on Windows..."
            print_warning "Please download and install Node.js manually from https://nodejs.org/"
            print_warning "Or use chocolatey: choco install nodejs"
            print_warning "Or use scoop: scoop install nodejs"
            return 1
            ;;
        *)
            print_error "Unsupported operating system: $OS"
            print_status "Please install Node.js manually from https://nodejs.org/"
            return 1
            ;;
    esac
}

# Function to install project dependencies
install_dependencies() {
    print_status "Installing project dependencies..."
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found. Are you in the correct directory?"
        return 1
    fi
    
    # Clear npm cache to avoid potential issues
    print_status "Clearing npm cache..."
    npm cache clean --force
    
    # Install dependencies
    print_status "Running npm install..."
    npm install
    
    print_success "Dependencies installed successfully!"
}

# Function to verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    # Check Node.js
    if check_node; then
        print_success "Node.js verification passed"
    else
        print_error "Node.js verification failed"
        return 1
    fi
    
    # Check npm
    if check_npm; then
        print_success "npm verification passed"
    else
        print_error "npm verification failed"
        return 1
    fi
    
    # Check if node_modules exists
    if [ -d "node_modules" ]; then
        print_success "node_modules directory exists"
    else
        print_error "node_modules directory not found"
        return 1
    fi
    
    # Check if we can run the dev script
    if npm run dev --dry-run >/dev/null 2>&1; then
        print_success "npm scripts are working"
    else
        print_warning "npm scripts might have issues"
    fi
}

# Main execution
main() {
    print_status "Starting Mental Health Chatbot Frontend Setup..."
    echo
    
    # Detect OS
    detect_os
    print_status "Detected OS: $OS"
    echo
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ]; then
        print_error "package.json not found!"
        print_error "Please run this script from the mental-health-chatbot-frontend directory"
        exit 1
    fi
    
    # Check current Node.js installation
    if ! check_node; then
        print_status "Node.js needs to be installed or updated"
        if install_node; then
            print_success "Node.js installation completed"
        else
            print_error "Failed to install Node.js"
            exit 1
        fi
    fi
    
    echo
    
    # Verify npm is available
    if ! check_npm; then
        print_error "npm is not available after Node.js installation"
        exit 1
    fi
    
    echo
    
    # Install project dependencies
    if install_dependencies; then
        print_success "Project dependencies installed successfully"
    else
        print_error "Failed to install project dependencies"
        exit 1
    fi
    
    echo
    
    # Verify everything is working
    if verify_installation; then
        print_success "Setup completed successfully!"
        echo
        print_status "You can now run the following commands:"
        echo "  npm run dev    - Start development server"
        echo "  npm run build  - Build for production"
        echo "  npm run start  - Start production server"
        echo
    else
        print_error "Setup verification failed"
        exit 1
    fi
}

# Run main function
main "$@" 