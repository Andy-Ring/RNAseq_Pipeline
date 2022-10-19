#!/bin/bash


#activating a standard bioinfomatics environment

source /home/ringa/miniconda3/bin/activate bioinfo

#This pipeline assumes that you have you have split pair end fastq files with short names listed in a text file called "fastq_names" in the same directory as the fastq files

#path to refs

ref=/data/ringa/refs

#Path to fastq file directory

path=/data/ringa/ryandata

# Performing fastq alignment to hg38 referance genome using "hisat2" and "parallel" and sort bam file output
# Note: Hisat2 indexing of reference genome must have already been performed, -x option provides the basename for indexed reference

cat $path/fastq_names | parallel "hisat2 -x $ref/hg38.fa -1 $path/{}_R1.fq -2 $path/{}_R2.fq -S $path/bam/{}.bam | samtools sort > $path/bam/{}.bam"

#Indexing each bam file

cat $path/fastq_names | parallel "samtools index $path/bam/{}.bam"

#Performing gene counting using the hg38 transcriptome and "featureCounts"

featureCounts -p -a $ref/hg38.gtf -o $path/counts_ryan_1.txt $path/bam/*.bam

#Keep in mind that this will create a count matrix that is in alphabetic order based off the .bam file names, not necessarily control vs experimental. The count matrix can be exported and run on your local machine for differential gene expression testing.

#end

