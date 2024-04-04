#!/usr/bin/bash

regex_string='[a-z]+_to_[a-z]+$'
regex_number='-?[0-9]+\.?[0-9]*$'
file_name="definitions.txt"

display_options() {
echo "Select an option
0. Type '0' or 'quit' to end program
1. Convert units
2. Add a definition
3. Delete a definition"
}

print_file() {
line_number=1
while IFS= read -r line
do
    echo "$line_number. $line"
    ((line_number++))
done < $file_name
}

convert() {
if [[ -s $file_name ]]; then
    echo "Type the line number to convert units or '0' to return"
    print_file
    while true
    do
        read number
        if [[ $number -ge 1 && $number -le $line_number ]]; then
            echo "Enter a value to convert:"
            while true
            do
                read value
                if [[ "$value" =~ $reNum ]]; then
                    break
                else
                    echo "Enter a float or integer value!"
                fi
            done
            line=$(sed "${number}!d" "$file_name")
            read -a text <<< "$line"
            result=$(echo "scale=2; ${text[1]} * $value" | bc -l)
            printf "Result: %s\n" "$result"
            echo ""
            break
        elif [ -z "${number}" ]; then
            echo "Enter a valid line number!"
        elif [[ $number -eq 0 ]]; then
	    echo ""
            break
        else 
            echo "Enter a valid line number!"  
        fi
    done
else
    echo -e "Please add a definition first!\n"
fi
}

enter_def() {
while true
do
    echo "Enter a definition:"
    read -a input
    string="${input[0]}"
    number="${input[1]}"
    arr_length="${#input[@]}"
    
    if [[ "$string" =~ $reStr && "$number" =~ $reNum && "$arr_length" -eq 2 ]]; then
        line=${input[@]}
        echo $line >> definitions.txt
	echo ""
        break
    else
        echo "The definition is incorrect!"
    fi
done
}

delete_def() {
if [[ -s $file_name ]]; then
    echo "Type the line number to delete or '0' to return"
    print_file
    while true
    do
        read number
        if [[ $number -ge 1 && $number -le $line_number ]]; then
            sed -i "${number}d" definitions.txt
            echo ""
            break
        elif [ -z "${number}" ]; then
            echo "Enter a valid line number!"
        elif [[ $number -eq 0 ]]; then
	    echo ""
            break
        else 
            echo "Enter a valid line number!"  
        fi
    done
else
    echo -e "Please add a definition first!\n"
fi
}

echo -e "Welcome to the Simple converter!\n"
while true
do
    display_options
    read option

    case "$option" in

    0 | "quit")     
        echo "Goodbye!" 
        break
        ;;
    1)     
        convert
        ;;
    2)     
        enter_def 
        ;;
    3)     
        delete_def
        ;;
    *)     
        echo -e "Invalid option!\n" 
        ;;
    esac
done