#!/usr/bin/env bash
set -eux

sed -i "s|-I/usr/local/opt/icu4c/include -I/opt/homebrew/opt/icu4c/include|-I$PREFIX/include|g" src/couch/rebar.config.script
sed -i "s|-L/usr/local/opt/icu4c/lib -L/opt/homebrew/opt/icu4c/lib|-L$PREFIX/lib|g" src/couch/rebar.config.script
export CFLAGS="-I$PREFIX/include -I$PREFIX/include/mozjs-91 -I$PREFIX/lib/erlang/usr/include"
export LDFLAGS="-L$PREFIX/lib"
export ERL_CFLAGS="$CFLAGS"
export ERL_LDFLAGS="$LDFLAGS"
./configure --erlang-md5 --spidermonkey-version 91
make release

install -dm755 $PREFIX/lib
cp -r rel/couchdb $PREFIX/lib/couchdb

CORE_ROOT=$PREFIX/lib/couchdb

# Write launch script and make executable
LAUNCH_SCRIPT=$PREFIX/bin/couchdb
cat <<EOF >$LAUNCH_SCRIPT
#!/bin/bash
$CORE_ROOT/bin/couchdb "\$@"
EOF
chmod +x $LAUNCH_SCRIPT

JS_SCRIPT=$PREFIX/bin/couchjs
cat <<EOF >$JS_SCRIPT
#!/bin/bash
$CORE_ROOT/bin/couchjs "\$@"
EOF
chmod +x $JS_SCRIPT
