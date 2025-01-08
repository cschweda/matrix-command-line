# Matrix Terminal Effect

A bash script that creates a Matrix-style digital rain effect in your terminal.

## Prerequisites

- Bash shell
- Standard terminal emulator with color support
- `tput` command (typically part of `ncurses` package)

## Installation

1. Clone or download the script:

```bash
git clone https://github.com/yourusername/matrix-command-line.git
cd matrix-command-line
```

2. Make the script executable:

```bash
chmod +x matrix.sh
```

## Usage

Run the script:

```bash
./matrix.sh
```

To exit the animation, press `Ctrl+C`.

## Customization

You can modify these variables in the script to adjust the effect:

- `sleep` value: Change animation speed (default: 0.05)
- `speeds` array: Adjust fall speed (default: 1-2)
- Character set: Modify the `CHARS` array
- Color values: Change the color codes in the printf statements

## Troubleshooting

If you see errors like "permission denied":

```bash
chmod +x matrix.sh
```

If characters appear misaligned:

- Ensure your terminal supports Unicode
- Try a monospace font that supports Japanese characters

## License

MIT License - feel free to modify and distribute
