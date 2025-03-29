# Ollama Server Control Script

This script provides a simple menu-driven interface for:

- **Starting** the Ollama LLM server  
- **Stopping** the Ollama LLM server  
- **Listing** installed LLM models  
- **Running** a selected LLM model  

## Purpose

Managing Ollama from the command line can involve multiple steps (running the server, listing models, etc.). This script simplifies it with a straightforward menu so you can do everything in one place.

## Requirements

- [Ollama](https://github.com/jmorganca/ollama) installed on your system (and in your PATH or referenced with a full path).  
- Bash (standard on most Linux/macOS systems).  

## Installation & Usage

1. **Clone this Repository** (or copy the script into your project):
   ```bash
   git clone https://github.com/OpusG5/Ollama-controls.git
   cd Ollama-controls

Make the Script Executable:
chmod +x ollama.sh

And run this script:
./ollama.sh


- Select **1** to start the Ollama server.  
- Select **2** to shut it down.  
- Select **0** to list your installed models.  
- Select **3** to run a chosen model from that list.  

## Example Menu Screenshot

Below is a text-based “screenshot” showing the menu in action:

![ollama1](https://github.com/user-attachments/assets/607b1641-f5cd-4bac-a79f-c59200e53bdb)


![ollama](https://github.com/user-attachments/assets/c915c291-d4d0-40ee-9884-a2ea9021c400)


## Troubleshooting

- **Server Doesn’t Stop**: Make sure you’re running the script as the same user who started Ollama. If needed, add a force kill or use `systemctl` if Ollama is running under systemd.  
- **Models Not Listed**: Verify you installed models via `ollama pull` or `ollama import`, and that they appear in `ollama list` when you run it manually.

---


