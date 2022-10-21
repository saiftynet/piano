# Piano

A low dependency terminal piano player writen in Perl.

Many perl sound examples I have come across have needed /dev/dsp/ support.  This requires OSS compatibility support and is not automatically available in my distro. [Audio::DSP](http://matrix.cpantesters.org/?dist=Audio-DSP+0.02) fails.   While it can be installed, I have explored ways I may bypass this. [padsp](https://linux.die.net/man/1/padsp) is one option. It can be used to [start a program](https://wiki.archlinux.org/title/PulseAudio#padsp_wrapper) to give it OSS compatibility and access to /dev/dsp etc.

In [Attempt 1](Twinkle.pl#) I have adapted an illsutartion of how to pipe a stream into padsp and then tee to a /dev/dsp.





### Resources

[Twinkle Twinkle Little Star, Code Golf](https://codegolf.stackexchange.com/questions/272/twinkle-twinkle-little-star)

[padsp](https://unix.stackexchange.com/questions/13732/generating-random-noise-for-fun-in-dev-snd)

Check out [morsify](https://www.perlmonks.org/?node_id=1819)


