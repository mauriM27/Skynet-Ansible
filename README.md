## Instalar Ansible
Para instalar **Ansible** en **WINDOWS** debes ejecutar los siguientes comandos:


Instalar WSL

https://blogthinkbig.com/instalar-wsl-windows-subsystem-for-linux-windows-10/

```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```


## Paso 1


Descarga el repositorio 

```
git clone https://mavm27@bitbucket.org/seguridadma/ansible-skynet.git

```


## Paso 2


Abre en cada una de las pc a las que le vas a instalar los programas una ventana de Powershell(con permisos de administrador) y pega el contenido que se encuentra en el archivo llamado begin.ps1
```
- name: Set Execution Policy to Bypass
  win_shell: Set-ExecutionPolicy Bypass -Scope Process -Force

- name: Descargar e instalar OpenSSH
  win_shell: |
    $url = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.0.0.0p1-Beta/OpenSSH-Win64.zip"
    $output = "C:\Temp\OpenSSH.zip"
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive -Path $output -DestinationPath C:\Temp\OpenSSH
    Move-Item -Path C:\Temp\OpenSSH\OpenSSH-Win64 -Destination C:\OpenSSH -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    Remove-Item -Path $output -Force
    Remove-Item -Path C:\Temp\OpenSSH -Recurse -Force

```

## Paso 3


Agrega las pc a las que le vamos a instalar los programas al archivo llamado **hosts**
```

[laptops]
laptop_1                        ansible_host=192.168.30.14       ansible_user=skynet       ansible_password=sky4     ansible_connection=ssh  ansible_shell_type=powershell   ansible_ssh_extra_args='-o StrictHostKeyChecking=no'

```

## Paso 4
Modificar el archivo llamado **laptops.yaml** y agregar el nombre de la pc o grupo de pc donde vamos a instalar los programas
```
- hosts: laptops
  roles:
    - install

```

## Paso 5


En la carpeta **playbooks** y ejecuta el siguiente comando para correr ansible


```
ansible-playbook -i ../hosts laptops.yml

```
