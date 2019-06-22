# Shadow Over the Twelve Lands
A retro-style RPG game.

Copyright &copy; 2019 Bruno Oliveira - brunotc@gmail.com

Follow me on Twitter: [@btco_code](http://twitter.com/btco_code)

You can play this game online here:
 * [TIC-80 site](https://tic.computer/play?cart=873)
 * [itch.io page](https://btco.itch.io/shadow-over-the-twelve-lands)

The engine for the game is written in LUA but due to TIC-80 cart
size limitations, the game's quest logic is written in an assembly
language I created, called XL.

The Lua code starts a virtual machine (a VM inside a VM!) to
interpret the XL code.

In the tools directory there is an assembler written in perl that
assembles the XL source code into XL bytecode to be fed into the
VM.

The VM bytecode takes about 64K.

# License

This software is distributed under the Apache License, version 2.0.

    Copyright (c) 2017 Bruno Oliveira

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

