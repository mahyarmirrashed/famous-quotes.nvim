# famous-quotes.nvim

A Neovim plugin that provides random famous quotes from a bundled CSV file. Quotes are shuffled using the Fisher-Yates algorithm and cached for performance.

## Features

- No dependencies: everything is self-contained so no unnecessary internet API calls!
- Supports fetching one quote, multiple quotes, or all the quotes.
- Caches quotes to avoid repeated file I/O.

## Requirements

- Neovim 0.5.0 or later (this was when Lua was introduced).
- Lua support (included in Neovim by default).

## Installation

Install using your preferred Neovim package manager.

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'mahyarmirrashed/famous-quotes'
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'mahyarmirrashed/famous-quotes'
```

## Usage

The plugin provides a single function, `get_quote(count)`, to retrieve random quotes.

### Example Commands

```lua
-- Get one random quote (default)
local quote = require('famous-quotes').get_quote()
print(quote[1].author .. ': ' .. quote[1].quote)

-- Get three random quotes
local quotes = require('famous-quotes').get_quote(3)
for _, q in ipairs(quotes) do
  print(q.author .. ': ' .. q.quote)
end

-- Get all quotes
local all_quotes = require('famous-quotes').get_quote(-1)
```

### Function Documentation

#### `get_quote(count?)`

- **count** (optional, number): Number of quotes to retrieve. Defaults to 1. Use `-1` to get all quotes.
- **Returns**: A table of quote objects, each with `author` and `quote` fields.

#### `setup()`

- No-op function provided for compatibility. No configuration needed.

## Credits

Thanks to @JakubPetriska for the [CSV of quotes](https://gist.github.com/JakubPetriska/060958fd744ca34f099e947cd080b540) used in this plugin.

## License

[MIT License](./LICENSE)
