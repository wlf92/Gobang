# Gobang
my game, client:quick-lua, server:cellnet base go, database:mysql

* protoc --plugin=protoc-gen-msg=/usr/local/bin/protoc-gen-msg --msg_out=msgid.go:. --proto_path="." *.proto
* protoc --plugin=protoc-gen-gogofaster=/usr/local/bin/protoc-gen-gogofaster --gogofaster_out=. --proto_path="." *.proto