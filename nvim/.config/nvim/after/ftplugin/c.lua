-- remove '-' from iskeyword for c files
-- This causes problems with the <cexpr> shorthand when debugging
-- TODO: Maybe consider setting more c/cpp appropriate iskeyword values
vim.cmd [[set iskeyword-=-]]
