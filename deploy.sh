#! /bin/bash

s3cmd sync --reduced-redundancy build/* s3://spiridonov.pro
