use Term::ReadKey;
use Time::HiRes ("sleep");      # allow fractional sleeps
open (my $dsp,"|padsp tee /dev/audio > /dev/null") or   die qq(Couldn't execute for piping);
my $notes={};
$notes->{$a}=pack'C*',map 127*(1+sin($_*2**($a%20/24))),0..1000 for my $a (0..32);

for $a(0..32){playNote($a)}

ReadMode 'cbreak';
run ();

sub run{
	my $refreshRate=20;
    while(1){
	sleep 1/$refreshRate;
        my $key = ReadKey(-1); 
        next unless $key;
        ord($key);
        playNote( ord($key)%32);
        playNote( ord($key)%32);
        last if ( ord($key)==27);
	}
  ReadMode 'normal';  
  print "Finished\n";

}

sub playNote{
	my $a=shift;
	syswrite  $dsp,$notes->{$a};
				
}
