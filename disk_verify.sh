
EXPECTED_DISKS=(vdb vdc vdd vde)
WAIT_TIME=600     # total seconds to wait for disks to appear(10 minutes)
INTERVAL=5        # check every 5 seconds
elapsed=0

echo "=== Waiting for all expected disks to attach (${EXPECTED_DISKS[*]}) ==="

while true; do
  attached_disks=()
  for disk in "${EXPECTED_DISKS[@]}"; do
    if lsblk -dn -o NAME | grep -qw "$disk"; then
      attached_disks+=("$disk")
    fi
  done

  if (( ${#attached_disks[@]} == ${#EXPECTED_DISKS[@]} )); then
    echo "All expected disks detected: ${attached_disks[*]}"
    break
  fi

  if (( elapsed >= WAIT_TIME )); then
    echo "Only detected (${attached_disks[*]:-none}) after ${WAIT_TIME}s. Exiting."
    exit 1
  fi

  echo "Waiting for disks... found (${attached_disks[*]:-none}), elapsed: ${elapsed}s"
  sleep $INTERVAL
  ((elapsed+=INTERVAL))
done
