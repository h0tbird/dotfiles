#------------------------------------------------------------------------------
# '.zshenv' is sourced on all invocations of the shell, unless the -f option
# is set. It should contain commands to set the command search path, plus
# other important environment variables. '.zshenv' should not contain commands
# that produce output or assume the shell is attached to a tty.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Golang:
#------------------------------------------------------------------------------

export GOPATH=${HOME}/go

#------------------------------------------------------------------------------
# Which directories to search for executable files:
#------------------------------------------------------------------------------

export PATH="${HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PATH="/opt/google-cloud-sdk/bin:${GOPATH}/bin:${PATH}"

#------------------------------------------------------------------------------
# Java lives here:
#------------------------------------------------------------------------------

export JAVA_HOME='/usr/lib/jvm/java-7-openjdk'

#------------------------------------------------------------------------------
# Path to full-fledged editor:
#------------------------------------------------------------------------------

export VISUAL=$(which vim)

#------------------------------------------------------------------------------
# Path to lightweight editor:
#------------------------------------------------------------------------------

export EDITOR=$(which vim)

#------------------------------------------------------------------------------
# Path to the program used to list the contents of files:
#------------------------------------------------------------------------------

export PAGER=$(which less)

#------------------------------------------------------------------------------
# Set locales (define the character sets being used):
#------------------------------------------------------------------------------

export LANG='en_US.utf8'

#------------------------------------------------------------------------------
# Fix inappropriate ioctl for device <Pinentry>:
#------------------------------------------------------------------------------

export GPG_TTY=$(tty)
