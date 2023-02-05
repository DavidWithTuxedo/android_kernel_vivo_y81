#!/bin/bash
# Rename the configs #

for old in `ls *debug*PD*`
do
	head=$(echo $old | cut -d'_' -f1-5)
	tail=$(echo $old | cut -d'_' -f1-5 --complement)
	git mv ${old} ${tail}_${head}
done

for old in `ls *PD* | grep -v debug`
do
	head=$(echo $old | cut -d'_' -f1-4)
	tail=$(echo $old | cut -d'_' -f1-4 --complement)
	git mv ${old} ${tail}_${head}
done

