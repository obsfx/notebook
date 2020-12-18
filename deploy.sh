#!/bin/bash

files=''
titles=''
outdir='./posts'
style='./style.css,./xt256.css'
dm='https://obsfx.github.io/notebook'

rdme='# 📝 Notebook\n\n'

# https://stackoverflow.com/questions/2437452/how-to-get-the-list-of-files-in-a-directory-in-a-shell-script
for entry in "$search_dir"./md/*
do
  files+="$entry"
  files+=","

  IFS='//' read -r -a entrystrarr <<< "$entry"

  filename=${entrystrarr[2]}

  titles+="$filename"
  titles+=","

  IFS='.' read -r -a filenamestrarr <<< "$filename"

  # https://stackoverflow.com/a/2871187
  filenamewoex="${filenamestrarr[0]//[_-]/ }"

  rdme+="[$filenamewoex]($dm/posts/${filename})"
  rdme+="\n\n"
done

files="${files::-1}"
titles="${titles::-1}"

lurkdown --files=$files \
  --titles=$titles \
  --outdir=$outdir \
  --styles=$style

echo -e $rdme > ./md/README.md

lurkdown --files=./md/README.md \
  --titles=Notebook \
  --outdir=$outdir \
  --styles=$style

mv ./md/README.md ./README.md
mv ./posts/README.html ./index.html

git add -A
git commit -m 'deploy'
git push -u origin gh-pages
