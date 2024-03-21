module use /projects/wind/modules
module load linux-rhel7-skylake_avx512/exawind-master/2024-02-21/2ori
which naluX

umask 007
function ranks_per_node(){
  threads=$(lscpu | grep -m 1 "CPU(s):" | awk '{print $2}')
  tpcore=$(lscpu | grep -m 1 "Thread(s) per core:" | awk '{print $4}')
  echo $(($threads/$tpcore))
}
