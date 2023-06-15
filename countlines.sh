if [ -n "$3" ]; then
    exit
fi

declare -a files=( *.txt )        
if [[ ${files[0]} =~ [*] ]] ; then
    echo "No files found."
    exit
fi

function usage_help() {
    echo "countlines [OPTIONS] [ARGUMENTS]"
    echo "Options: \n"
    echo "-o count lines on files by ownership (-o username)"
    echo "-m count lines on files by created month abbreviated (-m month)"            
    exit
}

while getopts ':o:m:' OPTION; do
    arg="$OPTARG"
    case "$OPTION" in 
        o)                 
            findFiles=0
            echo "Looking for files where the owner is: $arg"
            for file in ${files[@]}
                do            
                    if [ "$arg" = "$(stat -f %Su $file)" ]; then
                        echo "File: "$file", Lines: "$(sed -n '$=' $file)
                        findFiles+=1
                    fi           
                done  
            if [ $findFiles -eq 0 ]; then 
                echo "No files found." 
            fi
            ;;    
        m)
            findFiles=0
            echo "Looking for files where the month is: $arg"
            for file in ${files[@]}
                do                
                    if [ "$arg" = "$(stat -f %SB -t %b $file)" ]; then
                        echo "File: "$file", Lines: "$(sed -n '$=' $file)         
                        findFiles+=1       
                    fi           
                done        
            if [ $findFiles -eq 0 ]; then 
                echo "No files found." 
            fi
            ;;
        :)
            echo "$0: Missing argument to -$OPTARG." >&2
            exit 1
            ;;
        ?) 
            usage_help
            ;;    
    esac
done



