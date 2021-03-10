rule run_all_of_me:
    input: "results/all.cmp.matrix.png"
    

rule download_genomes:
    output:
        f1 = "raw_data/1.fa.gz",
        f2 = "raw_data/2.fa.gz",
        f3 = "raw_data/3.fa.gz",
        f4 = "raw_data/4.fa.gz",
        f5 = "raw_data/5.fa.gz",
        f6 = "raw_data/6.fa.gz",
        f7 = "raw_data/7.fa.gz",
        f8 = "raw_data/8.fa.gz",
        f9 = "raw_data/9.fa.gz",
        f10 = "raw_data/10.fa.gz",
        f11 = "raw_data/11.fa.gz"
    shell: """
       wget https://osf.io/t5bu6/download -O {output.f1}
       wget https://osf.io/ztqx3/download -O {output.f2}
       wget https://osf.io/w4ber/download -O {output.f3}
       wget https://osf.io/dnyzp/download -O {output.f4}
       wget https://osf.io/ajvqk/download -O {output.f5}
       wget https://osf.io/qh5wv/download -O {output.f6}
       wget https://osf.io/fbyq7/download -O {output.f7}
       wget https://osf.io/8amhx/download -O {output.f8}
       wget https://osf.io/ce2kv/download -O {output.f9}
       wget https://osf.io/w8v3f/download -O {output.f10}
       wget https://osf.io/jscdk/download -O {output.f11}   
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
        expand("results/{n}.fa.gz.sig", n=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
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
