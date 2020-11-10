docker build -t jupyterhub:scnuse .
sudo mkdir -p /jupyterhub/config && sudo cp config.py /jupyterhub/config
sudo mkdir -p /jupyterhub/public && sudo cp public/* /jupyterhub/public
docker run -d --restart always -p 8000:8000 --name jupyterhub \
       -v /jupyterhub/user:/home                              \
       -v /jupyterhub/public:/public                          \
       -v /jupyterhub/config:/srv/jupyterhub                  \
       jupyterhub:scnuse
