process CONCAT_FASTA {
	label 'process_low'

	conda "bioconda::seqkit=2.9.0"
	container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
		? 'https://depot.galaxyproject.org/singularity/seqkit:2.9.0--h9ee0642_0'
		: 'biocontainers/seqkit:2.9.0--h9ee0642_0'}"

	input:
	path reads

	output:
	path ("output/all.fasta.gz"), emit: fasta

	when:
	task.ext.when == null || task.ext.when

	script:
	def args = task.ext.args ?: ''
	"""
	mkdir output
	cat ${reads} > output/all.fasta.gz
    """
}
