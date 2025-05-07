local M = {}

local cache = nil

-- Seed the RNG
math.randomseed(os.time())

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
  if cache then return cache end

  local csv_path = vim.api.nvim_get_runtime_file("lua/quotes.csv", false)[1]
  if not csv_path then error("Could not find quotes.csv") end

  local file = io.open(csv_path, "r")
  if not file then error("Failed to open: " .. csv_path) end

  _ = file:read("*line") -- Skip header row

  local quotes = {}

  for line in file:lines() do
    local author, quote = line:match('"(.-)","(.-)"')
    if author and quote then
      table.insert(quotes, {
        author = author == "" and "Anonymous" or author,
        quote = quote,
      })
    end
  end

  file:close()

  -- Store in cache and return
  cache = quotes

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
