use strict; use warnings;
use Term::ReadKey;
use Time::HiRes ("sleep");      # allow fractional sleeps
use Storable;

open (my $dsp,"|padsp tee /dev/dsp > /dev/null") or   die qq(Couldn't execute for piping);
my @octaves=("C","C#","D","D#","E","F","F#","G","G#","A","A#","B") x 8; # create 96 key piano
my @keys= map{$octaves[$_].(int ($_/12)) }(0..$#octaves);          # append the octave number
my $notes={keys=>\@keys,sps=>900};                   # hashref to store the notes with keys

my $middleA=440;
if (-e "SineNotes$middleA.STOR"){
	$notes=retrieve("SineNotes$middleA.STOR");
}
else{ # making sine samples 
	for my $k(1..scalar @keys){
		my $f=$middleA*2**(($k-58)/12);              # generate frequency table
		my $s=pack'C*',map 127*(1+sin(($_*2*3.14159267*$f)/$notes->{sps})),0..$notes->{sps}-1; # generate the sample
		$notes->{$keys[$k-1]}={f=>sprintf("%.2f",$f),s=>$s};
		print $keys[$k-1], " \t",$f, " \t", $k, "\n";
	}
	store($notes, "SineNotes$middleA.STOR");
}

my $keyboard=<<EOK;

    Perl Incredibly Annoying Noisy Organ

    1   2   3   4   5   6   7   8   9   0   -   =
        C#  D#      F#  G#  A#      C#  D#      F#
 
      q   w   e   r   t   y   u   i   o   p   [ 
      C   D   E   F   G   A   B   C   D   E   F
  
        a   s   d   f   g   h   j   k   l   ;   '
        G#  A#      C#  D#      F#  G#  A#

      \\   z   x   c   v   b   n   m   ,   .   /    
      G   A   B   C   D   E   F   G   A   B   C

EOK

my $key2note={
	2=>"C#3",	3=>"D#3",	5=>"F#3",	6=>"G#3",	7=>"A#3",	9=>"C#4", "0"=>"D#4", "="=>"F#4",
	q=>"C3",	w=>"D3",	e=>"E3",	r=>"F3",	t=>"G3",	y=>"A3",	u=>"B3",	i=>"C4",	o=>"D4", p=>"E4", "["=>"F4",
	s=>"G#4",  d=>"A#4", f=>"C#5", h=>"D#5", j=>"F#5", k=>"G#5", l=>"A#5", "'"=>"C#6",
	"\\"=>"G4", z=>"A4", x=>"B4", c=>"C5", v=> "D5", b=>"E5", n=>"F5", m=>"G5", ","=>"A5", "."=>"B5", "/"=>"C6",
};

print $keyboard;
print "Start pressing keys... Escape to exit;\n";
my $refreshRate=50;    # read 50 times a second
ReadMode 'cbreak';
while(1){
	my $key = ReadKey(-1); 
	next unless defined $key;
	last if ( ord($key)==27);   # escape key exits
	next unless exists $key2note->{$key};
	sleep 1/$refreshRate;
	print $key,"-",$key2note->{$key},"-",$notes->{$key2note->{$key}}->{f};
	playNote( $key2note->{$key});    # Play the note
	playNote( $key2note->{$key});    # need to press twice to make it work ?why
}

ReadMode 'normal';
print "Finished\n";
close $dsp;

sub playNote{
	my $a=shift;
	$b=$a=~/^\d/?$notes->{$notes->{keys}->[$a]}->{s}:$notes->{$a}->{s};
	while (length $b)	{$b=substr $b,syswrite $dsp,$b};
	sleep $notes->{sps}/44000
}
