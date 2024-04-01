#!/usr/bin/env bash
# set -x
Git_status=$(curl --silent -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/umlaeute/v4l2loopback/tags" )
TAR_dl=$( echo "${Git_status}" | jq -r ".[].tarball_url" | head -n1)
TAR_v=$( echo "${Git_status}" | jq -r ".[].name" | head -n1)
ko_folder="/lib/modules/"$(uname -r)"/updates"


build_dir="${build_dir:-/usr/src/v4l2loopback-"${TAR_v}"}"
tmp_dir="${tmp_dir:-/tmp}"
mokutil_out_dir="${mokutil_out_dir:-/root/.ssh/mokutil-module-signing}"

mokutil_509key_pass=$(cat "${mokutil_out_dir}"/.openssl_pass)
mokutil_509key_pass="${mokutil_509key_pass:-$(openssl rand -hex 6)}"

# https://github.com/umlaeute/v4l2loopback/issues/394
# https://unix.stackexchange.com/questions/445772/how-to-add-a-public-key-into-system-keyring-for-kernel-without-recompile
# https://docs.fedoraproject.org/en-US/fedora/rawhide/system-administrators-guide/kernel-module-driver-configuration/Working_with_Kernel_Modules/#sect-signing-kernel-modules-for-secure-boot
# ToDo:
# - Maybe systemd service, needs testing

source /etc/os-release || source /usr/lib/os-release
case ${ID,,} in
  *suse*) pkg_mgr_cmd="zypper -n in"; sign_file_dir="/usr/src/linux-obj/x86_64/default/scripts"  ;;
  centos|rhel|fedora) pkg_mgr_cmd="dnf install -y";  pkg_check_cmd="rpm -qa"   ;;
  ubuntu|debian) pkg_mgr_cmd="apt-get install -y";  pkg_check_cmd="dpkg-query -l" ;;
  # Gentoo needs to have version set since it's rolling
  gentoo) pkg_mgr_cmd="emerge --jobs=4"; export VERSION="rolling" ;;
  *) warn "unsupported distribution: ${ID,,}" ;;
esac
function info { echo -e "\e[32m[info] $*\e[39m"; }
function warn  { echo -e "\e[33m[warn] $*\e[39m"; }
function error { echo -e "\e[31m[error] $*\e[39m"; exit 1; }
function check_install {  ${pkg_check_cmd} "$*" | grep -q  "$*" || ( ${pkg_mgr_cmd} "$*";  warn "you probably have to reboot" ; false ); }
check_install kernel-headers
check_install kernel-devel

command -v openssl > /dev/null 2>&1 || ( warn "missing openssl"; ${pkg_mgr_cmd} openssl )
command -v jq > /dev/null 2>&1 || ( warn "missing jq"; ${pkg_mgr_cmd} jq )
command -v curl > /dev/null 2>&1 || ( warn "missing curl"; ${pkg_mgr_cmd} curl )
command -v mokutil > /dev/null 2>&1 || ( warn "missing mokutil" ; ${pkg_mgr_cmd} mokutil )

function check_key () {
  if [ -f "${mokutil_out_dir}"/MOK.priv ]; then
    info "probing MOK.der"
    if mokutil --test-key "${mokutil_out_dir}/MOK.der" | grep -q "already enrolled"; then
      info "The Key is already trusted"
      install_v4l2loopback
    else
      warn "info the key exist but is not trusted yet, reimporting it because it does not hurt. You missing a reboot?"
      import_trust
    fi
  else
    info "Generating keys to sign"
    mokutil_setup
  fi
}

