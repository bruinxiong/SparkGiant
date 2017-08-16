#!/bin/bash
#SBATCH -p regular
#SBATCH -N 8
#SBATCH -C haswell
#SBATCH -t 00:10:00
#SBATCH -J giant_quadratic
#SBATCH -L SCRATCH
#SBATCH -e giant_job_%j.err
#SBATCH -o giant_job_%j.out

PROJ_HOME="$SCRATCH/SparkGiant"
JAR_FILE="$PROJ_HOME/target/scala-2.11/giant_2.11-1.0.jar"
DATA_TRAIN_FILE="$PROJ_HOME/data/YearPredictionMSD"
DATA_TEST_FILE="$PROJ_HOME/data/YearPredictionMSD.t"

NUM_SPLITS="63"
NUM_FEATURES="100"

module load spark
ulimit -s unlimited
start-all.sh

spark-submit \
    --class "distopt.quadratic.ExperimentRfm" \
    --num-executors $NUM_SPLITS \
    $JAR_FILE $DATA_TRAIN_FILE $DATA_TEST_FILE $NUM_SPLITS $NUM_FEATURES
  
stop-all.sh
