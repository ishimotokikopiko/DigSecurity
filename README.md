#### DigSecurity DevOps Task ####
# Run on ubuntu 22.04 LTS.

# Install kubectl.
sudo apt apdate -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --output=yaml    

# Install docker.
sudo apt-get install docker.io
sudo groupadd docker
sudo usermod -aG docker $USER && newgrp docker
sudo systemctl enable docker
sudo systemctl start docker

# Install minicube.
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
minikube version
minikube start
kubectl cluster-info

# Install pipenv.
pip install --user pipenv
python3 -m pipenv --python 3.10.6

# Install uwsgi.
sudo apt install build-essential
python3 -m pipenv install uwsgi


# Install nginx.
sudo apt install -y nginx
cat nginx.conf to /etc/nginx.conf

# Enter python virtual-env pyenv.
sudo apt install build-essential cmake mesa-common-dev libglu1-mesa-dev libglew-dev libxtst-dev libxrandr-dev libpng-dev libjpeg-dev zlib1g-dev libbz2-dev libogg-dev libvorbis-dev libc6-dev yasm libasound-dev libpulse-dev binutils-dev libgtk-3-dev libmad0-dev libudev-dev libva-dev nasm
sudo apt install pyenv
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' > ~/.bashrc
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source ~/.bashrc
pyenv install --list
pyenv install 3.7.17
pyenv versions
pyenv shell 3.7.17
pyenv versions
pip install -r requirements.txt
uwsgi --http-socket :8000 --module yadyedida_v1.wsgi:application

# Enter python virtual-env pipenv.
git clone ${GIT_REPO}
pipenv sync
pipenv shell
uwsgi --http-socket :8000 --module yadyedida_v1.wsgi:application

# Run app.
source ../.env_python 
python manage.py makemigrations            # Migrate custom modules.
python manage.py migrate                   # Migrate buildin modules.
python manage.py runserver                 # Run local.
python manage.py runserver 0.0.0.0:8000    # On docker
python manage.py makemigrations            # Migrate custom modules.
python manage.py createsuperuser