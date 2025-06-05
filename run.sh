#!/bin/bash

# Mental Health Chatbot Frontend Run Script
# This script runs setup, starts the development server, and opens the browser

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DEV_SERVER_PORT=3000
DEV_SERVER_URL="http://localhost:$DEV_SERVER_PORT"
STARTUP_WAIT_TIME=5  # seconds to wait for server to start

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

print_header() {
    echo -e "${CYAN}[RUN]${NC} $1"
}

# Function to detect OS for browser opening
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
}

# Function to open browser based on OS
open_browser() {
    local url=$1
    
    case $OS in
        "linux")
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$url" >/dev/null 2>&1 &
                print_success "Opening browser with xdg-open"
            elif command -v gnome-open >/dev/null 2>&1; then
                gnome-open "$url" >/dev/null 2>&1 &
                print_success "Opening browser with gnome-open"
            elif command -v firefox >/dev/null 2>&1; then
                firefox "$url" >/dev/null 2>&1 &
                print_success "Opening Firefox"
            elif command -v google-chrome >/dev/null 2>&1; then
                google-chrome "$url" >/dev/null 2>&1 &
                print_success "Opening Google Chrome"
            else
                print_warning "Could not find a way to open browser automatically"
                print_status "Please open your browser and navigate to: $url"
            fi
            ;;
        "macos")
            open "$url"
            print_success "Opening browser with macOS 'open' command"
            ;;
        "windows")
            if command -v start >/dev/null 2>&1; then
                start "$url"
                print_success "Opening browser with Windows 'start' command"
            else
                print_warning "Could not find a way to open browser automatically"
                print_status "Please open your browser and navigate to: $url"
            fi
            ;;
        *)
            print_warning "Unknown operating system: $OS"
            print_status "Please open your browser and navigate to: $url"
            ;;
    esac
}

# Function to check if server is running
check_server() {
    local url=$1
    if command -v curl >/dev/null 2>&1; then
        if curl -s --head "$url" >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget --spider --quiet "$url" 2>/dev/null; then
            return 0
        else
            return 1
        fi
    else
        # If neither curl nor wget is available, just wait and assume it's working
        return 0
    fi
}

# Function to wait for server to start
wait_for_server() {
    local url=$1
    local max_attempts=30  # 30 seconds max wait time
    local attempt=1
    
    print_status "Waiting for development server to start..."
    
    while [ $attempt -le $max_attempts ]; do
        if check_server "$url"; then
            print_success "Development server is running!"
            return 0
        fi
        
        echo -n "."
        sleep 1
        ((attempt++))
    done
    
    echo
    print_warning "Server didn't respond within $max_attempts seconds, but it might still be starting"
    return 1
}

# Function to cleanup on script exit
cleanup() {
    if [ ! -z "$DEV_SERVER_PID" ]; then
        print_status "Shutting down development server..."
        kill $DEV_SERVER_PID 2>/dev/null || true
        wait $DEV_SERVER_PID 2>/dev/null || true
        print_success "Development server stopped"
    fi
}

# Trap to ensure cleanup on script exit
trap cleanup EXIT INT TERM

# Main execution
main() {
    print_header "Mental Health Chatbot Frontend Runner"
    echo
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ]; then
        print_error "package.json not found!"
        print_error "Please run this script from the mental-health-chatbot-frontend directory"
        exit 1
    fi
    
    # Check if setup script exists
    if [ ! -f "setup.sh" ]; then
        print_error "setup.sh not found!"
        print_error "Please ensure setup.sh exists in the current directory"
        exit 1
    fi
    
    # Make sure setup script is executable
    if [ ! -x "setup.sh" ]; then
        print_status "Making setup.sh executable..."
        chmod +x setup.sh
    fi
    
    # Detect OS for browser opening
    detect_os
    print_status "Detected OS: $OS"
    echo
    
    # Step 1: Run setup script
    print_header "Step 1: Running setup script..."
    echo
    
    if ./setup.sh; then
        print_success "Setup completed successfully!"
    else
        print_error "Setup failed!"
        exit 1
    fi
    
    echo
    print_header "Step 2: Starting development server..."
    echo
    
    # Check if development server is already running
    if check_server "$DEV_SERVER_URL"; then
        print_warning "Development server appears to already be running at $DEV_SERVER_URL"
        print_status "Opening browser..."
        open_browser "$DEV_SERVER_URL"
        exit 0
    fi
    
    # Start development server in background
    print_status "Starting development server on port $DEV_SERVER_PORT..."
    npm run dev > /dev/null 2>&1 &
    DEV_SERVER_PID=$!
    
    # Wait a moment for server to start
    sleep $STARTUP_WAIT_TIME
    
    # Check if the process is still running
    if ! kill -0 $DEV_SERVER_PID 2>/dev/null; then
        print_error "Development server failed to start!"
        print_error "Please check for errors by running: npm run dev"
        exit 1
    fi
    
    print_success "Development server started with PID: $DEV_SERVER_PID"
    
    # Wait for server to be responsive
    if wait_for_server "$DEV_SERVER_URL"; then
        echo
        print_header "Step 3: Opening browser..."
        open_browser "$DEV_SERVER_URL"
    else
        print_warning "Server might still be starting up"
        print_status "Opening browser anyway..."
        open_browser "$DEV_SERVER_URL"
    fi
    
    echo
    print_success "🚀 Mental Health Chatbot Frontend is now running!"
    echo
    print_status "Application URL: $DEV_SERVER_URL"
    print_status "Development server PID: $DEV_SERVER_PID"
    echo
    print_warning "Press Ctrl+C to stop the development server"
    echo
    
    # Keep the script running and wait for the development server
    wait $DEV_SERVER_PID
}

# Handle command line arguments
case "${1:-}" in
    "--help"|"-h")
        echo "Mental Health Chatbot Frontend Runner"
        echo
        echo "Usage: $0 [OPTIONS]"
        echo
        echo "This script will:"
        echo "1. Run the setup script to install dependencies"
        echo "2. Start the development server"
        echo "3. Open your browser to the running application"
        echo
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --no-browser  Don't automatically open the browser"
        echo
        echo "The development server will run on: $DEV_SERVER_URL"
        echo
        exit 0
        ;;
    "--no-browser")
        OPEN_BROWSER=false
        ;;
    "")
        OPEN_BROWSER=true
        ;;
    *)
        print_error "Unknown option: $1"
        print_status "Use --help for usage information"
        exit 1
        ;;
esac

# Run main function
main 