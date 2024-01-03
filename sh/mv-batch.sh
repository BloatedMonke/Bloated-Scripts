#!/bin/bash

: << 'FUGA'

USAGE
        mv-batch DIR [-ctrl=version_control] [-C copydir] FROM-EXT TO-EXT
        mv-batch DIR [-ctrl=version_control] -from=ext1[,ext2[,...]] -to=ext1[,ext2[,...]] [-C copydir]

DESCRIPTION
        batch move files in a directory to different file extensions

COMMANDS
        All commands are immediately followed by an '=' and preceded with '-'.
        This allows for exts and directories which have names equivalent to the commands.

        -ctrl
        Use a version control system when moving the files

        This feels like a nice idea, but the security risks it poses may outweigh the 
        pros of actually implementing it.
        It will remain NOT IN USE until a good solution is found.

        -from
        A comma-separated list of exts to change from. No period (.) is necessary.
        Each argument passed will be matched with the corresponding argument of --to.

        -to
        A comma-separated list of exts to change to. No period (.) is necessary.
        Each argument passed will be matched with the corresponding argument of --from.
OPTIONS
        -C copydir
        Create copies of the files with the new ext in copydir instead of renaming them

        --help
        Display a miniature version of this information.
COPYRIGHT
        Copyright © 2024 BloatedMonke
        License GPLv3: <https://gnu.org/licenses/gpl.html>.
        This is free software: you are free to change and redistribute it so long as
        this copyright notice is retained.
FUGA

SUCCESS=0
FAILURE=1
TRUE=1
FALSE=0

main()
{
  
  DIR=
  TO=
  FROM=
  CTRL=
  VERB=mv
  copydir=
  from_enc=$FALSE
  FROM_ARGS=
  to_enc=$FALSE
  TO_ARGS=
  
  i=0
  while [[ -n "$1" ]]; do
    case $i in
    0)  if [ -d $1 ]; then
          DIR="$1";
          ((++i));
        elif [ "${1:0:1}" = "-" ]; then :; 
        else
          printf "mv-batch: FATAL ERROR:: cannot access '$1': No such file or directory\n" 1>&2 ;
          exit $FAILURE;
        fi;
        ;;
    1)  if [ "${1:0:1}" != "-" ]; then
          FROM="$1";
          ((++i))
        fi;
        ;;
    2)  if [ "${1:0:1}" != "-" ]; then
          TO="$1";
          ((++i))
        fi;
        ;;
    3)  if [ ${1:0:1} != "-" ]; then
          printf "mv-batch: Note: Extra arg $1 will not be parsed\n" 1>&2 ;
        fi;
        ;;
    # Something went terribly wrong
    *)  exit 99;
    esac

    nosuffix=${1%=*}
    case "$nosuffix" in
    --help)  _help
             exit $SUCCESS;
             ;;
     -ctrl)  CTRL=${1##-ctrl=};
             ;;
     -from)  from_enc=$TRUE;
             # capture arg list 
             IFS=',' read -a FROM_ARGS <<< ${1##-from=};
             ;;
       -to)  to_enc=$TRUE;
             IFS=',' read -a TO_ARGS <<< ${1##-to=};
             ;;
        -C)  VERB=cp;
             shift;
             copydir="$1";
             if [ -z "$copydir" ]; then
               printf "mv-batch: FATAL ERROR: -C Missing required argument copydir" 1>&2;
               exit $FAILURE;
             fi;
            ;;
        -*)  printf "mv-batch: FATAL ERROR: Unkown parameter $1\n" 1>&2 ;
             _help;
             exit $FAILURE;
             ;;
    esac
    shift;
  done;
  
  # Error handling
  if [ $from_enc != $to_enc ]; then
    if [ $from_enc -eq $TRUE ]; then
      printf "mv-batch: ERROR:: --from missing a matching --to\n" 1>&2 ;
      exit 256;
    fi;
    printf "mv-batch: ERROR:: --to missing a matching --from\n" 1>&2 ;
    exit $FAILURE;
  fi;
  if [ $i != 3 ] && [ $from_enc -eq $FALSE ]; then
    printf "mv-batch: ERROR:: missing required argument$([ $i -lt 2 ] && printf "s") " 1>&2 ;
    [ $i -eq 2 ] && printf "TO-EXT\n" 1>&2 ;
    [ $i -eq 1 ] && printf "FROM-EXT, TO-EXT\n" 1>&2 ;
    [ $i -eq 0 ] && printf '{all}\n' 1>&2 ;
    exit $FAILURE;
  fi;

  if [ $from_enc -eq $FALSE ]; then
    no_list_func $FROM $TO
  else
    list_func
  fi;
}

_help()
{
  printf 'mv-batch: batch move files in a directory to different file extensions\n\n'
  printf '  USAGE::\n\n'
  printf '    mv-batch DIR [--ctrl=version_control] [-C copydir] FROM-EXT TO-EXT\n'
  printf '    mv-batch DIR [--ctrl=version_control] --from=ext1[,ext2[,...]] --to=ext1[,ext2[,...]] [-C copydir]\n\n'
  printf '  COMMANDS::\n\n'
  printf '    -ctrl (NOT IN USE/ NOT IMPLEMENTED)\n'
  printf '    Use the specified version control system when moving the files\n\n'
  printf '    -from\n'
  printf '    A comma-separated list of exts to change from. No period (.) is needed.\n'
  printf '    Each argument passed will be matched with the corresponding argument of --to.\n\n'
  printf '    -to\n'
  printf '    A comma-separated list of exts to change to. No period (.) is needed.\n'
  printf '    Each argument passed will be matched with the corresponding argument of --from.\n'
  printf '  OPTIONS::\n\n'
  printf '    -C copydir\n'
  printf '    Create copies of files with the new ext in copydir instead of renaming them\n\n'
  printf '    --help\n'
  printf '    Display this information.\n'
}

no_list_func()
{
  FILES=();
  # This way we can take arbitrary filenames without trouble.
  readarray -t -O "${#FILES[@]}" FILES < <(find $DIR -maxdepth 1 -type f -name "*.$1");
  if [ ${#FILES[@]} -eq 0 ]; then
    printf "mv-batch: ERROR:: no files with file exstension $1 in $DIR\n" 1>&2 ;
    exit $FAILURE;
  fi;
  [ -n "$copydir" ] && DIR=$copydir && { [ ! -e $DIR ] && mkdir $DIR; };
  IFS='';
  for x in ${FILES[@]}; do
    n=${x##*/}; # remove prefix
    b=${n%.*};  # remove suffix
    # $CTRL $VERB $x $DIR/${b}.$2;
    $VERB "$x" "$DIR/${b}.$2";
  done;
};

list_func()
{
  len=${#FROM_ARGS[@]};
  for ((i=0; i<len; ++i)) do
    # Invoke a subshell so that remaining exts
    # are still parsed even if one causes an error
    (no_list_func ${FROM_ARGS[$i]} ${TO_ARGS[$i]});
  done;
}

main $@

