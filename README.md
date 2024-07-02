# GenomeFlow
[![Docker](https://img.shields.io/badge/Docker-Community_20.10.11-2496ED?style=flat&logo=docker)](https://docs.docker.com/engine/release-notes/20.10/)
[![GCP](https://img.shields.io/badge/Google%20Cloud-kubernetes-4285F4?style=flat&logo=googlecloud)](https://cloud.google.com/?hl=en)

a tool for automated development of computing architecture and resource optimization on Google Cloud Platform, which allows users to process a large number of samples at minimal cost

## Step-by-Step use of GenomeFlow

### Installtaion
```python
git clone [GenomeFlow Repository] 
```

### Usages
After installing GenomeFlow using pip, users load GenomeFlow:
```python
 import genomeflow as gf
```
Next, users load the workflow file along with other essential files, including the sample ID list and Dockerfile:
```python 
workflow=gf.loadJobFile("exampleWorkflow.snakemake")
```

Users then create a GCP architecture for the pipeline in the workflow:
```python
gf.createArchitecture(workflow)
```

Optimized parameters (optParams) are returned from the test run of GenomeFlow. The optParams will replace the previous resource settings of the workflow.
```python
optParams=gf.findOptimizedParam(workflow)
```

Then, users run all the samples with optimized resource parameters. Users can check the progress through the GenomeFlow monitoring interface which preserves all generated logs from the GenomeFlow controller.
```python 
gf.runPipeline(optParams)
```

### Get the results and check the costs
Results are stored in a user designated GCP bucket location. Users are able to download each result per sample and check the file metadata using the GCP web interface. Users are also able to download all the data using gsutil of Cloud SDK with the following command:
```bash
gsutil cp -n -r [Bucket Address] [Destination Address]
```

### Remove GenomoeFlow from GCP
After downloading all the sample results, users can remove GCP buckets and GCP architectures. The GCP architectures include GKE, Cloud SQL and GCP buckets, but do not include the GCP project itself.
```python
gf.removeProject(workflow)
```

If a user runs the remove function of GenomeFlow without any input parameters, it leaves the GCP project untouched. The purpose of preventing removal of the GCP project is to provide a cost check for the user. If users wish to remove the GCP project too, they can use the following command:
```python
gf.removeProject(workflow, all=True)
```

# Licenses
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC_BY--NC_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)
[![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
