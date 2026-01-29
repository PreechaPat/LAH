process SEQKIT_SAMPLE {
	tag "${meta.id}"
	label 'process_low'

	conda "bioconda::seqkit=2.3.0"
	container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
		? 'https://depot.galaxyproject.org/singularity/seqkit:2.9.0--h9ee0642_0'
		: 'biocontainers/seqkit:2.9.0--h9ee0642_0'}"

	input:
	tuple val(meta), path(reads)

	output:
	tuple val(meta), path("output/*.fastq.gz"), emit: reads
	path "versions.yml", emit: versions

	when:
	task.ext.when == null || task.ext.when

	script:
	def args = task.ext.args ?: ''
	def prefix = task.ext.prefix ?: "${meta.id}"
	def n_reads = task.ext.n_reads ?: 8000
	"""
	mkdir output/
    seqkit sample \
        ${args} \
        -n ${n_reads} \
        -o output/${prefix}.fastq.gz \
        ${reads}

	cat <<-END_VERSIONS > versions.yml
	"${task.process}":
		seqkit: \$(seqkit version 2>&1 | awk '{print \$2}')
	END_VERSIONS
    """
}
