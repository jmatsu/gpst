#!/usr/bin/env bash

#set -x

function post_proc() {
  [ -f $_tempfile_html ] && rm -f $_tempfile_html
  [ -f $_tempfile_cookie ] && rm -f $_tempfile_cookie
}

function main() {
  local url=$1
  local url_ssl=`echo $url|sed -e 's/http:/https:/'`
  local type_=$2
  local selectee_id=$3
  local submitee_file=$4

  local num=`echo ${selectee_id}|tr "[:upper:]" "[:lower:]"|tr a-i 1-9`

  local as_url="${url%*/}/assignments"
  local sub_url=`curl -sL ${as_url} | grep -o "/submit?task_id=[0-9]*" | head -${num}|tail -1`; sub_url="${url_ssl%*/}${sub_url}"
  local login_url="${url_ssl%*/}/login"

  echo "Login name."
  local name=`perl -e 'my $line=<STDIN>;chomp($line);print "$line"'`

  echo "Password."
  local password=`perl -e 'system "stty -echo";chomp($line = <STDIN>);system "stty echo";print "$line"'`

  curl -sL "$login_url" -X POST -d name="${name}" -d password="${password}" -c "${_tempfile_cookie}" &> /dev/null

  curl -sL "${sub_url}" -b "${_tempfile_cookie}" > "${_tempfile_html}"

  local task_id=`echo "${sub_url}"|grep -o '=.*'|sed -e 's/=//'`
  local lang_id=`cat "${_tempfile_html}"|grep -i "bash "|grep -o "value=\"[0-9]*\""|sed -e 's/"//g' -e 's/value=//'|uniq`

  local langs=`cat "${_tempfile_html}"|grep "language_id_"|grep -o 'name="[^"]*"'|sed -e 's/name="//g' -e "s/\"/=${lang_id} -d /"`

  local csrf_token=`cat "${_tempfile_html}"|grep "__session"|grep -o 'value=".*"'|sed -e 's/"//g' -e 's/value=//'`

  curl -X POST -sL "${sub_url}" -d task_id=${task_id} -d ${langs} __session=${csrf_token} --data-binary "source_code=$(cat $submitee_file)" -b "${_tempfile_cookie}" --referer "${url_ssl%*/}/submit" &> /dev/null

  open "${url_ssl%*/}/submissions/me"
}

unset _tempfile_html
unset _tempfile_cookie

trap post_proc 1 2 3 15

_tempfile_html=$(mktemp 2>/dev/null||mktemp -t tmp)
_tempfile_cookie=$(mktemp 2>/dev/null||mktemp -t tmp)

main $1 $2 $3 $4

rm -f $_tempfile_html
rm -f $_tempfile_cookie

exit 0

