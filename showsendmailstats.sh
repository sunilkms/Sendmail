#!/bin/bash
# Author - sunil Chauhan <sunilkms@gmail.com>
#---------------------------------------------------------------------------------------------
D=$1                       # define date
LOGS=$2                    # define log type "HOUR", "MIN", "TOPIP" 
MAILSEND=$3                # invoke email send function "send", "mailsend" , "messagesend"  
EMAILADD=$4                # email address to send email
DefalutEmailAdd="sunil.chauhan@lab365.in" #set default email address
LOGPATH="/var/log/mail.log" # set Log path
#----------------------------------------------------------------------------------------------
SendMail=$FALSE
SERVER=$(hostname)
if [ $(echo $MAILSEND | grep "send") ]
    then
                if [ $(echo $EMAILADD | grep "@") ];then
                        echo "Correct email address was provided, script will continue.."
                else
                        EMAILADD=$DefalutEmailAdd
                        echo "No email address was suplied in the script parameter"
			echo "Report will be sent to default email address set in the script configuration"
                fi
                        echo "Output of this report will be emailed to: $EMAILADD"
                if [ $LOGS = "MIN" ]
                then
                        echo "Subject:[$D]Mailrelay statistics for server:$SERVER" > mail.txt
                        echo "Fetching Logs starting date:$D - for $LOGS"
                        for i in `seq 0 9`;
                        do 
			#echo "$D:0$i=$(grep "$D:0$i" $LOGPATH | grep "from=" -c)";
                        NUM=$(grep "$D:0$i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D:0$i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D:0$i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D:0$i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D:0$i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D:0$i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";						
			SendMail=$TRUE
                        done >> mail.txt

                        for i in `seq 10 59`;
                        do 
			#echo "$D:$i=$(grep "$D:$i" $LOGPATH | grep "from=" -c)";
                        NUM=$(grep "$D:$i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D:$i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D:$i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D:$i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D:$i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D:$i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";						
			SendMail=$TRUE
                        done >> mail.txt
                elif [ $LOGS = "HOUR" ]
                then
                        echo "Logs will be serach for each hour"
                        echo "Subject:[$D]Mailrelay statistics for server:$SERVER" > mail.txt
                        for i in `seq 0 9`;
                        do 
			#echo "$D 0$i=$(grep "$D 0$i" $LOGPATH | grep "from=" -c)";
                        NUM=$(grep "$D 0$i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D 0$i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D 0$i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D 0$i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D 0$i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D 0$i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";
			done >> mail.txt

                        for i in `seq 10 23`;
                        do 
			#echo "$D $i=$(grep "$D $i" $LOGPATH | grep "from=" -c)";
                        STATS=$(grep "$D $i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D $i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D $i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D $i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D $i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";						
			SendMail=$TRUE
                        done >> mail.txt
                fi

                if [ $SendMail = $TRUE ]
                then
                        echo "Sending Email.."
                        sendmail $EMAILADD <  mail.txt
                        echo "done"
                else
                        echo "done"
                fi
else
                if [ $LOGS = "MIN" ]
                then
                        #echo "Fetching Logs starting date:$D - for $LOGS"
                        echo "Fetching email statistics for $SERVER, number of mails processed each min in given hour ($D) will be displayed below."
                        for i in `seq 0 9`;
                        do
                        NUM=$(grep "$D:0$i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D:0$i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D:0$i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D:0$i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D:0$i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D:0$i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";
                        done
                        
                        for i in `seq 10 59`;
                        do
                        NUM=$(grep "$D:$i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D:$i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D:$i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D:$i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D:$i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D:$i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";
                        done
                elif [ $LOGS = "HOUR" ]
                then
                        echo "Fetching email statistics for $SERVER number of mails processed each hour on given day($D) will be displayed below."
                        for i in `seq 0 9`;
                        do
                        NUM=$(grep "$D 0$i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D 0$i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D 0$i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D 0$i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D 0$i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D 0$i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";
                        done

                        for i in `seq 10 23`;
                        do
                        NUM=$(grep "$D $i" $LOGPATH | grep "from=" -c)
                        if [ $NUM -eq 0 ];then break;fi
                        STATS=$(grep "$D $i" $LOGPATH | grep "stat=S" -c)
                        STATD=$(grep "$D $i" $LOGPATH | grep "stat=D" -c)
                        STATU=$(grep "$D $i" $LOGPATH | grep "stat=U" -c)
                        RJCT=$(grep "$D $i" $LOGPATH | grep "rejecting connections" -c)
                        echo "$D $i From=$NUM Sent=$STATS Deferred=$STATD User unknown=$STATU RJCTCON=$RJCT";
                        done
                elif [ $LOGS = "TOPIP" ]
                then
                        echo "Top 10 IP will be displayed for given time ($D)"
                        #grep "$D" $LOGPATH | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort | uniq -c |sort -nr -k 1 | head -10;
			grep "$D" $LOGPATH | grep "from=" | sed 's/.*relay=//' | sort | uniq -c |sort -nr -k 1 | head -10
		fi
fi
