+-----------------------+------------------------------------------------------------+
|         Variable      |                          Meaning                           |
+-----------------------+------------------------------------------------------------+
|           $0          | The name of the script or shell.                            |
|           $1          | The first argument passed to the script or function.       |
|           $2          | The second argument passed to the script or function.      |
|          ...          | ...                                                        |
|          $9          | The ninth argument passed to the script or function.       |
|          ${10}        | The tenth argument and beyond (use braces for double digits).|
|          "$@"         | All the arguments passed to the script or function as separate words.|
|          "$\*"         | All the arguments passed to the script or function as a single word.|
|          $#          | The number of arguments passed to the script or function.   |
|          $?          | The exit status of the last command.                        |
|          $$          | The process ID of the current shell or script.              |
|          $!          | The process ID of the last background command.             |
|          $RANDOM     | A random integer between 0 and 32767.                       |
|          $LINENO     | The current line number in the script.                     |
|          $FUNCNAME   | The name of the current function (in a function).           |
|          $PWD        | The present working directory.                              |
|          $OLDPWD     | The previous working directory.                             |
|          $IFS        | Internal Field Separator (used for word splitting).         |
|          $HOME       | The home directory of the user.                             |
|          $USER       | The username of the user.                                   |
|          $HOSTNAME   | The hostname of the machine.                                |
|          $HOSTTYPE   | The architecture of the machine (e.g., x86\_64).            |
|          $OSTYPE     | The operating system type (e.g., linux-gnu).               |
|          $SHELL      | The path to the user's default shell.                       |
|          $BASH\_VERSION| The version number of Bash.                                 |
|          $0          | The name of the script or shell.                            |
+-----------------------+------------------------------------------------------------+
