 #!/usr/bin/env bash

# Install AWS dependency.
python -m venv ./venv
python -m pip install --upgrade pip
pip install -r requirements.txt
source venv/bin/activate
# Install tfenv.
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
ln -s ~/.tfenv/bin/* /usr/local/bin
# Install latest terraform version.
tfenv install latest
tfenv use latest
# Setup AWS Environment Variables:
## Set your AWS ENV in `.env`.
source .env
terraform validate
terraform init
terraform plan
