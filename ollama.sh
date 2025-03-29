#!/bin/bash
# Created and maintained by OpusG5, enjoy!
# Hardcode the Ollama binary path if needed:
OLLAMA_BIN="/usr/local/bin/ollama"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII art logo
display_logo() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"


   ___ _ _
  /___\ | | __ _ _ __ ___   __ _
 //  // | |/ _` | '_ ` _ \ / _` |
/ \_//| | | (_| | | | | | | (_| |
\___/ |_|_|\__,_|_| |_| |_|\__,_|

EOF
    echo -e "${NC}"
    echo -e "${RED}        OLLAMA${NC}"
    echo -e "${GREEN}Ollama Server Control Script${NC}"
    echo ""
}

# Lists installed models (very simple parse of the 'ollama list' output)
list_llms() {
    echo -e "${YELLOW}Installed LLMs:${NC}"
    llm_list=$($OLLAMA_BIN list 2>/dev/null | tail -n +2)
    if [ -z "$llm_list" ]; then
        echo -e "${RED}No LLMs installed.${NC}"
    else
        echo "$llm_list" | nl -w 2 -s ". "
    fi
}

# Lets the user pick an installed model to run
start_llm() {
    llm_names=$($OLLAMA_BIN list 2>/dev/null | tail -n +2 | awk '{print $1}')
    llm_count=$(echo "$llm_names" | wc -l)
    if [ "$llm_count" -eq 0 ]; then
        echo -e "${RED}No LLMs installed.${NC}"
        return
    fi

    echo -e "${YELLOW}Select an LLM to run (1-$llm_count):${NC}"
    echo "$llm_names" | nl -w 2 -s ". "
    read -p "Enter number: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$llm_count" ]; then
        selected_llm=$(echo "$llm_names" | sed -n "${choice}p")
        echo -e "${GREEN}Starting LLM: $selected_llm${NC}"
        $OLLAMA_BIN run "$selected_llm"
    else
        echo -e "${RED}Invalid choice.${NC}"
    fi
}

# Kills any process listening on Ollama’s default port 11434
stop_ollama() {
    echo -e "${RED}Attempting to stop Ollama server on port 11434...${NC}"
    local pids
    # lsof -t -i:11434 returns only the process IDs using that port
    pids="$(lsof -t -i:11434 2>/dev/null || true)"
    if [ -z "$pids" ]; then
        echo -e "${RED}No Ollama server found on port 11434.${NC}"
    else
        echo -e "${YELLOW}Killing process(es) $pids...${NC}"
        kill $pids
        sleep 2

        # If still running, force kill
        for pid in $pids; do
            if ps -p "$pid" > /dev/null 2>&1; then
                echo -e "${YELLOW}Process $pid still alive, forcing kill...${NC}"
                kill -9 "$pid"
            fi
        done
    fi
}

# Main loop
while true; do
    display_logo
    echo -e "${BLUE}Menu Options:${NC}"
    echo "1. Start Ollama Server"
    echo "2. Shutdown Ollama Server"
    echo "3. Start an Installed LLM"
    echo "0. List Installed LLMs"
    echo "q. Quit"
    echo ""
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo -e "${GREEN}Starting Ollama Server...${NC}"
            $OLLAMA_BIN serve &
            sleep 2
            ;;
        2)
            stop_ollama
            echo ""
            read -p "Press Enter to continue..."
            ;;
        3)
            start_llm
            echo ""
            read -p "Press Enter to continue..."
            ;;
        0)
            list_llms
            echo ""
            read -p "Press Enter to continue..."
            ;;
        q|Q)
            echo -e "${CYAN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option, try again.${NC}"
            sleep 1
            ;;
    esac
done
