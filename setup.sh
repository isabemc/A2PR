set -e
conda create -n A2PR python=3.9 -y
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate A2PR
pip install -U pip setuptools wheel
pip install "cython==0.29.36"
pip install -r requirements.txt || true
sudo apt -y update
sudo apt -y install libglfw3 libglfw3-dev libegl1 libgles2
mkdir -p ~/.mujoco && cd ~/.mujoco
if [ ! -d mujoco210 ]; then
  wget -q https://github.com/google-deepmind/mujoco/releases/download/2.1.0/mujoco210-linux-x86_64.tar.gz
  tar -zxf mujoco210-linux-x86_64.tar.gz
fi
grep -qxF 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin' ~/.bashrc || echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin' >> ~/.bashrc
grep -qxF 'export MUJOCO_PY_MUJOCO_PATH=$HOME/.mujoco/mujoco210' ~/.bashrc || echo 'export MUJOCO_PY_MUJOCO_PATH=$HOME/.mujoco/mujoco210' >> ~/.bashrc
grep -qxF 'export MUJOCO_GL=egl' ~/.bashrc || echo 'export MUJOCO_GL=egl' >> ~/.bashrc
source ~/.bashrc
cd ~
rm -rf D4RL
git clone https://github.com/Farama-Foundation/D4RL.git
cd D4RL
pip install -e .
pip install --no-cache-dir "mujoco-py==2.1.2.14"
echo "setup successful. activate by running conda activate A2PR"
