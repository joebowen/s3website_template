#!/bin/bash

(cd website && npm install)
(cd website && npm update)

(cd website && gulp dev)