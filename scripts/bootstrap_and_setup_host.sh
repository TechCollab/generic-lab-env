#!/usr/bin/env bash
#===================================================================================
# USAGE:
#   chmod +x <file_name>.sh
#   ./<file_name>.sh
# DESCRIPTION:
#       This script bootstraps hypervisior host (virtualbox version)
# OPTIONS: none
# AUTHOR: Boyko Boykov, boyko.boykov@gmail.com
# CREATED: 01.04.2015
# REQUIREMENTS: ---
# TODO: ---
# =============================================================================
# === SUPPORT FUNCS
# === FUNCTION ================================================================
_gnrl_init_strict_mode() {
set -o nounset
set -o errexit
set -o pipefail

DEFAULT_IFS="$IFS"
SAFER_IFS=$'\n\t'
IFS="$SAFER_IFS"

_ME=$(basename "$0")
}
# === FUNCTION ================================================================
_gnrl_die() {
  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  echo >&2 -e "${red}ERROR: $@${reset}"
  exit 1
}
# === FUNCTION ================================================================
_gnrl_assert_running_as_root() {
  if [[ ${EUID} -ne 0 ]]; then
    _gnrl_die "This script must be run as root!"
  fi
}
# === FUNCTION ================================================================
_file_exists() {
  [[ -f "${1:-}" ]]
}
# === FUNCTION ================================================================
_file_does_not_exist() {
  [[ ! -f "${1:-}" ]]
}
# === FUNCTION ================================================================
_dir_does_not_exist() {
  [[ ! -f "${1:-}" ]]
}
# === FUNCTION ================================================================
_gnrl_assert_command_is_available() {
  local cmd=${1}
  type ${cmd} >/dev/null 2>&1 || _gnrl_die "Cancelling because required command '${cmd}' is not available."
}
# === FUNCTION ================================================================
_gnrl_assert_file_exists() {
  local file=${1}
  if [[ ! -f "${file}" ]]; then
    _gnrl_die "Cancelling because required file '${file}' does not exist."
  fi
}
# === FUNCTION ================================================================
_file_contains() {
  local pattern="$1"
  local file="$2"
  local rc
  _gnrl_assert_command_is_available "grep"
  _gnrl_assert_file_exists "${file}"

  local add_filter="${3:-}"
  if [[ $add_filter ]]; then
    filter="^#|^$|$add_filter"
    grep -Ev "$filter"  "${file}" | grep -Eq "^${pattern}$"
    rc=$?
  else
    grep -Eq "^${pattern}$" "${file}"
    rc=$?
  fi
  [[ $rc -ne 0 ]] && [[ $rc -ne 1 ]] && _gnrl_die "$FUNCNAME: Something went wrong greping. Exits with $rc."

  return $rc
}
# === FUNCTION ================================================================
_gnrl_assert_is_installed() {
  local pkg="$1"
  local rc1=0
  local rc2=0

  rpm -qi --quiet "$pkg" > /dev/null || { rc1="$?"; true; }
  if [[ $rc1 -ne 0 ]]; then
    ch_msg "Installing $1\n"
    yum install -y "$pkg" > /dev/null || { true; }
    # Check if installed
    rpm -qi --quiet "$pkg" > /dev/null || { rc2="$?"; true; }
    if [[ $rc2 -ne 0 ]]; then
      _gnrl_die "Failed to install $pkg\n"
    fi
  else
    ok_msg "$pkg already installed\n"
  fi
}
# === FUNCTION ================================================================
# _print "$msg"
_print() {
  local regex='\\e\[' # because of coloring
  if [[ "$@" =~ $regex ]]; then
    printf "$@\n"  # because of coloring
  else
    printf "%s\n" "$@"
  fi
}
# === FUNCTION ================================================================
ok_msg() {
  local txtrst='\e[0m'    # Text Reset
  local txtgrn='\e[0;32m' # Green   - Regular
  _print "${txtgrn}ok:  $@ ${txtrst}\n"
}
# === FUNCTION ================================================================
ch_msg() {
  local txtrst='\e[0m'    # Text Reset
  local txtylw='\e[0;33m' # Yellow  - Regular
  _print "${txtylw}change:  $@ ${txtrst}\n"
}
# === FUNCTION ================================================================
usage() {
cat << EOF
`basename $0` is script to check and/or setup your host
Usage:
`basename $0` /path/to/repo/main/dir
EOF
}
# === End of support funcs
# === FUNCTION ================================================================
install_ansible() {

  _gnrl_assert_is_installed "epel-release"
  _gnrl_assert_is_installed "ansible"
  _gnrl_assert_command_is_available ansible
  _gnrl_assert_command_is_available ansible-playbook
  _gnrl_assert_command_is_available ssh-keyscan

  if  _file_does_not_exist "$HOME/.ssh/id_rsa.pub"; then
    ### This will generate RSA key pair on the host you're running the script.
    ch_msg "Generating RSA key pair\n"
    ssh-keygen -N '' -t rsa -f $HOME/.ssh/id_rsa
  else
    ok_msg "RSA key pair exist\n"
  fi

  local id_rsa="$HOME/.ssh/id_rsa.pub"
  ### Double check
  if _file_does_not_exist "$id_rsa"; then
    _gnrl_die "$id_rsa not found. Failed to create RSA key pair."
  fi

  ### Check if there is already passwordless ssh connection
  local rc1=0
  ssh -n -o 'PreferredAuthentications=publickey' -o 'StrictHostKeyChecking=no'  localhost -C 'echo' > /dev/null 2>&1 || { rc1="$?"; true; }
  if [[ $rc1 -eq 0 ]]; then
    ok_msg "There is already passwordless login setup .\n"
  else
    ### copy the pub key to remote host
    ch_msg "Setting up passwordless login\n"
    ssh-keyscan localhost >> $HOME/.ssh/known_hosts
    cat $id_rsa >> $HOME/.ssh/authorized_keys ||  _gnrl_die "Something went wrong. Debug"
    ssh-copy-id -i $id_rsa localhost ||  _gnrl_die "Something went wrong. Debug"
    ### Test passwordless ssh connection
    ssh -n -o 'PreferredAuthentications=publickey'  localhost -C 'echo' > /dev/null 2>&1
    [[ $? -ne 0 ]] && _gnrl_die "Passwordless login setup failed.\n"
    ch_msg "Passwordless ssh to localhost has been established.\n"
  fi

}
# === FUNCTION ================================================================
assert_system_is_latest() {

  local rc1=0

  # Check if the system is up to date
  yum check-update  ||  { rc1="$?"; true; }
  if [[ $rc1 -eq 0 ]]; then
    ok_msg "System is up to date. \n"
  else
    _gnrl_die "You must update your system to latest and reboot.\n"
  fi
}
# === FUNCTION ================================================================
assert_prerequisites() {

  
  # Check OS
  if _file_exists "/etc/redhat-release" && _file_contains ".*release.*7.*" "/etc/redhat-release" ; then
    ok_msg "$(cat /etc/redhat-release;)\n"
  else
    _gnrl_die "This script is intended for EL 7"
  fi

  # Check Intel VT or AMD-V
  if  _file_contains "flags.*(vmx|svm).*" "/proc/cpuinfo"; then
    ok_msg "Intel VT or AMD-V capable system\n"
  else
    _gnrl_die "This script is intended for Intel VT or AMD-V capable system"
  fi

  # Simple internet(http://google.com) connection test
  wget -q --tries=10 --timeout=20 --spider http://google.com
  if [[ $? -eq 0 ]]; then
    ok_msg "Internet connection is available (google.com) \n"
  else
    _gnrl_die "Internet connection is NOT available(google.com)\n"
  fi
}
#===================================================================================
###  main
#===================================================================================
_main() {
# Make sure the system is OK to deploy
assert_prerequisites

_gnrl_assert_is_installed git
_gnrl_assert_command_is_available git

# Bootstap ansible
install_ansible


# Provision hypervisor host(localhost)
_gnrl_assert_file_exists "ansible/playbooks/provision_virtualbox.yml"
assert_system_is_latest
ok_msg "Running \"ansible-playbook -i ansible/hosts ansible/playbooks/provision_virtualbox.yml\"" 
ansible-playbook -i "ansible/hosts" ansible/playbooks/provision_virtualbox.yml || _gnrl_die "Went wrong. Debug"

# Install ansible roles
_gnrl_assert_file_exists "ansible/requirements.yml"
ok_msg "Running \"ansible-galaxy install -r ansible/requirements.yml\"" 
ansible-galaxy install -r ansible/requirements.yml || { true; }

ok_msg "\n THE END.\n"
}
#===================================================================================
# Set strict mode and somo common vars
_gnrl_init_strict_mode

# Exit if not root:
_gnrl_assert_running_as_root


# Argument validation 
[[ $# -ne 1 ]] && usage && _gnrl_die "Repositorie's full path is expected as argument."

_WORKDIR="$1"
if [[ ! -d $_WORKDIR ]]; then
  usage 
  _gnrl_die "\"${_WORKDIR}\" does not exist"
else
  ok_msg "${_WORKDIR} exists. Changing dir to ${_WORKDIR}\n"
  cd "${_WORKDIR}" || _gnrl_die "cd \"${_WORKDIR}\" went wrong. Debug"
fi


# Check if all common commands are available
while read _command
do
  _gnrl_assert_command_is_available "$_command"
done << COMMANDS
cd
rpm
yum
ssh
ssh-keygen
mv
cat
touch
COMMANDS

# Call main to start work
_main

exit 0


