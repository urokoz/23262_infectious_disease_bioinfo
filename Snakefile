SAMPLES=["sal_sampleA", "sal_sampleB"]
READS=["1", "2"]

rule all:
    input:
        expand("fastqc/{sample}_{read}.trimmed_fastqc.html", sample = SAMPLES, read=READS),
        expand("fastqc/{sample}_{read}_fastqc.html", sample=SAMPLES, read=READS),
        expand("species_finder_{sample}/{sample}_kmerfinder_summary.txt", sample=SAMPLES),
        expand("mlst_{sample}/{sample}_summary_mlst.txt", sample=SAMPLES)


rule trim:
    input:
        in1="data/{sample}/{sample}_1.fastq.gz",
        in2="data/{sample}/{sample}_2.fastq.gz"
    output:
        out1="trim/{sample}/{sample}_1.trimmed.fq.gz",
        out2="trim/{sample}/{sample}_2.trimmed.fq.gz"
    shell:
        """
        bbduk.sh in={input.in1} in2={input.in2} out={output.out1} out2={output.out2} qin=auto k=19 ktrim='r' ref=/home/projects/course_23262/data/adapters.fa mink=11 qtrim=r trimq=20 minlength=50 tbo tpe ziplevel=6 overwrite=t
        """

rule pretrim_qc:
    input:
        "data/{sample}/{sample}_{read}.fastq.gz"
    output:
        "fastqc/{sample}_{read}_fastqc.html"
    params:
        outDir="fastqc"
    shell:
        """
        fastqc {input} -o {params.outDir}
        """

rule posttrim_qc:
    input:
        "trim/{sample}/{sample}_{read}.trimmed.fq.gz"
    output:
        "fastqc/{sample}_{read}.trimmed_fastqc.html"
    params:
        outDir="fastqc"
    shell:
        """
        fastqc {input} -o {params.outDir}
        """

rule species_finder:
    input:
        "trim/{sample}/{sample}_1.trimmed.fq.gz",
        "trim/{sample}/{sample}_2.trimmed.fq.gz"
    output:
        "species_finder_{sample}/{sample}_kmerfinder_summary.txt"
    params:
        outDir="species_finder_{sample}",
        db_file="/home/projects/course_23262/tools/kmerfinder/kmerfinder_db/bacteria/bacteria.ATG",
        tax_file="/home/projects/course_23262/tools/kmerfinder/kmerfinder_db/bacteria/bacteria.tax"
    shell:
        """
        python /home/projects/course_23262/tools/kmerfinder/kmerfinder.py -o {params.outDir} -x -db {params.db_file} -tax {params.tax_file} -i {input}
        python /home/projects/course_23262/tools/WGStools_summary/kmerfinder_summary.py -i {params.outDir} -o {output}
        """

rule mlst:
    input:
        "trim/{sample}/{sample}_1.trimmed.fq.gz",
        "trim/{sample}/{sample}_2.trimmed.fq.gz"
    output:
        "mlst_{sample}/{sample}_summary_mlst.txt"
    params:
        outDir="mlst_{sample}",
        db_dir="/home/projects/course_23262/tools/mlst/mlst_db"
    shell:
        """
        python3 /home/projects/course_23262/tools/mlst/mlst.py -p {params.db_dir} -o {params.outDir} -s salmonella -i {input}
        python /home/projects/course_23262/tools/WGStools_summary/mlst_summary.py -i {params.outDir} -o {output} --jname
        """