#!/bin/bash

# Run PCA with PLINK

plink \
  --vcf sparrow_autosomes.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --chr-set 30 no-xy no-mt \
  --set-missing-var-ids @:# \
  --pca 20 \
  --out sparrow_pca
