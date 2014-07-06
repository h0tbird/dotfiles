#------------------------------------------------------------------------------
# '.zshenv' is sourced on all invocations of the shell, unless the -f option
# is set. It should contain commands to set the command search path, plus
# other important environment variables. '.zshenv' should not contain commands
# that produce output or assume the shell is attached to a tty.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Export environment variables:
#------------------------------------------------------------------------------

export PATH="${HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export JAVA_HOME='/usr/lib/jvm/java-7-openjdk'
export VISUAL=`which vim`
export EDITOR=`which vim`
export PAGER=`which less`

#------------------------------------------------------------------------------
# Set locales (define the character sets being used):
#------------------------------------------------------------------------------

export LANG='en_US.utf8'
