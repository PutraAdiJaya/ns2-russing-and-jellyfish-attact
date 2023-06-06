
set val(chan)           Channel/WirelessChannel;
set val(prop)           Propagation/TwoRayGround;
set val(netif)          Phy/WirelessPhy;
set val(mac)            Mac/802_11;
set val(ifq)            Queue/DropTail/PriQueue;
set val(ll)             LL;
set val(ant)            Antenna/OmniAntenna;
set val(ifqlen)         50;
set val(nn)             2;
set val(rp)             AODV;
set val(x)		500
set val(y)		500

set ns		[new Simulator]

set tracefd     [open wireless-udp.tr w]
$ns trace-all   $tracefd
set namtracefd    [open wireless-udp.nam w]
$ns namtrace-all-wireless $namtracefd $val(x) $val(y)

set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

$ns node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace OFF \
		-channel [new $val(chan)]

set node_(0) [$ns node]
set node_(1) [$ns node]

$node_(0) random-motion 0
$node_(1) random-motion 0

$node_(0) set X_ 10.0
$node_(0) set Y_ 10.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 30.0
$node_(1) set Y_ 30.0
$node_(1) set Z_ 0.0

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns initial_node_pos $node_($i) 20 
}

set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $node_(0) $udp
$ns attach-agent $node_(1) $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$ns at 0.1 "$node_(1) setdest 350.0 350.0 400.0"
$ns at 0.4 "$cbr start" 
$ns at 1.0 "$node_(0) setdest 330.0 330.0 400.0"
$ns at 3.01 "stop"
$ns at 3.02 "puts \"NS EXITING...\" ; $ns halt"

proc stop {} {
    global ns tracefd namtracefd
    $ns flush-trace
    close $tracefd
    close $namtracefd
    puts "running nam..."
    exec nam wireless-udp.nam &
    exec gawk -f pdr.awk wireless-udp.tr &
    exit 0
}

$ns run



