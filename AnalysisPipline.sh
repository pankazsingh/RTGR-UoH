#Command lines for Variant Calling pipeline

#Mapping fastq files on Solanum lycopersicum reference genome SL 3.00
bwa mem -M -t 16 -R '@RG\tID:001_S1\tSM:001_S1\tPL:illumina' S_lycopersicum_chromosomes.3.00.fa *_1.fq *_2.fq > 001.sam

#Sorting BAM file
./jdk1.8.0_162/bin/java -jar -Xmx64g gatk-package-4.0.3.0-local.jar SortSam -I 001.sam -O 001.sorted.bam -SO coordinate

#MarkDuplicates
./jdk1.8.0_162/bin/java -jar -Xmx64g gatk-package-4.0.3.0-local.jar MarkDuplicates -I 001.sorted.bam -O 001.sorted.markdup.bam -M 001.metrics.txt 

#Indexing of BAM file
./jdk1.8.0_162/bin/java -jar -Xmx64g gatk-package-4.0.3.0-local.jar BuildBamIndex -I 001.sorted.markdup.bam

#Variant Calling
./jdk1.8.0_162/bin/java -jar -Xmx512g gatk-package-4.0.3.0-local.jar HaplotypeCaller -R S_lycopersicum_chromosomes.3.00.fa --native-pair-hmm-threads 48 -I 001.sorted.markdup.bam -O 001.vcf

#Extracting SNPs and INDELs separately
./jdk1.8.0_162/bin/java -jar -Xmx512g gatk-package-4.0.3.0-local.jar SelectVariants -R S_lycopersicum_chromosomes.3.00.fa -V 001.vcf -select-type SNP -O 001.SNP.vcf
./jdk1.8.0_162/bin/java -jar -Xmx512g gatk-package-4.0.3.0-local.jar SelectVariants -R S_lycopersicum_chromosomes.3.00.fa -V 001.vcf -select-type INDEL -O 001.INDEL.vcf

#Filtering SNPs and INDELs
./jdk1.8.0_162/bin/java -jar -Xmx512g gatk-package-4.0.3.0-local.jar VariantFiltration -R S_lycopersicum_chromosomes.3.00.fa -V 001.SNP.vcf --filter-expression "QD < 2.0 || FS > 60.0 || MQ <40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "SNP" -O 001_SNP_filtered.vcf
./jdk1.8.0_162/bin/java -jar -Xmx512g gatk-package-4.0.3.0-local.jar VariantFiltration -R S_lycopersicum_chromosomes.3.00.fa -V 001.INDEL.vcf --filter-expression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filter-name "INDEL" -O 001_INDEL_filtered.vcf

