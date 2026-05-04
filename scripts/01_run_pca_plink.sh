#!/bin/bash

set -euo pipefail

cd /work/c/carolinemerriman/cpg_proj

conda activate cpg_env

mkdir -p pca
cd pca

# 1. Make list of chromosome VCFs, excluding chrZ, mtDNA, and scaffolds
find /work/c/carolinemerriman/cpg_proj/chroms -name "chr*_default_filters.vcf.gz" \
  | grep -v "/chrZ/" \
  | grep -v "/mtDNA/" \
  | grep -v "/scaffolds/" \
  | sort -V > autosome_vcfs.txt

# 2. Concatenate autosomal chromosome VCFs
bcftools concat \
  -f autosome_vcfs.txt \
  -Oz \
  -o sparrow_autosomes.vcf.gz

# 3. Index concatenated VCF
bcftools index -t sparrow_autosomes.vcf.gz

# 4. Keep biallelic SNPs only
bcftools view \
  -m2 -M2 -v snps \
  sparrow_autosomes.vcf.gz \
  -Oz \
  -o sparrow_autosome_snps.vcf.gz

bcftools index -t sparrow_autosome_snps.vcf.gz

# 5. LD pruning
plink \
  --vcf sparrow_autosome_snps.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --chr-set 30 no-xy no-mt \
  --set-missing-var-ids @:# \
  --indep-pairwise 50 10 0.1 \
  --out sparrow_pca

# 6. PCA on pruned SNP set
plink \
  --vcf sparrow_autosome_snps.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --chr-set 30 no-xy no-mt \
  --set-missing-var-ids @:# \
  --extract sparrow_pca.prune.in \
  --make-bed \
  --pca 20 \
  --out sparrow_pca
