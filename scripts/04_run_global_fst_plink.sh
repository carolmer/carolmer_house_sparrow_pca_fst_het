#!/bin/bash

plink \
  --vcf sparrow_autosomes.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --chr-set 30 no-xy no-mt \
  --set-missing-var-ids @:# \
  --fst \
  --within populations_plink.txt \
  --out sparrow_fst
