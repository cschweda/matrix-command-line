#!/bin/bash

# Initialize terminal and use alternate screen buffer
tput smcup
clear
tput civis

# Trap SIGINT to restore terminal state
trap 'tput rmcup; tput cnorm; exit 0' SIGINT

# Get terminal size
LINES=$(tput lines)
COLUMNS=$(tput cols)

# Matrix characters
CHARS=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ)

# Initialize arrays with random values
for ((i=0; i<COLUMNS; i+=2)); do
    positions[$i]=$((RANDOM % LINES * -1))
    speeds[$i]=$((RANDOM % 2 + 1))
    lengths[$i]=$LINES  # Make trails full screen height
    trail_positions[$i]=""
    trail_chars[$i]=""
done

# Main loop
while true; do
    printf "\033[H"
    
    for ((i=0; i<COLUMNS; i+=2)); do
        # Clear entire column if lead character reached bottom
        if [ ${positions[$i]} -gt $LINES ]; then
            # Clear the entire column
            for ((y=1; y<=LINES; y++)); do
                printf "\033[%d;%dH " "$y" $((i + 1))
            done
            # Reset column
            positions[$i]=$((RANDOM % 20 * -1))
            speeds[$i]=$((RANDOM % 2 + 1))
            trail_positions[$i]=""
            trail_chars[$i]=""
            continue
        fi
        
        positions[$i]=$((positions[$i] + speeds[$i]))
        pos=${positions[$i]}
        
        # Generate new character for head of trail
        head_char=${CHARS[$((RANDOM % ${#CHARS[@]}))]}
        
        # Update trail storage
        trail_positions[$i]="$pos,${trail_positions[$i]}"
        trail_chars[$i]="$head_char,${trail_chars[$i]}"
        
        # Draw entire trail
        IFS=',' read -ra POS <<< "${trail_positions[$i]}"
        IFS=',' read -ra CHARS_TRAIL <<< "${trail_chars[$i]}"
        
        for ((j=0; j<${#POS[@]}; j++)); do
            if [ "${POS[$j]}" -ge 0 ] && [ "${POS[$j]}" -lt $LINES ]; then
                printf "\033[%d;%dH" "$((POS[$j] + 1))" $((i + 1))
                
                if [ $j -eq 0 ]; then
                    # Lead character (white)
                    printf "\033[1;37m%s\033[0m" "${CHARS_TRAIL[$j]}"
                elif [ $j -lt 8 ]; then
                    # Bright green fade
                    printf "\033[1;32m%s\033[0m" "${CHARS_TRAIL[$j]}"
                else
                    # Dark green fade
                    printf "\033[0;32m%s\033[0m" "${CHARS_TRAIL[$j]}"
                fi
            fi
        done
        
        # Trim trails to prevent memory growth
        if [ ${#POS[@]} -gt $LINES ]; then
            trail_positions[$i]=$(echo "${trail_positions[$i]}" | cut -d',' -f1-$LINES)
            trail_chars[$i]=$(echo "${trail_chars[$i]}" | cut -d',' -f1-$LINES)
        fi
    done
    
    sleep 0.05
done