function signing_ko () {
  export KBUILD_SIGN_PIN="${mokutil_509key_pass}"
  sign_file_dir="${sign_file_dir:-/usr/src/kernels/"$(uname -r)"/scripts}"
  if [[ -f /lib/modules/"$(uname -r)"/extra/v4l2loopback.ko.xz || -f /lib/modules/"$(uname -r)"/extra/v4l2loopback.ko ]]; then
    ko_folder="${ko_folder:-/lib/modules/$(uname -r)/extra}"
  elif [[ -f /lib/modules/"$(uname -r)"/extra/v4l2loopback/v4l2loopback.ko.xz || -f /lib/modules/"$(uname -r)"/extra/v4l2loopback/v4l2loopback.ko ]]; then
    ko_folder="${ko_folder:-/lib/modules/$(uname -r)/extra/v4l2loopback}"
  else
    warn "Can not locate the folder used for v4l2loopback.ko.xz to unxz and sign. Find the file and try to set the var 'ko_folder'"
  fi
  if [[ ! -f "${ko_folder}"/v4l2loopback.ko.xz || ! -f "${ko_folder}"/v4l2loopback.ko ]]; then
    warn "there might be no file to sign. Please check ${ko_folder}" ; ko_folder="${ko_folder:-/lib/modules/$(uname -r)/extra}"
  fi
  info "Cert Password:"
  info "$mokutil_509key_pass"
  unxz -f "${ko_folder}/v4l2loopback.ko.xz"
  ${sign_file_dir}/sign-file sha256 "${mokutil_out_dir}/MOK.priv" "${mokutil_out_dir}/MOK.der" "${build_dir}/v4l2loopback.ko"  && info "${build_dir}/v4l2loopback.ko"
  ${sign_file_dir}/sign-file sha256 "${mokutil_out_dir}/MOK.priv" "${mokutil_out_dir}/MOK.der" "${ko_folder}/v4l2loopback.ko"  && info "${ko_folder}/v4l2loopback.ko"
  xz -f "${ko_folder}/v4l2loopback.ko"
  info "finished signing_ko"
}

function mokutil_setup () {
  if [ ! -f "${mokutil_out_dir}"/MOK.priv ]; then
    info "Still no Private key found, Generating one"
    ( umask 077 && mkdir -p "${mokutil_out_dir}")
    name="$(hostname)_signing_key"
    echo "${mokutil_509key_pass}" > "${mokutil_out_dir}/.openssl_pass"
    openssl \
    req -new -x509 \
    -passin pass:"${mokutil_509key_pass}" \
    -passout pass:"${mokutil_509key_pass}" \
    -newkey rsa:2048 \
    -keyout "${mokutil_out_dir}/MOK.priv" \
    -outform DER \
    -out "${mokutil_out_dir}/MOK.der" \
    -days 31500 \
    -subj "/CN=${name}/" \
    -addext "extendedKeyUsage=codeSigning" || error "issue creating cert"
    openssl x509 -inform der -in "${mokutil_out_dir}"/MOK.der -out "${mokutil_out_dir}"/MOK.pem
    mkdir -p /usr/src/kernels/"$(uname -r)"/certs/

    cat "${mokutil_out_dir}"/MOK.pem > /usr/src/kernels/"$(uname -r)"/certs/signing_key.pem
    #  cp "${mokutil_out_dir}"/MOK.der /usr/src/kernels/"$(uname -r)"/certs/signing_key.pem
    chmod 600 "${mokutil_out_dir}"/MOK*
    chmod 600 "${mokutil_out_dir}"/.openssl_pass
    echo "The pasword for the x509 cert is: ${mokutil_509key_pass}"
    import_trust
  else
    echo "Private key already present"
  fi
  info "finished mokutil_setup"
}

function import_trust () {
  info "Enroling new cert"
  warn "Set a one-time import password, Make it memorablel, you have to type it into later"
  warn "for a example check https://gist.github.com/reillysiemens/ac6bea1e6c7684d62f544bd79b2182a4"
  mokutil --import "${mokutil_out_dir}"/MOK.der
  info "A Key has been generated and importet into mokutil"
  mokutil --list-new
  info "Now reboot your machine and import the certificate with the just typed password"
  exit 0
  info "finished import_trust"
}

