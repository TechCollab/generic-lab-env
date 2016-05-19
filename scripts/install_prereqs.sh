#!/usr/bin/env bash
# =============================================================================
# AUTHOR: Boyko Boykov, boyko.boykov@gmail.com
# TODO: ---
# =============================================================================
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
_gnrl_assert_command_is_available() {
  local cmd=${1}
  type ${cmd} >/dev/null 2>&1 || _gnrl_die "Cancelling because required command '${cmd}' is not available."
}
# === FUNCTION ================================================================
_gnrl_die() {
  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  echo >&2 -e "${red}Error: $@${reset}"
  exit 1
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
_gnrl_assert_running_as_root() {
  if [[ ${EUID} -ne 0 ]]; then
    _gnrl_die "This script must be run as root!"
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
_gnrl_assert_is_installed() {
  local pkg="$1"
  local rc1=0
  local rc2=0

  _gnrl_assert_command_is_available rpm
  _gnrl_assert_command_is_available yum

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

# === MAIN ====================================================================
_main() {

# Exit if not
assert_system_is_latest

# Install packages
while read _package
do
  _gnrl_assert_is_installed  "$_package"
done << PACKAGES
epel-release
ansible
git
PACKAGES

# Check if all common commands are available
while read _command
do
  _gnrl_assert_command_is_available "$_command"
done << COMMANDS
ansible
git
COMMANDS
}

# === START ===================================================================
# Set strict mode and somo common vars
_gnrl_init_strict_mode

_main

exit 0
