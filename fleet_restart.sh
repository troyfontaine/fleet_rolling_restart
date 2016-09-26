#!/bin/bash
# Script to use Fleetctl to stop and start containers using a rolling restart
# By Troy Fontaine with rolling restart script from http://engineering.rainchasers.com/coreos/fleet/2015/03/03/rolling-unit-restart.html

# Grab list of services from fleet
container_array=($(fleetctl list-units -fields=unit -no-legend | cut -f2 ))

# Declare variables
container=""
clean_container=()

# Filter results
for entry in "${container_array[@]}"
do
        # Discard any possible blank array entries
        if [ ${#entry} -le 10 ]; then

                # Skip to next entry
                shift
	# Remove trailing characters
	# Check for entries that have @ symbol
        elif [[ $entry == *"@"* ]]; then

                # Lob off the last 10 characters
                # This removes the @#.service from the name
                clean_container+=("${entry%??????????}")
        else
		# Lob off last 8 characters
		# This removes the .service from the name
                clean_container+=${entry%????????}
        fi


done

# Filter duplicates from array
container_list=($(printf "%s\n" "${clean_container[@]}" | sort -u)); echo "${uniq[@]}"

restart ()
{
		
	fleetctl list-units | grep $1@ | cut -f1 -d. | while read -r unit ; do
	unit_index=`echo $unit | cut -f2 -d@`

	printf "unit:> %s index:> %s\n" $unit $unit_index

	printf "stopping:> %s\n" $unit
	fleetctl stop $unit

	printf "waiting:> for %s to stop " $unit;
	is_running=1
	while [ $is_running -ne 0 ]; do
		is_running=`fleetctl list-units | grep running | grep $unit | wc -l`;
		sleep 1;
		printf ".";
	done
	printf "\n"

	printf "starting:> %s\n" $unit
	fleetctl start $unit

	printf "waiting:> for %s to start " $unit;
	while [ $is_running -eq 0 ]; do
		is_running=`fleetctl list-units | grep running | grep $unit | wc -l`;
		sleep 1;
		printf ".";
	done
	printf "\n"

	fleetctl list-units | grep $unit
	done

}

usage () 
{
        echo "script to restart all commonly updated services"
        echo
        echo "To recreate all containers:"
        echo "$0 all"
        echo
        echo "To start one container"
        echo "$0 <containername> (e.g. $0 web_service)"
        echo
        echo "To recreate one or a few containers pass them as a space seperated list:"
        echo "$0 web_service proxy_service db_service"
        echo
}

if [ "$#" == 0 ]; then
        usage
fi

if [ "$#" -ge 1 ]; then

	if [ "$1" == "all" ]; then
		
		echo "Restarting all units individually by service"
		for unit_name in "${container_list[@]}"
		do
			
			restart "$unit_name"
			
		done
		echo "Completed restart attempts of all services"
		exit 0
	else
		
		for unit_name in "$@"
		do
			echo "Ad-hoc restart of $unit_name"
			restart $unit_name
		done
		echo "Completed restart of $@"
   		exit 0
	fi
fi 
