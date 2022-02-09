[![Build Status](https://travis-ci.org/calind/lmdb-lua-ffi.svg?branch=master)](https://travis-ci.org/calind/lmdb-lua-ffi)

lmdb-lua-ffi
============

使用方法： make test

LMDB 全称为 Lightning Memory-Mapped Database，就是非常快的内存映射型数据库，LMDB使用内存映射文件，可以提供更好的输入/输出性能，对于用于神经网络的大型数据集( 比如 ImageNet )，可以将其存储在 LMDB 中。
LMDB效率高的一个关键原因是它是基于内存映射的，这意味着它返回指向键和值的内存地址的指针，而不需要像大多数其他数据库那样复制内存中的任何内容。
LMDB不仅可以用来存放训练和测试用的数据集，还可以存放神经网络提取出的特征数据。如果数据的结构很简单，就是大量的矩阵和向量，而且数据之间没有什么关联，数据内没有复杂的对象结构，那么就可以选择LMDB这个简单的数据库来存放数据。
LMDB的文件结构很简单，一个文件夹，里面是一个数据文件和一个锁文件。数据随意复制，随意传输。它的访问简单，不需要单独的数据管理进程。只要在访问代码里引用LMDB库，访问时给文件路径即可。

用LMDB数据库来存放图像数据，而不是直接读取原始图像数据的原因：
数据类型多种多样，比如：二进制文件、文本文件、编码后的图像文件jpeg、png等，不可能用一套代码实现所有类型的输入数据读取，因此通过LMDB数据库，转换为统一数据格式可以简化数据读取层的实现。
lmdb具有极高的存取速度，大大减少了系统访问大量小文件时的磁盘IO的时间开销。LMDB将整个数据集都放在一个文件里，避免了文件系统寻址的开销，你的存储介质有多快，就能访问多快，不会因为文件多而导致时间长。LMDB使用了内存映射的方式访问文件，这使得文件内寻址的开销大幅度降低。

LMDB 的基本函数

env = lmdb.open()：创建 lmdb 环境
txn = env.begin()：建立事务
txn.put(key, value)：进行插入和修改
txn.delete(key)：进行删除
txn.get(key)：进行查询
txn.cursor()：进行遍历
txn.commit()：提交更改



废弃 busted； 改用 luaunit

underscore提供集合数组func Object 的常用函数； 建議使用Lo-Dash，性能優異很多的實現。
Underscore.funcs.for_each = Underscore.funcs.each
Underscore.funcs.collect = Underscore.funcs.map
Underscore.funcs.inject = Underscore.funcs.reduce
Underscore.funcs.foldl = Underscore.funcs.reduce
Underscore.funcs.filter = Underscore.funcs.select
Underscore.funcs.every = Underscore.funcs.all
Underscore.funcs.some = Underscore.funcs.any
Underscore.funcs.head = Underscore.funcs.first
Underscore.funcs.tail = Underscore.funcs.rest
Underscore.lua, 一个Lua版本的Underscore, 函数都通用. 包含面向对象封装和链式语法. (源码)
_ = require 'underscore' 是一个提供一组实用程序的Lua库   用于处理迭代器，数组，表和函数的函数。   这是api和文档受Underscore.lua的启发。   在Lua中使用下划线字符来丢弃变量是惯用的，所以你可以简单地将它分配给另一个变量名



LuaJIT FFI based bindings for lmdb (http://symas.com/mdb/). This library is work-in-progess and is far for being stable. The interface is inspired by [py-lmdb](http://lmdb.readthedocs.org/).

So far the environment and transaction implementation in almost complete. The cursors are WIP



Copyright and License
=====================

Copyright (c) 2014, Calin Don
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
