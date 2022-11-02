use strict; use warnings;
use Term::ReadKey;
use Time::HiRes ("sleep");      # allow fractional sleeps

print "perl piano...sort of... please wait... intialising...\n";
open (my $dsp,"|padsp tee /dev/audio > /dev/null") or   die qq(Couldn't execute for piping);
my @octaves=("A","A#","B","C","C#","D","D#","E","F","F#","G","G#") x 8; # create 96 key piano
my @keys= map{$octaves[$_].(int (($_+10)/12)) }(0..$#octaves);          # append the octave number
my $sps=900;                    #sample size
my $notes={};                   # hashref to store the notes with keys
for my $k(1..@keys){
	my $f=440*2**(($k-49)/12);              # generate frequency table
	my $s=pack'C*',map 65*(1+sin($_*2*3.1415*($f/$sps))),0..$sps-1; # generate the sample
	$notes->{$keys[$k-1]}={f=>$f,s=>$s};    # store in hash
	playNote($k-1);
}

sleep 10;

print "Start pressing keys... Escape to exit;";

my $refreshRate=50;    # read 50 times a second
ReadMode 'cbreak';
while(1){
	sleep 1/$refreshRate;
        my $key = ReadKey(-1) or next;; 
        last if ( ord($key)==27);   # escape key exits
        playNote( ord($key)%96);    # sort fo 
        playNote( ord($key)%96);
}

ReadMode 'normal'&& print "Finished\n" && close $dsp;

sub playNote{
	my $a=shift;
	$b=$notes->{$keys[$a]}->{s};
	while (length $b)	{$b=substr $b,syswrite $dsp,$b};
	}
