use strict; use warnings;
use lib "../lib";
use utf8;
use Term::Graille::Audio;
use Term::Graille::Interact;

my $beep=Term::Graille::Audio->new();    # TERM::Graille's Audio module
my $io=Term::Graille::Interact->new();   # capture keyboard actions

my ($keyboard,$key2note)=$beep->makeKeyboard;
print $keyboard;
print "       Start pressing keys... Escape to exit;\n";

$io->addAction("MAIN","others",{proc=>sub{
      my ($pressed,$GV)=@_;
      $beep->playSound(undef, $key2note->{$pressed})if exists $key2note->{$pressed};
    }
  }
);

$io->addAction("MAIN","esc",{proc=>sub{
      exit 1;
    }
  }
);

$io->run();
