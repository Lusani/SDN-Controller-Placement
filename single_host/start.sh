#!/bin/sh

### this script will start phoenix inside tmux windows
## Usage: ./start.sh [nf]
##		if [nf] is present a phoenix will be launched with $nf.xml config and nf.sh envoriment.
##		if [nf] is not present we will start <hss, dpsw, mme, bt>


CWD=$(pwd)

if [ -f /.dockerenv ]; then
	## inside docker
	## binary installation
	PHOENIX_DIR=$CWD
	PHOENIX=./phoenix.sh
else
	## binary installation
	PHOENIX_DIR=/opt/phoenix/dist
	PHOENIX=./phoenix.sh
	## source instalaltion
	#PHOENIX_DIR=/opt/phoenix/build/
	#PHOENIX=./bin/phoenix
fi


run_nf(){
	nf=$1
	echo tmux new-window -d -n $nf \"". ./env.sh; . ./${nf}.sh; cd $PHOENIX_DIR; ${PHOENIX} -f ${CWD}/${nf}.xml; sleep 5"\"
	tmux new-window -d -n $nf ". ./env.sh; . ./${nf}.sh; cd $PHOENIX_DIR; ${PHOENIX} -f ${CWD}/${nf}.xml; cd $CWD; $SH"
}

if [ ! -z "$TMUX" ]
then
	if [ -z $1 ]; then
		for nf in hss dpsw mme bt
		do
			run_nf $nf
		done
	else
		run_nf $1
	fi
	#for nf in dpsw
	#do
	#	tmux new-window -n $nf ". ./env.sh; . ./${nf}.sh; cd $PHOENIX_DIR; sudo -E ${PHOENIX} -f ${CWD}/${nf}.xml; bash"
	#done
else
	echo "starting tmux session in the background, run 'tmux a' to attach"
	tmux new-session -n phoenix -d $0
fi

