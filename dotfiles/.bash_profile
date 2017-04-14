# Sarir Khamsi
#
# $Id: .bash_profile,v 1.39 2010/07/23 23:45:10 khamsi Exp $
###########################################################################

# don't continue if this is NOT an interactive shell,
# "$-" are the flags passed to the script
[[ $- != *i* ]] && return 1

echo "#- In ~/.bash_profile on host: $(hostname)"
echo "#- $(uname -a)"
echo "#- $(date)"
echo "#- bash version: $BASH_VERSION"

export PATH=$PATH:.

[[ -e $HOME/.bashrc ]] && . $HOME/.bashrc
