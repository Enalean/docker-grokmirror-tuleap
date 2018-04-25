#!/bin/sh
 
git=$1
gitname="`basename $git`"
 
if [ $gitname = gitolite-admin.git ]
then
  cd $git
  export GL_BINDIR=/usr/share/gitolite3
  export GL_LIBDIR=$GL_BINDIR
  $HOME/.gitolite/hooks/gitolite-admin/post-update refs/heads/master
fi
