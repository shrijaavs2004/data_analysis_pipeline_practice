# Building a Data Analysis pipeline tutorial
adapted from [Software Carpentry](http://software-carpentry.org/)

This example data analysis project analyzes the word count for all words in 4
novels. It reports the top 10 most occurring words in each book in a [report](doc/count_report.qmd).

---

## Recreate the computational environment

### 1. Clone repo

Clone this repo, and using the command line, navigate to the root of this project.

```bash
git clone <repo_name>
cd <folder_name>
```

### 2. Recreate the computational environment

<details>
<summary><b>Option 1: Use `conda-lock.yml`</b></summary>

2.1.1 Run the following commands to create the conda environment:

```
conda-lock install --name ia4 conda-lock.yml
```

2.1.2 Activate the conda environment:

```
conda activate ia4
```

2.1.3 Run the analysis:

```
bash runall.sh
```

</details>

<details>
<summary><b>Option 2: Use `environment.yml`</b></summary>

2.2.1 Create a conda environment using `environment.yml`

```bash
conda env create -n ia4 -f environment.yml
```

2.2.2 Activate the conda environment:

```
conda activate ia4
```

2.2.3 Run the analysis:

```
bash runall.sh
```

</details>

<details>
<summary><b>Option 3: Use `docker-compose.yml`</b></summary>

2.3.1. Pull and launch the docker container, this will direct you to the terminal of the container, no GUI

```bash
docker compose run --rm ia4
```

2.3.3 You will land directly in the terminal of the container. Run the analysis:

```
bash runall.sh
```

2.3.4 After you are done, type `exit` to leave docker container.

</details>

---

## Exercise:

Your task is to add a "smarter" data analysis pipeline using GNU Make!
It should accomplish the same task as `bash runall.sh` when you type
`make all`.

It should reset the analysis the starting point 
(the state when you first copied this repo)
when you type `make clean`.

---

### Depenedencies
- GNU Make
- Quarto
- Python & Python libraries:
    - `click`
    - `matplotlib`
    - `pandas`
