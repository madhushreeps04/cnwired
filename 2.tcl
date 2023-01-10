set ns [new Simulator]

set tf [open 2.tr w]
$ns trace-all $tf

set nf [open 2.nam w]
$ns namtrace-all $nf

set cwind [open win2.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns queue-limit $n0 $n2 10
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n3 $n5 2Mb 2ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

#telnet

set tel [new Agent/TCP]
$ns attach-agent $n1 $tel

set telsink [new Agent/TCPSink]
$ns attach-agent $n4 $telsink

$ns connect $tel $telsink

set telp [new Application/Telnet]
$telp attach-agent $tel

$ns at 0.5 "$ftp start"
$ns at 0.7 "$telp start"

$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now + $time] "plotWindow $tcpSource $file" }
$ns at 2.0 "plotWindow $tcp $cwind"
$ns at 5.5 "plotWindow $tel $cwind"

proc finish {} {
       global ns tf nf cwind
       $ns flush-trace
       close $tf
       close $nf
       
       puts "running nam..."
       puts "FTP PACKETS.."
       puts "Telnet PACKETS.."
       exec nam 2.nam &
       exec xgraph win2.tr &
       exit 0
}
$ns run
