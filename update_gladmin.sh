#!/bin/sh
 
git=$1
gitname="`basename $git`"
 
if [ $gitname = gitolite-admin.git ]
then
  cd $git
  export GL_BINDIR=/usr/bin
  export GL_LIBDIR=/usr/share/gitolite3
  $HOME/.gitolite/hooks/gitolite-admin/post-update
fi
