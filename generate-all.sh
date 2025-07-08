#!/bin/bash

cd crosswalks
bash generate-codemeta.sh

cd ../shexml-codemeta
bash generate-codemeta.sh

cd ../dmaog-codemeta
bash generate-codemeta.sh