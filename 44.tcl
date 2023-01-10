

set ns [new Simulator]

set tf [open p4.tr w]
$ns trace-all $tf

set nf [open p4.nam w]
$ns namtrace-all $nf

$ns color 1 Blue

$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]

$n0 label "Server"
$n1 label "Client"

$ns duplex-link $n0 $n1 10Mb 22ms DropTail

$ns duplex-link-op $n0 $n1 orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0
$tcp0 set fid_ 1
$tcp0 set packetSize_ 1500

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns at 0.1 "$ftp0 start"
$ns at 10.0 "finish"

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam p4.nam &
	exec awk -f p4.awk p4.tr &
	exec awk -f 2p4.awk p4.tr > graph4.tr &
	exec xgraph graph4.tr &
	exit 0
	}

$ns run

//AWK SCRIPT

BEGIN{
	total_bytes_received=0;
	total_bytes_sent=0;
}
{
	if($1=="r" && $4==1 && $5=="tcp")
		total_bytes_received+=$6;
	if($1=="+" && $3==0 && $5=="tcp")
		total_bytes_sent+=$6;
}
END{
	system("clear");
	printf("\nTransmission time required to transfer the file is %f",$2);
	printf("\nActual data sent from the server is %f Mbps",(total_bytes_sent)/1000000);
	printf("\nData received by the client is %f Mbps\n",(total_bytes_received)/1000000);
}

//OUTPUT

Transmission time required to transfer the file is 9.999440
Actual data sent from the server is 6.637440 Mbps
Data received by the client is 6.620500 Mbps


//AWK SCRIPT

BEGIN{
	count=0;
	time=0;
}
{
	if($1=="r" && $4==1 && $5=="tcp")
	{
		count+=$6;
		time=$2;
		printf("\n%f\t%f",time,(count)/1000000);
	}
}
END{
	printf("\n");
}


