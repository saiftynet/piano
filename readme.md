# Piano

A low dependency terminal piano player writen in Perl.

Many perl sound examples I have come across have needed /dev/dsp/ support.  This requires OSS compatibility support and is not automatically available in my distro. [Audio::DSP](http://matrix.cpantesters.org/?dist=Audio-DSP+0.02) fails.   While it can be installed, I have explored ways I may bypass this. [padsp](https://linux.die.net/man/1/padsp) is one option. It can be used to [start a program](https://wiki.archlinux.org/title/PulseAudio#padsp_wrapper) to give it OSS compatibility and access to /dev/dsp etc.

In [Attempt 1](Twinkle.pl#) Twinkle.pl. I have combined some code found in a code golf site, and combined it with a pipe into padsp and then tee to a /dev/dsp. (see refs below).  A previous bug had been that the data in the piano aplication would only produce outputs on alternate calles.  It appears that the piping/processing of the sounds waits until 1024 bytes are sent...

```
open (my $dsp,"|padsp tee /dev/audio > /dev/null") or   die qq(Couldn't execute for piping);
```

[Attempt 2](Attempt%202.pl#) maps 96 key piano to notes and frequencies and a sinewave generator

[SampleMaker](SampleMaker.pl#) (Attempt 3)

* Draws the piano and notes with reference a keyboard.
* creates and saves a sample file so does not need to be recreated (using storable)
* outputs keys data as keys are pressed ( key pressed, note represented, and frequency) as debug.
* realised that octaves dont go A..G, but C..B !!
* works but not for the A keys!!!..Help!!

Final version [PIANO.pl](piano.pl)

* The audio logic is now in a module Term::Graille::Audio
* Uses Term::Graille::Interact for interaction 
* Thus the actual program now is much more compact, but now depends on these component modules of Term::Graille

(Enable sound in the video)

[PIANO.webm](https://user-images.githubusercontent.com/34284663/198387222-f1287dd5-3bb2-4718-9fbd-ef8190661580.webm)


<video controls>
  <source src="https://user-images.githubusercontent.com/34284663/198387222-f1287dd5-3bb2-4718-9fbd-ef8190661580.webm" type="video/webm" />
</video>


### Frequency to data conversion

#### key to frequency converter
Number of keys to middleA= keys_to_A4
Frequency of middle A (note A4, key keys_to_A4) is 440hz;
all other keys can be derived from this
freqency=440 * 2  ** ((KeyNumber - keys_to_A4)/12)


#### simple sin wave
```
$sps=8000       #  sample size
$resolution=128 #  peak to peak
@sample_data=map {$resolution *  $_ *  2 * $freq * pi/$sps} (0..$sps-1)
```

### Resources

[Twinkle Twinkle Little Star, Code Golf](https://codegolf.stackexchange.com/questions/272/twinkle-twinkle-little-star)

[padsp](https://unix.stackexchange.com/questions/13732/generating-random-noise-for-fun-in-dev-snd)

Check out [morsify](https://www.perlmonks.org/?node_id=1819)

[Pure Perl Beep](https://metacpan.org/pod/Audio::Beep::Linux::PP) using ioctl

[Music notes](https://en.wikipedia.org/wiki/Piano_key_frequencies)


