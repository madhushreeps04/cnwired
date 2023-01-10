set ns [new Simulator]

set tf [open 4.tr w]
$ns trace-all $tf

set nf [open 4.nam w]
$ns namtrace-all $nf

set s [$ns node]
set c [$ns node] 

$ns color 1 blue 

$s label "server"
$c label "client"

$ns duplex-link $s $c 10Mb 22ms DropTail
$ns duplex-link-op $s $c orient right

set tcp [new Agent/TCP]
$ns attach-agent $s $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $c $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc finish {} {
global ns tf nf
$ns flush-trace
close $nf
close $tf
exec nam 4.nam &
exec awk -f pp4.awk 4.tr &
exec awk -f pp4convert.awk 4.tr >convert.tr &
exec xgraph convert.tr &
}
$ns at 0.1 "$ftp start"
$ns at 10.0 "finish"
$ns run

