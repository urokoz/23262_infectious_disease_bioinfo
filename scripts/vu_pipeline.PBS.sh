### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N matbor_vu_pipeline
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e vu_pipeline.err
#PBS -o vu_pipeline.log
### Number of nodes
#PBS -l nodes=1:ppn=20
### Memory
#PBS -l mem=50gb
#PBS -l walltime=1:00:00

# load modules
module load tools
module load anaconda3/2019.10
module load phylip/3.697
module load iqtree/1.6.12

# load programs into path
export PATH="${PATH}:/services/tools/kma/1.3.15/kma" 
export PATH="${PATH}:/home/projects/course_23262/course/week06/evergreen/pathogen_surveillance"

# shell variables for the pipeline
INPUT_DIR="/home/projects/course_23262/course/week06/evergreen/input"
ANALYSIS_DIR="/home/projects/course_23262/people/matbor/surveillance" 
DATABASE="${ANALYSIS_DIR}/surveillance.db"
OUTPUT="${ANALYSIS_DIR}/surveillance"
KMA_DB="/home/projects/course_23262/course/week06/evergreen/reference/refseq_bacterial_complete_chromosomes_2021_k13_hr99.0_ATG"
SIMILARITY="99.0"
THREADS="20"

# the command for running the pipeline
vu_pipeline.py -b ${ANALYSIS_DIR} -f ${INPUT_DIR}/input1.iso -g ${INPUT_DIR}/ecoli_131.tsv -d ${DATABASE} -r ${KMA_DB} -t ${SIMILARITY} -o ${OUTPUT} -ml -pairwise -p ${THREADS} -ebi