


                                                Como instalar varios programas en varias PC al mismo tiempo usando Ansible




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

Clonar el repositorio 

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
laptop_1                        ansible_host=192.168.30.14       ansible_user=skynet       ansible_password=sky4     ansible_connection=ssh  ansible_shell_type=powershell   ansible_ssh_extra_args='-o StrictHostKeyChecking=no'

```


## Paso 4



Navegar hasta el archivo llamado **main.yaml** y agrega los programas que quieres instalar: "en este caso anydesk, ninite (con winrar, chrome, vlc), office365" .   "Para instalar OFFICE 365 el script verifica la arquitectura del cliente y instala la correspondiente, debes seguir seguir el paso 5 para que se instale correctamente"

```

- name: Crear directorio Temp si no existe
  win_file:
    path: C:\Temp
    state: directory

- name: Descargar AnyDesk
  win_get_url:
    url: "https://download.anydesk.com/AnyDesk.exe"
    dest: C:\Temp\AnyDesk.exe

- name: Descargar Ninite
  win_get_url:
    url: "https://ninite.com/chrome-vlc-winrar/ninite.exe"
    dest: C:\Temp\ninite.exe

- name: Copiar instalador de Office a la carpeta Temp
  ansible.builtin.copy:
    src: "/mnt/c/Users/SATMAURI/Documents/officeSkynet/{{ 'OfficeSetup64.exe' if ansible_architecture == 'x86_64' else 'OfficeSetup32.exe' }}"
    dest: "C:\\Temp\\OfficeSetup.exe"

- name: Instalar Office 365
  win_command: "C:\\Temp\\OfficeSetup.exe /silent"
  ignore_errors: true
  register: office_install_result

- name: Verificar si Office 365 se instaló correctamente
  debug:
    msg: "Office 365 se instaló correctamente"
  when: office_install_result.rc == 0

```

## Paso 5

Descargar los .exe de office dependiendo de la arquitectura del cliente "64 bits o 32 bits" y guardarlos en una carpeta dentro de ansible en este caso en:

\\wsl.localhost\Ubuntu\officeSkynet

Recomendable modifcar los nombres de los instaladores para diferenciarlos en este caso los he renombrado como: 

- OfficeSetup64.exe
- OfficeSetup32.exe

## Paso 6


En la carpeta **playbooks** y ejecuta el siguiente comando para correr ansible


```
ansible-playbook -i ../hosts laptops.yml
```