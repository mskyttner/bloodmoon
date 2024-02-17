#!/bin/bash

wget https://redbean.dev/redbean-2.2.com -O redbean.com
chmod +x redbean.com
sh /redbean.com --assimilate

zip redbean.com .init.lua .lua/fullmoon.lua synth.db

echo "Now run ./redbean.com -v -p 8080 and open http://localhost:8080"
