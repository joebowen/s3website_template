#!/bin/bash

apt install -y npm nodejs gulp awscli


(cd website && npm install)
(cd website && npm update)

