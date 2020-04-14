#!/bin/bash

chmod 755 artisan
./artisan october:up
./artisan package:discover
./artisan cache:clear
./artisan config:clear
./artisan october:util set build
