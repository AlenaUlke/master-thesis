#!/usr/local_rwth/bin/zsh

#SBATCH --job-name=flux_eco

### SBATCH --nodes = 1
### SBATCH --ntasks = 1
### SBATCH --cpus-per-task = 1

### Request the memory you need for your job. You can specify this
### in either MB (1024M) or GB (4G).
#SBATCH --mem-per-cpu=4G

### File / path which STDOUT will be written to, %J is the job ID
#SBATCH --output=fe_%j.out
#SBATCH --error=fe_%j.err

### Request the time you need for execution. The full format is D-HH:MM:SS
### You must at least specify minutes or days and hours and may add or
### leave out any other parameters
#SBATCH --time=5:00:00

#SBATCH --partition=c18m

### Change to the work directory, if not in submit directory
### cd $HOME/masterarbeit/cluster/internal

### Remove all currently loaded modules
### module purge

### Load the required modules
module load MISC
module load matlab

### start non-interactive batch job
matlab -singleCompThread -nodisplay -nodesktop -nosplash -logfile log-${SLURM_JOB_ID}.txt <<EOF
run $HOME/masterarbeit/cluster/ExperimentFluxEco.m;
quit();
EOF
