# Source this to hold the lab's simulator/build lock for the rest of the
# calling script (one lab run at a time across agents). A lock older than 40
# minutes is taken as stale.
LOCK=$LAB/lock
while ! mkdir $LOCK 2>/dev/null; do
  if [[ -n $(find $LOCK -maxdepth 0 -mmin +40 2>/dev/null) ]]; then rmdir $LOCK 2>/dev/null; fi
  sleep 5
done
trap 'rmdir $LOCK 2>/dev/null' EXIT
