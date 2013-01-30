#!/usr/bin/env bash
set -e

IDIR=$1
ODIR=$2

mkdir -p $ODIR
for i in $(find $IDIR -type f); do
  pkg=$(basename $(dirname $i))
  echo $pkg 
  rm -f $ODIR/$pkg.tmp
  touch $ODIR/$pkg.tmp
  words=$(cat $i)
  for w in $words; do
    ext=${w##*\.}
    case $ext in
    cma|cmo|cmxs|cmx)
      echo $w >> $ODIR/$pkg.tmp
      ;;
    esac
  done
  sort -u $ODIR/$pkg.tmp > $ODIR/$pkg
done
