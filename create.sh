#!/bin/bash
# remove hard line breaks to mimik github

# make options for input/output file and make toc optional
pandoc \
    -o $1 \
    -f markdown_github-hard_line_breaks \
    --css github.css \
    --toc \
    README.md
