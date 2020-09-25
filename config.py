import sys
sys.setrecursionlimit(1000000)

c.Spawner.default_url = '/lab'

c.JupyterHub.admin_access = True
c.JupyterHub.authenticator_class = 'nativeauthenticator.NativeAuthenticator'
c.Authenticator.admin_users = {"clamorz"}
c.Authenticator.open_signup = True
c.Authenticator.ask_email_on_signup = True

import pwd
import subprocess

def pre_spawn_hook(spawner):
    username = spawner.user.name
    try:
        pwd.getpwnam(username)
    except KeyError:
        subprocess.check_call(['useradd', '-ms', '/bin/bash', username])

c.Spawner.pre_spawn_hook = pre_spawn_hook

c.GitHubConfig.access_token = "532d2dc998ee9f04556bee6a0c2f8781fc2d45ab"

import shutil
c.LanguageServerManager.language_servers = {
    "C": {
        "argv": [shutil.which("clangd-10")],
        "languages": ["c", "C", "c++", "C++17", "xcpp17", "c++src", "text/x-c++src"],
        "version": 1
    }
}

