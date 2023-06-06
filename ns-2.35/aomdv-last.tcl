### Setting The Simulator Objects
set val(chan)           Channel/WirelessChannel    ;# Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy/802_15_4    ;# network interface type
set val(mac)            Mac/802_15_4                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             20                         ;# number of mobilenodes
set val(rp)             AOMDV                       ;# routing protocol
set val(nnaodv)         20 
set val(x)              2000
set val(y)              2000

                  
set ns_ [new Simulator]
#create the nam and trace file:
set tracefd [open aomdv.tr w]
$ns_ trace-all $tracefd
set namtrace [open aomdv.nam w]
$ns_ namtrace-all-wireless $namtrace  $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)
set chan_1_ [new $val(chan)]
      

#  Defining Node Configuration
                        
$ns_ node-config   -adhocRouting $val(rp) \
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
                   -movementTrace ON \
                   -channel $chan_1_

# Energy model
      
$ns_ node-config        -energyModel EnergyModel \
                        -initialEnergy 100 \
                        -txPower 0.9 \
                        -rxPower 0.8 \
                        -idlePower 0.0 \
                        -sensePower 0.0175 


     
# create nodes 
for {set i 0} {$i < $val(nn)} {incr i} {
	 set node_($i) [$ns_ node]	
   $node_($i) random-motion 0;
}
      


###  Setting The Initial Positions of Nodes

$node_(0) set X_ 562.0		
$node_(0) set Y_ 1096.0
$node_(0) set Z_ 0.0
 
$node_(1) set X_ 577.0
$node_(1) set Y_ 109.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 284.0
$node_(2) set Y_ 161.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 272.0
$node_(3) set Y_ 1700.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 104.0
$node_(4) set Y_ 1227.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 65.0
$node_(5) set Y_ 118.0
$node_(5) set Z_ 0.0

$node_(6) set X_ 425.0
$node_(6) set Y_ 1815.0
$node_(6) set Z_ 0.0

$node_(7) set X_ 60.0
$node_(7) set Y_ 347.0
$node_(7) set Z_ 0.0

$node_(8) set X_ 535.0
$node_(8) set Y_ 1491.0
$node_(8) set Z_ 0.0

$node_(9) set X_ 941.0
$node_(9) set Y_ 227.0
$node_(9) set Z_ 0.0

$node_(10) set X_ 98.0
$node_(10) set Y_ 589.0
$node_(10) set Z_ 0.0

$node_(11) set X_ 747.0
$node_(11) set Y_ 190.0
$node_(11) set Z_ 0.0

$node_(12) set X_ 1131.0
$node_(12) set Y_ 1971.0
$node_(12) set Z_ 0.0

$node_(13) set X_ 558.0
$node_(13) set Y_ 425.0
$node_(13) set Z_ 0.0

$node_(14) set X_ 780.0
$node_(14) set Y_ 1814.0
$node_(14) set Z_ 0.0

$node_(15) set X_ 302.0
$node_(15) set Y_ 402.0
$node_(15) set Z_ 0.0

$node_(16) set X_ 1286.0
$node_(16) set Y_ 2000.0
$node_(16) set Z_ 0.0

$node_(17) set X_ 1489.0
$node_(17) set Y_ 1705.0
$node_(17) set Z_ 0.0

$node_(18) set X_ 1286.0
$node_(18) set Y_ 352.0
$node_(18) set Z_ 0.0

$node_(19) set X_ 451.0
$node_(19) set Y_ 997.0
$node_(19) set Z_ 0.0



## Setting The Node Size
                              
      $ns_ initial_node_pos $node_(0) 40
      $ns_ initial_node_pos $node_(1) 40
      $ns_ initial_node_pos $node_(2) 40
      $ns_ initial_node_pos $node_(3) 40
      $ns_ initial_node_pos $node_(4) 40
      $ns_ initial_node_pos $node_(5) 40
      $ns_ initial_node_pos $node_(6) 40
      $ns_ initial_node_pos $node_(7) 40
      $ns_ initial_node_pos $node_(8) 40
      $ns_ initial_node_pos $node_(9) 40
      $ns_ initial_node_pos $node_(10) 40
      $ns_ initial_node_pos $node_(11) 40
      $ns_ initial_node_pos $node_(12) 40
      $ns_ initial_node_pos $node_(13) 40
      $ns_ initial_node_pos $node_(14) 40
      $ns_ initial_node_pos $node_(15) 40
      $ns_ initial_node_pos $node_(16) 40
      $ns_ initial_node_pos $node_(17) 40
      $ns_ initial_node_pos $node_(18) 40
      $ns_ initial_node_pos $node_(19) 40


#jellyfish attackers
$ns at 0.0 "[$n5 set ragent_] jellyfish1"

# $ns at 0.0 "[$n7 set ragent_] jellyfishattack1"
 


     
     

#Set a TCP connection between node 0 and node 19

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(19) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns_ at 1.0 "$ftp start"

#Set a TCP connection between node 9 and node 28

set tcp1 [new Agent/TCP]
$tcp set class_ 2
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(9) $tcp1
$ns_ attach-agent $node_(18) $sink1
$ns_ connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 2.0 "$ftp1 start"

#set a tcp connection between node 18 and node 37
set tcp2 [new Agent/TCP]
$tcp set class_ 2
set sink2 [new Agent/TCPSink]
$ns_ attach-agent $node_(18) $tcp2
$ns_ attach-agent $node_(17) $sink2
$ns_ connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns_ at 3.0 "$ftp2 start"

#set a tcp connection between node 30 and node 25
set tcp3 [new Agent/TCP/Fack]
$tcp set class_
set sink3 [new Agent/TCPSink]
$ns_ attach-agent $node_(10) $tcp3
$ns_ attach-agent $node_(15) $sink3
$ns_ connect $tcp3 $sink3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ns_ at 3.0 "$ftp3 start"

#set a tcp connection between node 39 and node 15
set tcp4 [new Agent/TCP/Fack]
$tcp set class_ 2
set sink4 [new Agent/TCPSink]
$ns_ attach-agent $node_(11) $tcp4
$ns_ attach-agent $node_(12) $sink4
$ns_ connect $tcp4 $sink4
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ns_ at 5.0 "$ftp4 start"

#set a tcp connection between node 22 and node 36
set tcp5 [new Agent/TCP/Fack]
$tcp set class_ 2
set sink5 [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp5
$ns_ attach-agent $node_(16) $sink5
$ns_ connect $tcp5 $sink5
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp5
$ns_ at 4.0 "$ftp5 start"



      

      proc stop {} {
            
                        global ns_ tracefd
                        $ns_ flush-trace
                        close $tracefd
                        exec nam datacache.nam &            
                        exit 0

                   }

      puts "Starting Simulation........"
      $ns_ at 50.0 "stop"
      $ns_ run
