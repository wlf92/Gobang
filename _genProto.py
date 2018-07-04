# -*- coding: utf-8 -*- 

import os
import shutil

def joinDir(root, *dirs):
    for item in dirs:
        root = os.path.join(root, item)
    return root

ROOT_PATH = os.path.dirname(__file__)

# lua的proto信息生成
os.chdir(joinDir(ROOT_PATH, "proto2-lua", "proto"))
if os.path.exists("../output") == False:
    os.mkdir("../output")
os.system("../protoc2 --plugin=protoc-gen-lua='../plugin/protoc-gen-lua' --lua_out=../output *.proto")

LUA_PROTO_PATH = joinDir(ROOT_PATH, "gobang-client", "src", "app", "proto")
if os.path.exists(LUA_PROTO_PATH):
    shutil.rmtree(LUA_PROTO_PATH)
shutil.move("../output", LUA_PROTO_PATH)

# go的proto信息生成
# proto文件生成
os.system("../protoc3 --plugin=protoc-gen-gogofaster=../protoc-gen-gogofaster --gogofaster_out=../go *.proto")
# 消息id生成
os.system("../protoc3 --plugin=protoc-gen-msg=../protoc-gen-msg --msg_out=../go/msg_id.go:. *.proto")

GO_PROTO_PATH = joinDir(ROOT_PATH, "gobang-server", "proto")
if os.path.exists(GO_PROTO_PATH):
    shutil.rmtree(GO_PROTO_PATH)
shutil.move("../go", GO_PROTO_PATH)