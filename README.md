# Echo-cancellation
This repository contains the code of our recently proposed modulation domain acoustic echo cancellation (The paper cited below).
Echo is the reflections of far-end speech which is being played out through a near-end loud speaker in an end-to-end communication channel.
In this work, The echo distraction at the near-end microphone has significantly been suppressed through our proposed modulation domain signal processing approach. The modulation domain processing is compared against the frequency domain approach proposed by Feller et.al, and this implimentation is also included in the file list.

User can change the far-end signal which is being caused the echo effect and near-end signal that wants to be transmitted, internally.  

# Description of the functions
**modulation_domain.m**: The proposed modulation domain echo cancellation script

**rir.m**: Room impulse response of which echo cancelled, being called Online inside the above function for echo signal generation

**enframe.m, overlapadd.m**: signal framing and overlap add reconstruction

**feller.m**: Impimentation of frequency domain echo suppression by Feller at.al

# Paper to Cite
Those using this code are kindly requested to site our paper on this topic::

Shifas, PV Muhammed, E. P. Jayakumar, and P. S. Sathidevi. "Robust Acoustic Echo Suppression in Modulation Domain." Progress in Intelligent Computing Techniques: Theory, Practice, and Applications. Springer, Singapore, 2018. 527-537.
