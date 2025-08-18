#!/usr/bin/env bash
set -euo pipefail

# install_dev_tools.sh
# Автовстановлення: Docker, Docker Compose, Python 3.9+, Django
# Платформи: Ubuntu 20.04+ / Debian 11+

need_sudo=""
if [ "$EUID" -ne 0 ]; then
  need_sudo="sudo"
fi

log() { printf "\n[INFO] %s\n" "$*"; }
err() { printf "\n[ERROR] %s\n" "$*" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

install_prereqs() {
  log "Оновлення пакетів і базових утиліт"
  $need_sudo apt-get update -y
  $need_sudo apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common
}

install_docker() {
  if have docker; then
    log "Docker вже встановлено: $(docker --version)"
    return
  fi
  log "Встановлення Docker Engine з офіційного репозиторію"
  # налаштування ключа
  install -m 0755 -d /etc/apt/keyrings || true
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg \
      | $need_sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    $need_sudo chmod a+r /etc/apt/keyrings/docker.gpg
  fi
  # репозиторій
  repo_line="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(. /etc/os-release; echo "$VERSION_CODENAME") stable"
  if ! grep -q "^${repo_line}" /etc/apt/sources.list.d/docker.list 2>/dev/null; then
    echo "$repo_line" | $need_sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  fi
  $need_sudo apt-get update -y
  $need_sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  log "Docker встановлено: $(docker --version)"
  # дозволити запускати docker без sudo для поточного користувача
  if getent group docker >/dev/null; then
    $need_sudo usermod -aG docker "$USER" || true
    log "Додано користувача $USER до групи docker. Перелогуйтеся щоб застосувати"
  fi
}

install_compose() {
  # перевіряємо плагін docker compose v2
  if docker compose version >/dev/null 2>&1; then
    log "Docker Compose вже встановлено: $(docker compose version | head -n1)"
    return
  fi
  log "Встановлення Docker Compose як плагіна"
  $need_sudo apt-get install -y docker-compose-plugin
  if docker compose version >/dev/null 2>&1; then
    log "Docker Compose встановлено: $(docker compose version | head -n1)"
  else
    err "Не вдалося встановити docker compose. Перевірте репозиторій Docker і мережу"
    exit 1
  fi
}

python_version_ok() {
  if ! have python3; then return 1; fi
  pyver=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
  # порівняння версії
  python3 - <<'PY' "$pyver"
import sys
from distutils.version import LooseVersion as V
print( int(V(sys.argv[1]) >= V("3.9.0")) )
PY
}

install_python() {
  if [ "$(python_version_ok)" -eq 1 ] 2>/dev/null; then
    log "Python вже встановлено: $(python3 --version)"
  else
    . /etc/os-release
    log "Встановлення Python 3.9+"
    if [ "$ID" = "ubuntu" ]; then
      # deadsnakes для старих Ubuntu
      $need_sudo add-apt-repository -y ppa:deadsnakes/ppa || true
      $need_sudo apt-get update -y
      $need_sudo apt-get install -y python3.10 python3.10-venv python3-pip
      # виставляємо python3 -> 3.10 якщо потрібно
      if ! python3 --version 2>/dev/null | grep -qE '3\.(9|1[0-9])'; then
        $need_sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2
      fi
    else
      # Debian 11+: зазвичай є 3.9 у backports або стандарті
      $need_sudo apt-get update -y
      $need_sudo apt-get install -y python3 python3-venv python3-pip
      if [ "$(python_version_ok)" -ne 1 ]; then
        err "Python версії 3.9+ недоступний зі стандартних репозиторіїв. Додайте backports або оновіть систему"
        exit 1
      fi
    fi
    log "Python встановлено: $(python3 --version)"
  fi

  # pip3
  if have pip3; then
    log "pip вже встановлено: $(pip3 --version)"
  else
    log "Встановлення pip3"
    $need_sudo apt-get install -y python3-pip
  fi
}

install_django() {
  if pip3 show Django >/dev/null 2>&1; then
    djv=$(pip3 show Django | awk '/Version:/ {print $2}')
    log "Django вже встановлено через pip: $djv"
    return
  fi
  log "Встановлення Django для поточного користувача"
  # встановлюємо у ~/.local щоб не ламати системні пакети
  pip3 install --user --upgrade pip
  pip3 install --user "Django>=4.2"
  djv=$(python3 -c "import django; print(django.get_version())" 2>/dev/null || echo "unknown")
  log "Django встановлено: $djv (локація $(python3 -c 'import site,sys; print(site.getusersitepackages())' 2>/dev/null || echo ~/.local/lib))"
  log "Додайте ~/.local/bin у PATH якщо потрібно: export PATH=\$HOME/.local/bin:\$PATH"
}

main() {
  install_prereqs
  install_docker
  install_compose
  install_python
  install_django
  log "Готово"
}

main "$@"
