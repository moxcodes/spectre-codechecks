#!/bin/bash
git log --graph --decorate | grep commit | grep "(.*)" | sed '2q;d' | sed 's/\(.*commit \)\(.*\)\([(].*\)/\2/' | xargs echo -n | pcregrep "[^\n]"
