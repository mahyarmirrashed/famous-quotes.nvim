local M = {}
local quotes_cache = nil

-- Fisher-Yates shuffle algorithm: https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
local function shuffle(array)
  local n = #array
  for i = n, 2, -1 do
    local j = math.random(1, i)
    array[i], array[j] = array[j], array[i]
  end
  return array
end

local function load_quotes()
  if quotes_cache then return quotes_cache end

  local script_dir = vim.fn.expand("<sfile>:p:h")
  local csv_file = script_dir .. "/quotes.csv"

  if vim.fn.filereadable(csv_file) == 0 then error("Quotes CSV file not found at " .. csv_file) end

  local quotes = {}
  local file = io.open(csv_file, "r")
  if not file then error("Failed to open quotes CSV file") end

  _ = file:read("*line")

  for line in file:lines() do
    local author, quote = line:match('"(.-)","(.-)"')
    if author and quote then
      author = author == "" and "Anonymous" or author
      table.insert(quotes, { author = author, quote = quote })
    end
  end
  file:close()

  quotes_cache = quotes
  return quotes
end

--- Sets up the famous-quotes plugin.
--- This function is provided for compatibility but performs no actions.
--- @return nil
function M.setup() end

--- Retrieves a specified number of random quotes from the quotes CSV file.
--- Quotes are shuffled using the Fisher-Yates algorithm on each call.
--- @param count? number The number of quotes to retrieve (default: 1). Use -1 to retrieve all quotes.
--- @return table A table of quote objects, each containing 'author' and 'quote' fields.
function M.get_quote(count)
  count = count or 1
  local quotes = load_quotes()

  if count == -1 then count = #quotes end

  if count < 1 then return {} end

  local shuffled = shuffle(vim.deepcopy(quotes))

  local result = {}
  for i = 1, math.min(count, #shuffled) do
    table.insert(result, shuffled[i])
  end

  return result
end

return M
