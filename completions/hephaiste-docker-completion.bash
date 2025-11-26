# Bash completion for hephaiste_docker

_hephaiste_docker_completions() {
    local cur prev cmds opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Commands
    cmds="greet menu catcher list inspect persona persona-debug"

    # Global options
    opts="--help --version --persona-dir"

    #
    # Detect if we are completing a path for --persona-dir
    #
    if [[ "$prev" == "--persona-dir" ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
        return 0
    fi

    # First argument after hephaiste_docker
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
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=( $(compgen -W "personas" -- "$cur") )
                return 0
            fi

            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;

        inspect)
            local pdir=""
            for ((i=1; i<${#COMP_WORDS[@]}; i++)); do
                if [[ ${COMP_WORDS[i]} == "--persona-dir" ]]; then
                    pdir="${COMP_WORDS[i+1]}"
                fi
            done

            if [[ -n "$pdir" && -d "$pdir" && $COMP_CWORD -eq 2 ]]; then
                local personas=$(ls "$pdir" 2>/dev/null | grep '\.Settings\.md$' | sed 's/\.Settings\.md//')
                COMPREPLY=( $(compgen -W "$personas" -- "$cur") )
                return 0
            fi

            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            return 0
            ;;
    esac

    COMPREPLY=( $(compgen -W "$opts $cmds" -- "$cur") )
}

complete -F _hephaiste_docker_completions hephaiste_docker.sh

