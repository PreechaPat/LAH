process DOWNLOAD_UNPACK {
	tag "${meta.id}"
	label 'process_single'

	conda "conda-forge::tar"
	container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
		? 'https://depot.galaxyproject.org/singularity/seqkit:2.9.0--h9ee0642_0'
		: 'biocontainers/seqkit:2.9.0--h9ee0642_0'}"

	input:
	tuple val(meta), path(archive)

	output:
	tuple val(meta), path("output"), emit: unpacked
	path "versions.yml", emit: versions

	when:
	task.ext.when == null || task.ext.when

	script:
	def args = task.ext.args ?: ''
	def prefix = task.ext.prefix ?: "${meta.id}"
	"""
    mkdir -p output
    tar -xzf "${archive}" -C output

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        tar: \$(tar --version | head -n 1)
    END_VERSIONS
    """
}
