
# Check if alias name is provided as first argument
alias_name=$1
if [ -z "$alias_name" ]; then
    read -p "Enter alias name: " alias_name
    if [ -z "$alias_name" ]; then
        echo "Alias name cannot be empty. Exiting."
        exit 1
    fi
fi

# Prompt for command to alias
read -p "Enter command for alias: " cmd

# Add alias to .bashrc
echo "alias $alias_name='$cmd';" >> ~/.bashrc
