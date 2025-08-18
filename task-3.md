# My Microservice Project — Task 3

## Task
Create a Bash script `install_dev_tools.sh` that automatically installs:
- Docker
- Docker Compose
- Python (version 3.9 or higher)
- Django (via pip / venv)

The script checks if the tools are already installed to avoid duplicate installations.

## Steps Completed
1. Added the script `install_dev_tools.sh`.
2. Made it executable:
   ```bash
   chmod u+x install_dev_tools.sh


Verified the script works in Ubuntu (WSL).

Created a new branch lesson-3 and pushed changes to GitHub.

Added .gitignore to exclude the virtual environment (.venv) from version control.

Usage

Run the script:

```bash
./install_dev_tools.sh
```


After installation, verify the tools:

```bash
docker --version
docker compose version
python3 --version
python3 -c "import django; print(django.get_version())"
```