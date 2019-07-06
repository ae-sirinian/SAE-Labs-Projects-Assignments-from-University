#Create an instance of the Simulator class.
set ns [new Simulator]
########################################################################

#Add four nodes n0, n1, n2 and n3. <Filled>
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
########################################################################

#Export nam traces
set nf [open lab1_3.nam w]
$ns namtrace-all $nf
########################################################################

#Create 3 (duplex) links (n0-n1, n1-n2, n2-n3) <Filled>
#with 1Mb bandwidth and 10ms delay per link, including a DropTail queue 
$ns duplex-link $n0 $n1 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 3Mb 5ms DropTail
########################################################################

#Define a link orientation
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right
########################################################################
 
#Create a TCP connection (tcp0) from node 1 to node 0 <Filled>
set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
########################################################################

#Create a Telnet traffic source (telnet0) and attach it to tcp0 <Filled>
set telnet0 [new Application/Telnet]
$telnet0 attach-agent $tcp0
########################################################################

#Create a Null TCP agent (null0), acting as a traffic sink. Null TCP Agents are of the form Agent/TCPSink. <Filled>
set null0 [new Agent/TCPSink]
$ns attach-agent $n0 $null0
########################################################################

#Connect tcp0 and null0 agents <Filled>
$ns connect $tcp0 $null0
########################################################################

#Create a TCP connection (tcp1) from node 2 to node 3 <Filled>
set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
########################################################################

#Create a FTP traffic source (ftp0) and attach it to tcp1 <Filled>
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp1
########################################################################

#Create a Null TCP agent (null1), acting as a traffic sink <Filled>
set null1 [new Agent/TCPSink]
$ns attach-agent $n3 $null1
########################################################################

#Connect tcp1 and null1 agents <Filled>
$ns connect $tcp1 $null1
########################################################################

#Create a UDP connection from node 1 to node 2 <Filled>
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
########################################################################

#Create a CBR traffic source (cbr0) and attach it to udp0
#Set packetSize = 48 bytes (stored in ps variable)
#Set interval time = 0.01 secs (stored in int variable) <Filled>
set cbr0 [new Application/Traffic/CBR]
set ps 300
set int 0.05
$cbr0 set packetSize_ $ps
$cbr0 set interval_ $int
$cbr0 attach-agent $udp0
########################################################################

#Create a Null agent (null2), acting as traffic sink <Filled>
set null2 [new Agent/TCPSink]
$ns attach-agent $n2 $null2
########################################################################

#Connect udp0 and null2 agents <Filled>
$ns connect $udp0 $null2
########################################################################

#Create a UDP connection from node 2 to node 1 <Filled>
set udp1 [new Agent/UDP]
$ns attach-agent $n2 $udp1
########################################################################

#Create a CBR traffic source (cbr1) and attach it to udp1
#Set packetSize = 48 bytes
#Set interval time = 0.01 <Filled>
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ $ps
$cbr1 set interval_ $int
$cbr1 attach-agent $udp1
########################################################################

#Create a Null agent (null3), acting as a traffic sink <Filled>
set null3 [new Agent/TCPSink]
$ns attach-agent $n1 $null3
########################################################################

#Connect udp1 and null3 agents <Filled>
$ns connect $udp1 $null3
########################################################################

#Schedule event ftp0 to start at 0.5 secs and to stop at 3.0 secs <Filled>
$ns at 0.5 "$ftp0 start"
$ns at 3.0 "$ftp0 stop"
########################################################################

#Schedule event telnet0 to start at 0.5 secs and to stop at 3.0 secs <Filled>
$ns at 0.5 "$telnet0 start"
$ns at 3.0 "$telnet0 stop"
########################################################################

#Schedule event cbr0 to start at 3.0 secs and to stop at 4.5 secs <Filled>
$ns at 3.0 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
########################################################################

#Schedule event cbr1 to start at 3.5 secs and to stop at 5.0 secs <Filled>
$ns at 3.5 "$cbr1 start"
$ns at 5.0 "$cbr1 stop"
########################################################################

#Call procedure "finish" at 5.0 secs <Filled>
$ns at 5.0 "finish"
########################################################################

#Calculate the packet per second rate of cbr0 traffic <Filled>
puts "cbr0 produces [expr (1 / $int)] packets per second"
########################################################################

#Calculate the bytes per second rate of cbr0 traffic <Filled>
puts "cbr0 produces [expr (1 / $int) * $ps] bytes per second"
########################################################################

#Add a procedure, called "finish"
#Execute nam and exit
proc finish {} {
	puts "running nam..."
	global ns nf
	$ns flush-trace
	close $nf
	exec /usr/local/bin/nam lab1_3.nam &
	exit 0
	}
########################################################################

#Set blue color for class 1 (TCP connections) and red color for class 2 (UDP connections) <Filled>
$ns color 1 Blue
$tcp0 set class_ 1
$tcp1 set class_ 1
$ns color 2 Red
$udp0 set class_ 2
$udp1 set class_ 2
########################################################################

#Start the simulator <Filled>
$ns run
########################################################################
