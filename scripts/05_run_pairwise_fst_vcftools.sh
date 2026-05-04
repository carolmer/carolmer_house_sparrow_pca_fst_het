#!/bin/bash

mkdir -p pop_lists pairwise_fst

awk '{print $3}' populations_plink.txt | sort | uniq > pops.txt

while read pop; do
  awk -v p="$pop" '$3 == p {print $2}' populations_plink.txt > pop_lists/${pop}.txt
done < pops.txt

while read pop1; do
  while read pop2; do
    if [[ "$pop1" < "$pop2" ]]; then
      echo "Running $pop1 vs $pop2"

      vcftools \
        --gzvcf sparrow_autosomes.vcf.gz \
        --weir-fst-pop pop_lists/${pop1}.txt \
        --weir-fst-pop pop_lists/${pop2}.txt \
        --out pairwise_fst/${pop1}_vs_${pop2}
    fi
  done < pops.txt
done < pops.txt