function install_v4l2loopback () {
  info "start install_v4l2loopback"
  curl -SL "${TAR_dl}" -o "${tmp_dir}"/v4l2loopback_"${TAR_v}".tar.gz
  mkdir -p "${build_dir}"
  tar xfv "${tmp_dir}"/v4l2loopback_"${TAR_v}".tar.gz --directory="${build_dir}"
  mv "${build_dir}"/umlaeute-v4l2loopback-*/* "${build_dir}"/.
  rm -r "${build_dir}"/umlaeute-v4l2loopback-*
  pushd "${build_dir}" || exit
  make clean
  make || build_failed
  mkdir -p /usr/src/kernels/"$(uname -r)"/certs/
  if [[ -z "$skip_signing" ]]; then
      info "Cert Password:"
      info "$mokutil_509key_pass"
      export KBUILD_SIGN_PIN="${mokutil_509key_pass}"
      cp "${mokutil_out_dir}"/MOK.pem /usr/src/kernels/"$(uname -r)"/certs/signing_key.pem
      chmod 444 /usr/src/kernels/"$(uname -r)"/certs/signing_key.pem
      # info "stat file"
      # stat /usr/src/kernels/"$(uname -r)"/certs/signing_key.pem
  fi
  make install 
  ls /lib/modules/"$(uname -r)"/extra/
  if [[ -z "$skip_signing" ]]; then
      info "Now Manually singing"
      signing_ko
  fi
  popd || return
  depmod -a
  modprobe v4l2loopback
  modinfo v4l2loopback
  info "finished install_v4l2loopback"
  lsmod | grep -q v4l2loopback && info "v4l2loopback loaded!"
}


function slr_as_webcam () {
  # https://medium.com/nerdery/dslr-webcam-setup-for-linux-9b6d1b79ae22
  command -v ffmpeg > /dev/null 2>&1 || ( warn "missing ffmpeg"; ${pkg_mgr_cmd} ffmpeg )
  command -v gphoto2 > /dev/null 2>&1 || ( warn "missing gphoto2" ; ${pkg_mgr_cmd} gphoto2 )
  # Best formats
  # https://stackoverflow.com/a/59574988
  warn "quick 5s test"
  timeout 5 gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 "$(v4l2-ctl --list-devices | grep v4l2loopback -A 1 | grep -oe "/dev/video.*" | head -n 1)"
  
  # https://github.com/umlaeute/v4l2loopback/issues/391#issuecomment-800941494
  echo "v4l2loopback" > /etc/modules-load.d/v4l2loopback.conf
cat << EOF > /etc/modprobe.d/v4l2loopback.conf
# Module options for v4l2loopback
options v4l2loopback exclusive_caps=1,1
options v4l2loopback devices=2
options v4l2loopback max_buffers=2
options v4l2loopback video_nr=63,102
options v4l2loopback card_label="obs,slr"
EOF
info "Config to Automaticaly load Kernel module added"
}

function build_failed () {
  echo "
    When you see 
      *** No rule to make target 'clean'.  Stop. 
    Probably kernel-headers and kernel do not have the same version… Install, reboot and try again!
    otherwise you could try running 'dnf donwgrade gcc' https://ask.fedoraproject.org/t/fedora-34-beta-and-oot-kmod-nvidia-virtualbox-v4l2loopback-etc/12778
  "
}

function help () {
  echo "
     just run the script, reboot (you will have to type a pass you set) and run again!
     you can also run '$0 slr_as_webcam' to install tools you need to use a dslr as webcam
  "
}

if [ "$EUID" -ne 0 ]
then error "Please run as root"
else
  if [ "$#" -eq  "1" ]
  then
    $1
    exit 0
  else
    if mokutil --sb-state | grep -q "SecureBoot enabled"; then
      grep -q "v4l2loopback" /proc/modules && info "v4l2loopback is loaded" || ( info "Secure boot is enabled and you have to setup singing" ; check_key)
    else
      warn "no need to sing Stuff!"
      export skip_signing=1
      grep -q "v4l2loopback" /proc/modules || install_v4l2loopback 
    fi
  fi
fi
