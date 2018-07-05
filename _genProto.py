# -*- coding: utf-8 -*- 

import os
import shutil

def joinDir(root, *dirs):
    for item in dirs:
        root = os.path.join(root, item)
    return root

ROOT_PATH = os.path.dirname(__file__)
PROTO_PATH = joinDir(ROOT_PATH, "proto2-lua", "proto")
os.chdir(PROTO_PATH)

# lua的proto信息生成
if os.path.exists("../lua"):
    shutil.rmtree("../lua")
os.mkdir("../lua")
os.system("../protoc2 --plugin=protoc-gen-lua='../plugin/protoc-gen-lua' --lua_out=../lua *.proto")

# go的proto信息生成
if os.path.exists("../go"):
    shutil.rmtree("../go")
os.mkdir("../go")
for file in os.listdir(PROTO_PATH):
    if file.endswith(".proto"):
        prefix = file.split(".")[0]
        # proto文件生成
        os.system("../protoc3 --plugin=protoc-gen-gogofaster=../protoc-gen-gogofaster --gogofaster_out=../go {}".format(file))
        # 消息id生成
        os.system("../protoc3 --plugin=protoc-gen-msg=../protoc-gen-msg --msg_out=../go/{}-msg.go:. {}".format(prefix, file))

#复制proto文件
for file in os.listdir(PROTO_PATH):
    if file.endswith(".proto"):
        shutil.copyfile(joinDir(PROTO_PATH, file), joinDir(PROTO_PATH, "..", "lua", file))
        shutil.copyfile(joinDir(PROTO_PATH, file), joinDir(PROTO_PATH, "..", "go", file))


LUA_PROTO_PATH = joinDir(ROOT_PATH, "gobang-client", "src", "app", "proto")
if os.path.exists(LUA_PROTO_PATH):
    shutil.rmtree(LUA_PROTO_PATH)
shutil.copytree("../lua", LUA_PROTO_PATH)

GO_PROTO_PATH = joinDir(ROOT_PATH, "gobang-server", "proto")
if os.path.exists(GO_PROTO_PATH):
    shutil.rmtree(GO_PROTO_PATH)
shutil.copytree("../go", GO_PROTO_PATH)