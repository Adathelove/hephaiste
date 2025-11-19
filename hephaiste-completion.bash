# Bash completion for hephaiste

_hephaiste_completions() {
    local cur prev opts cmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Global options
    opts="--help --version --persona-dir"

    # Commands
    cmds="greet menu catcher list inspect"

    # If completing the first argument after 'hephaiste'
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$cmds $opts" -- "$cur") )
        return 0
    fi

    # Per-command completions
    case "${COMP_WORDS[1]}" in
        greet)
            COMPREPLY=( $(compgen -W "--name" -- "$cur") )
            ;;

        menu)
            # no options
            COMPREPLY=()
            ;;

        catcher)
            # no options
            COMPREPLY=()
            ;;

        list)
            # valid args for list
            local list_targets="personas"
            COMPREPLY=( $(compgen -W "$list_targets" -- "$cur") )
            ;;

        inspect)
            # persona name (filename without .Settings.md)
            # if persona-dir provided, scan it
            local pdir
            pdir=$(printf "%s" "${COMP_WORDS[@]}" | grep -oP '(?<=--persona-dir )\S+' )
            if [[ -n "$pdir" && -d "$pdir" ]]; then
                local personas=$(ls "$pdir" 2>/dev/null | grep '\.Settings\.md$' | sed 's/\.Settings\.md//')
                COMPREPLY=( $(compgen -W "$personas" -- "$cur") )
            fi
            ;;

        *)
            # fallback to global options
            COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
            ;;
    esac
}

complete -F _hephaiste_completions hephaiste

