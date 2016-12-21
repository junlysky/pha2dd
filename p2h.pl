#!/use/bin/env perl
use strict;
use warnings;
use Time::Local;
use POSIX qw/strftime/;
use File::Basename qw/basename dirname/;
use List::Util qw/max min/;
use Date::Calc qw/Add_Delta_Days/;


open(IN, "< infile.txt");
our @lines = <IN>;
chomp(@lines);
close(IN);

open(OUT,"> outphase.txt") or die "Can not build file outfile";

our $i=0;
our $num=1;
our ($dbo,$deo,$dmb,$dpb);
$dbo = "DBO";
$deo = "DEO";
$dmb = "DMB";
$dpb = "DPB";
our ($year,$mon,$mday,$hour,$min,$sec,$msec,$lat,$lon,$dep,$mag,$x1,$x2,$x3);
our ($year2,$mon2,$mday2,$sec2,$min2,$hour2);
our ($net,$stanm,$stach,$psg,$y1,$y2,$time2,@y3,$nm);
our ($magtype);
our @line;
our @te;
our $templine;
our ($tp1,$tp2,$tp);
our $testchars;

while($i<@lines){
	
	@line = split /\s+/,$lines[$i];
        $templine = $lines[$i]; 
	   $testchars = substr($lines[$i],0,3);        # test if the first 3 chars
           $testchars = $line[0];

	if  ($testchars eq "$dbo"){

                   $net = substr($templine,4,2);
		   $year = substr($line[2],0,4);
		   $year = sprintf("%04d", $year);		   
                   $mon  = substr($line[2],5,2)-1;	
		   $mon  = sprintf("%02d", $mon);
			
                   $mday = substr($line[2],8,2);
		   $mday = sprintf("%02d", $mday);
                  
		   $hour = substr($line[3],0,2);	   
		   $hour = sprintf("%02d", $hour); 
		   $min  = substr($line[3],3,2);
		   $min  = sprintf("%02d", $min); 
                   $sec  = substr($line[3],6,2);
		   $sec = sprintf("%02d", $sec); 
		   $msec = substr($line[3],9,2);		   
                   $sec = "$sec"."."."$msec";
		   $sec = sprintf("%5.2f",$sec);
		   
                   $tp1 = timelocal("$sec","$min", "$hour", "$mday", "$mon","$year");

              	   $lat  = sprintf("%9.5f", $line[4] );
       		   $lon  = sprintf("%10.5f", $line[5] );
        	   $dep  = sprintf("%5.1f", $line[6] );
        	   $mag  = sprintf("%4.1f", $line[8] );
         	   $x1   = sprintf("%4.1f", 0 );
        	   $x2   = sprintf("%4.1f", 0 );
        	   $x3   = sprintf("%4.1f", 0 );
           print "# $year $mon $mday $hour $min $sec  $lat  $lon  $dep  $mag  $x1 $x2 $x3    $num\n";  
                
     	   print OUT "# $year $mon $mday $hour $min $sec  $lat  $lon  $dep  $mag  $x1 $x2 $x3    $num\n";
      
       		$num++;
        	$i++;
	}
        elsif ($testchars eq "$deo")
            {
                @te = $line[2];
                $i++;
            }
        elsif ($testchars eq "$dmb")
            {
                $mag = $line[2];
                $magtype = $line[1];
                $i++;
            }
        elsif ($testchars eq "$dpb")
            {
          	$net = substr($templine,4,2);
               # $net = $line[1];
                $stanm = substr($templine,7,5);
		$stach = substr($templine,13,3);
		$psg = substr($templine,25,3);
                $year2 = substr($templine,34,4);
                $mon2 = substr($templine,39,2)-1;
                $mday2 = substr($templine,42,2);
		$hour2 = substr($templine,45,2);
		$min2 = substr($templine,48,2);
		$sec2 = substr($templine,51,5);
                $tp2=timelocal("$sec2","$min2", "$hour2", "$mday2", "$mon2","$year2");
              
                $tp = $tp2 - $tp1;

         	 if( $psg eq " Pg" || $psg eq " Sg" || $psg eq " Pn" || $psg eq " Sn"){	
         		print "$stanm $tp 1 $psg\n";
                        print "$hour2:$min2:$sec2\n";
     	        	printf OUT "%-5s %6.2f %d %3s\n",$stanm,$tp,1,$psg;
               	   }
	        $i++;
            }    
       else 
            { 
                 $i++;
            } 

}
close(OUT);
