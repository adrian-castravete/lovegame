#!/bin/bash

zip -9r lovegame.`date +%Y%m%d%H%M`.love . -x*.swp -xconcept/* -xolder-unused/* -x.git* -x*.love
