#!/usr/bin/env bash
#Run: ./FastqSequenceSplitter.sh sequence.fastq length

split -l 4 $1 rename_


for i in rename*; do mv $i $(head -1 $i).fq; done


for i in @*.fq; do sed -i '1d;3d' $i


split -l 1 $i ${i%.fq}"_"


for j in ${i%.fq}"_aa"; do cat $j | while IFS= read -r line; do echo $line | fold -w$2 > ${i%.fq}"_aa"; done; done
for j in ${i%.fq}"_ab"; do cat $j | while IFS= read -r line; do echo $line | fold -w$2 > ${i%.fq}"_ab"; done; done


paste -d'\n' ${i%.fq}"_aa" ${i%.fq}"_ab" > ${i%.fq}".int1.fastq"


awk -v max="$2" 'length($0)==max{print val ORS $0}' ${i%.fq}".int1.fastq" > ${i%.fq}".int.fastq"
rm -r ${i%.fq}".int1.fastq" ${i%.fq}"_aa" ${i%.fq}"_ab" $i


linii=$( wc -l < ${i%.fq}".int.fastq" )

for (( j=1; j<=$linii; j=j+4 )); do sed -i -e "$j s/^$/${i%.fq}_$j/" ${i%.fq}".int.fastq"; done
for (( z=3; z<=$linii; z=z+4 )); do sed -i -e "$z s/^$/+/" ${i%.fq}".int.fastq"; done

done


find . -type f -name "*.int.fastq" -print0 | xargs -0 cat > results.fastq


find . -type f -name "*.int.fastq" -delete
