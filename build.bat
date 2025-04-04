@echo off

set OPTIONS=--enable-multi-memory --enable-threads

wat2wasm %OPTIONS% data.wat -o data.wasm
wat2wasm %OPTIONS% main.wat -o main.wasm
