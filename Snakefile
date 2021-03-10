rule run_all_of_me:
    input: "results/all.cmp.matrix.png"
    

rule download_genomes:
    output:
        f1 = "raw_data/1.fa.gz",
        f2 = "raw_data/2.fa.gz",
        f3 = "raw_data/3.fa.gz",
        f4 = "raw_data/4.fa.gz",
        f5 = "raw_data/5.fa.gz"
    shell: """
       wget https://osf.io/t5bu6/download -O {output.f1}
       wget https://osf.io/ztqx3/download -O {output.f2}
       wget https://osf.io/w4ber/download -O {output.f3}
       wget https://osf.io/dnyzp/download -O {output.f4}
       wget https://osf.io/ajvqk/download -O {output.f5}
    """

rule sketch_genomes:
    conda: "environment.yml"
    input:
        "raw_data/{name}.fa.gz"
    output:
        "results/{name}.fa.gz.sig"
    shell: """
        sourmash compute -k 31 {input} -o {output}
    """

rule compare_genomes:
    conda: "environment.yml"
    input:
        expand("results/{n}.fa.gz.sig", n=[1, 2, 3, 4, 5])
    output:
        cmp = "results/all.cmp",
        labels = "results/all.cmp.labels.txt"
    shell: """
        sourmash compare {input} -o {output.cmp}
    """

rule plot_genomes:
    conda: "environment.yml"
    input:
        cmp = "results/all.cmp",
        labels = "results/all.cmp.labels.txt"
    output:
        "results/all.cmp.matrix.png",
        "results/all.cmp.hist.png",
        "results/all.cmp.dendro.png",
    shell: """
        sourmash plot {input.cmp} --output-dir results
    """
