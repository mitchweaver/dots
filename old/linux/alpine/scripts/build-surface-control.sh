#!/bin/sh

cd ~/tmp

git clone https://github.com/linux-surface/surface-control

cd surface-control

cargo build --release --locked

