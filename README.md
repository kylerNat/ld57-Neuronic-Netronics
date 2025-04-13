![Ludum Dare](https://img.shields.io/badge/LudumDare-57-f79122?labelColor=ee5533&link=https%3A%2F%2Fldjam.com%2Fevents%2Fludum-dare%2F57) ![Ludum Dare](https://img.shields.io/badge/LudumDare57-Compo-f79122?labelColor=6f7984&link=https%3A%2F%2Fldjam.com%2Fevents%2Fludum-dare%2F57%2Fgames%2Foverall%2Fcompo)

# Neuronic Netronics
![Cover Image](https://raw.githubusercontent.com/kylerNat/ld57-Neuronic-Netronics/refs/heads/main/screenshots/Cover%20Image.png)

A game about solving puzzles with small neural networks. Originally made in 48 hours for Ludum Dare 57.

## Note about my hand-written wasm setup
My setup with wasm is that I write to a wat file (the text format for wasm) in vim, with a build script running the wat2wasm command whenever I save. The javascript side continuously checks the hash of the main.wasm file, and will reload it when it changes. I have the data separated from the update loop, so that it can be reloaded without losing state or having to refresh the page. At least for a project this small everything was nearly instant.

The graphics are a buffer that gets directly copied onto the canvas from the js side, and similarly the audio is just writing samples from a ring buffer into a js audio worklet. For data structures I have hard-coded addresses for everything, which would probably be a problem if the project grows but it worked out fine for a jam.

This was my first time trying this and I just learned things by reading the wasm docs (which are thankfully not too long) about a week before, so there are definitely ways this could be improved. One thing I originally wanted that I didn’t have time to setup before the jam was a custom pre-processor that I could use to have macros, binary file embedding, and a more flexible way to layout memory.

I definitely wouldn’t recommend doing hand wasm like this except for fun or to optimize specific functions, but I think a similar setup with a higher-level language before wasm would work very well. The normal way web builds are done is with emscripten, which is meant to let you run desktop apps on the web and consequently it has tons of bloat like emulating a file system which isn’t really necessary if things are made for the web in the first place. As a comparison the last web game I made for ludum dare used emscripten and was a 2.58 Mb wasm file, while this one has a 15 kb wasm file.
