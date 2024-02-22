# Function to print a colored bar
print_colored_bar() {
    local value=$1
    local max=$2
    local width=50
    local bar_color='\e[0;102m' # Green background color "\u001b[38;5;<color code>m + output text"
    local default_color='\e[49m'  # Default background color

    # Calculate the number of characters for the bar
    local num_chars=$(( (value * width) / max ))

    # Print the colored bar
    printf "${bar_color}%-${num_chars}s${default_color}\n" ''
}

# Input value and maximum value
value=75
max_value=100

# Print the colored bar
print_colored_bar $value $max_value
