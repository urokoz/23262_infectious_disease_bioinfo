#!/usr/bin/env python 

import argparse
import sys
import gzip


def openfile(filename, mode):
    """ Open gzip or normal files.
    """
    try:
        if filename.endswith('.gz'):
            fh = gzip.open(filename, mode=mode)
        else:
            fh = open(filename, mode)
    except:
        sys.exit("Can't open file:", filename)
    return fh


parser = argparse.ArgumentParser(description='Find minor variants from VCF files.')

parser.add_argument("--minor_tr", type=float, dest="minor_thr", action="store", default=0.15, 
                    help="The minimum threshhold to count as minor variant.")
parser.add_argument("--min_var", type=int, dest="min_count", action="store", default=300,
                    help="The minimum value a variant needs to be counted as valid.")
parser.add_argument("--file", type=str, dest="filename", action="store", required=True,
                    help="Filename of the vcf file to analyze.")

args = parser.parse_args()

minor_thr = args.minor_thr
min_var_count = args.min_count

filename = args.filename

infile = openfile(filename, "rt")

for line in infile:
    if line.startswith("#"):
        continue
    
    info = line.rstrip().split("\t")[7]
    
    print([field.split("=")[1] for field in info.split(";")])

    