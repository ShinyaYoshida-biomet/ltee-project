# LTEE variant calling

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24598516.svg)](https://doi.org/10.5281/zenodo.24598516)

Variant calling on three _E. coli_ clones from population Ara-3 of Richard
Lenski's Long-Term Evolution Experiment (LTEE), frozen at 5,000, 15,000 and
50,000 generations. Question: how many mutations accumulated, and is the
answer robust to the minimum read depth used to filter variant calls?

Built as the example project of the Reproducible and Open Science lessons.
The analysis steps follow the Data Carpentry lesson _Wrangling
Genomics_ (CC BY 4.0).

Author: Shinya Yoshida ([ORCID 0009-0003-2702-7166](https://orcid.org/0009-0003-2702-7166))

## Publication

None yet. The data and biology are from Tenaillon et al. (2016), _Nature_
536:165–170, <https://doi.org/10.1038/nature18959>.

## Reproduce the results

Requirements: [Pixi](https://pixi.prefix.dev/latest/) and an internet
connection. Linux or macOS (on Windows use WSL2: `bwa`, `samtools` and
`bcftools` have no Windows builds). No other installation is needed.

```bash
git clone https://github.com/ShinyaYoshida-biomet/ltee-project.git
cd ltee-project
pixi run reproduce
```

`pixi run reproduce` installs the exact software versions in `pixi.lock`,
downloads the raw data and checks its checksums, runs the Snakemake workflow
and renders the report. A GitHub Action runs the same command on every push.

Other entry points: `pixi run run-nextflow` (the same pipeline in Nextflow),
`pixi run compare-workflows` (checks that both give identical variant calls),
`pixi task list` (all tasks).

A container image of the pipeline environment can be built from
`containers/Dockerfile` (see the comments in that file).

## Hardware

Measured on 2026-11-27 on a MacBook Pro with an Apple M5 Pro and 24 GB of RAM. The installed Pixi environments use about 1.1 GiB (`default`) and
2.6 GiB (`pipeline`); raw data uses 332 MiB and the current results use
about 1.0 GiB.

## Outputs

| Path                                     | Content                                                                                     |
| ---------------------------------------- | ------------------------------------------------------------------------------------------- |
| `reports/ltee-report.html`               | The report: data, read quality, variants, the depth sensitivity analysis, software versions |
| `results/qc/multiqc/multiqc_report.html` | Read quality summary                                                                        |
| `results/vcf/`                           | Filtered variant calls per sample (minimum depth from `config/config.yaml`)                 |
| `results/sensitivity/`                   | Variant calls at each depth in `sensitivity_depths`                                         |
| `results/stats/`                         | Alignment (`flagstat`) and variant (`bcftools stats`) statistics                            |

Expected filtered variants at minimum depth 2: SRR2589044 10, SRR2584863 25,
SRR2584866 775.

## Data

Raw reads: a subset of three runs prepared by Data Carpentry, figshare,
<https://doi.org/10.6084/m9.figshare.7726454> (file `sub.tar.gz`, CC0).
Original runs in NCBI BioProject PRJNA295606. Reference: _E. coli_ B str.
REL606, GenBank CP000819.1. Sources, provider checksums and our checksums are
in `metadata/`; the data is not stored in this repository.

## Repository contents

See the table in `docs/structure.md` (each folder also has its own README).

## Cite

See `CITATION.cff` (GitHub: "Cite this repository").

## License

Code: MIT (`LICENSE`). Report text and figures: CC BY 4.0. The raw data is
CC0 (see Data).

## Contact

Questions and problems: open an issue on GitHub. Contributions: see
`CONTRIBUTING.md`. Everyone taking part follows `CODE_OF_CONDUCT.md`.
