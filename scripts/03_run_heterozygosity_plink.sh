#!/bin/bash

plink \
  --vcf sparrow_autosomes.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --chr-set 30 no-xy no-mt \
  --set-missing-var-ids @:# \
  --het \
  --out sparrow_het
