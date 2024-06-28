#!/bin/bash

su l1em << BASH
  /bin/bash
  . /home/l1em/miniconda3/etc/profile.d/conda.sh
  conda activate L1EM
  which bwa


BASH
