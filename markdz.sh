#!/bin/bash

# check for enhanced getopt and quit otherwise
# any modern linux and CYGWIN will have enhanced getopt
# however, it's not the default on osx and has to be installed
getopt --test
if [[ $? -ne 4 ]]; then
    echo "Enhanced getopt not found"
    exit 1
fi

# set default values
outfile="readme.html"
infile="README.md"
tocDepth=3
tocOnly=0

# set options for getopt
shortOps=o:ti:v
longOps=output:,toc,input:,toc-depth:,verbose,toc-only

options=$(getopt --options $shortOps --longoptions $longOps --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi
eval set -- "$options"

while true; do
    case "$1" in
        -o|--output)
            outfile="$2"
            shift 2
            ;;
        -t|--toc)
            toc="--toc"
            shift
            ;;
        -i|--input)
            infile="$2"
            shift 2
            ;;
        --toc-depth)
            tocDepth="$2"
            shift 2
            ;;
        --toc-only)
            tocOnly=1
            echo "TOC only is not implemented yet"
            shift
            ;;
        -v|--verbose)
            printOptions=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unknown implementation error. This shouldn't happen."
            exit 3
            ;;
    esac
done

cssLocation=$(dirname $0)

if [[ $printOptions -eq 1 ]]; then
    echo outfile = $outfile
    echo infile = $infile
    echo tocDepth = $tocDepth
    echo tocOnly = $tocOnly
    echo toc = $toc
    echo cssLocation = $cssLocation/github.css
fi

# if creating markdown file, always generate github markdown
# remove hard line breaks to mimik github
if [[ "$outfile" == *.md ]]; then
    markdownFormat="--to=markdown_github-hard_line_breaks"
fi


pandoc \
    -o $outfile \
    --from=markdown_github-hard_line_breaks \
    ${markdownFormat:+"$markdownFormat"} \
    --css $cssLocation/github.css \
    --self-contained \
    ${toc:+"$toc"} \
    --toc-depth=$tocDepth \
    $infile
