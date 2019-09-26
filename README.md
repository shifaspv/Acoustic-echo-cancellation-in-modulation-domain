# Echo-cancellation
This repository contains the code of our recently proposed modulation domain acoustic echo cancellation.
Echo is the reflections of far-end speech which is being played out through a loud speaker in an end-to-end side of a communication channel.
In this work, The echo distraction at the near-end microphone has been significantly suppressed through our proposed modulation domain signal processing approach. The modulation domain processing is compared against the frequency domain approach proposed by Feller et.al, and this implimentation is also included in the file list.

# Description of the functions
modulation_domain.m: The proposed modulation domain echo cancellation script
rir.m: Room impulse response of which echo cancelled, being called Online inside the above function for echo signal generation

feller.m: Impimentation of frequency domain echo suppression by Feller at.al

# Paper to Cite
Those using this code are kindly requested to site our paper on this topic::

Muhammed Shifas P.V., Jayakumar E.P., Sathidevi P.S. (2018) Robust Acoustic Echo Suppression in Modulation Domain. In: Sa P., Sahoo M., Murugappan M., Wu Y., Majhi B. (eds) Progress in Intelligent Computing Techniques: Theory, Practice, and Applications. Advances in Intelligent Systems and Computing, vol 719. Springer, Singapore
