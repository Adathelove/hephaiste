# Bash completion for hephaiste

_hephaiste_completions() {
    local cur prev cmds opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Commands
    cmds="greet menu catcher list inspect"

    # Global options
    opts="--help --version --persona-dir"

    #
    # Detect if we are completing a path for --persona-dir
    #
    if [[ "$prev" == "--persona-dir" ]]; then
        # Complete directories and files using bash's native logic
        COMPREPLY=( $(compgen -d -- "$cur") )
        return 0
    fi

    #
    # First argument after hephaiste
    #
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$cmds $opts" -- "$cur") )
        return 0
    fi

    #
    # Per-command deeper completions
    #
    case "${COMP_WORDS[1]}" in
        greet)
            COMPREPLY=( $(compgen -W "--name" -- "$cur") )
            return 0
            ;;

        menu|catcher)
            COMPREPLY=()
            return 0
            ;;

        list)
            # Completing the <what> argument
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=( $(compgen -W "personas" -- "$cur") )
                return 0
            fi

            # After the target, we may need persona-dir
            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;

        inspect)
            # inspect <persona> --persona-dir <dir>

            # Step 1: Check if --persona-dir is already present
            local pdir=""
            for ((i=1; i<${#COMP_WORDS[@]}; i++)); do
                if [[ ${COMP_WORDS[i]} == "--persona-dir" ]]; then
                    pdir="${COMP_WORDS[i+1]}"
                fi
            done

            # Step 2: If pdir exists AND we're completing the persona name
            if [[ -n "$pdir" && -d "$pdir" && $COMP_CWORD -eq 2 ]]; then
                local personas=$(ls "$pdir" 2>/dev/null | grep '\.Settings\.md$' | sed 's/\.Settings\.md//')
                COMPREPLY=( $(compgen -W "$personas" -- "$cur") )
                return 0
            fi

            # Step 3: Otherwise complete options or persona-dir path
            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;
    esac

    # Default fallback
    COMPREPLY=( $(compgen -W "$opts $cmds" -- "$cur") )
}

complete -F _hephaiste_completions hephaiste

