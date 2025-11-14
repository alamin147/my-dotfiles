-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Telescope (safe require)
local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")

keymap.set("n", "x", '"_x')
-- telescope search current file only
vim.keymap.set("n", "<leader>bs", function()
  if not has_telescope then
    vim.notify("Telescope not available", vim.log.levels.WARN)
    return
  end
  -- Fuzzy find within the contents of the current buffer
  telescope_builtin.current_buffer_fuzzy_find()
end, { desc = "Fuzzy find in current file" })

-- telescope grep/find in current file
vim.keymap.set("n", ";fw", function()
  if not has_telescope then
    vim.notify("Telescope not available", vim.log.levels.WARN)
    return
  end
  -- Live grep within the current buffer
  telescope_builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Current File",
  })
end, { desc = "Grep in current file" })
--
-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- File explorer with NvimTree
keymap.set("n", "<Leader>f", ":NvimTreeFindFile<Return>", opts)
-- keymap.set("n", "<Leader>t", function()
--   -- Safely toggle nvim-tree: if the plugin/api isn't available, notify the user
--   local ok = pcall(require, "nvim-tree.api")
--   if ok then
--     vim.cmd("NvimTreeToggle")
--   else
--     vim.notify("nvim-tree not loaded: try restarting Neovim or loading the plugin", vim.log.levels.WARN)
--   end
-- end, opts)

-- ============================================================================
-- TOGGLETERM KEYBINDINGS
-- ============================================================================
-- Ctrl+\ is the main toggle (configured in toggleterm.lua)
-- Additional keybindings for different terminal modes:

-- <leader>ttt - Toggle floating terminal (main terminal - beautiful centered terminal)
keymap.set("n", "<leader>ttt", function()
  local status_ok, _ = pcall(require, "toggleterm")
  if not status_ok then
    vim.notify("ToggleTerm not loaded yet. Try again in a moment.", vim.log.levels.WARN)
    return
  end
  vim.cmd("ToggleTerm direction=float")
end, { desc = "Toggle floating terminal" })

-- <leader>tth - Toggle horizontal terminal (bottom split, respects current window width)
keymap.set("n", "<leader>tth", function()
  local status_ok, _ = pcall(require, "toggleterm")
  if not status_ok then
    vim.notify("ToggleTerm not loaded yet. Try again in a moment.", vim.log.levels.WARN)
    return
  end
  -- Open a split below current window instead of full width
  vim.cmd("belowright 5split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Toggle horizontal terminal (current window width)" })

-- <leader>ttv - Toggle vertical terminal (side split)
keymap.set("n", "<leader>ttv", function()
  local status_ok, _ = pcall(require, "toggleterm")
  if not status_ok then
    vim.notify("ToggleTerm not loaded yet. Try again in a moment.", vim.log.levels.WARN)
    return
  end
  vim.cmd("ToggleTerm size=30 direction=vertical")
end, { desc = "Toggle vertical terminal" })

-- ============================================================================
-- Tabs
keymap.set("n", "te", ":tabedit")
--keymap.set("n", "<tab>", ":tabnext<Return>", opts)
--keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tw", ":tabclose<Return>", opts)
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Move between windows with Ctrl+hjkl (better navigation)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")
-- Diagnostics (changed from Ctrl+j to avoid conflict with window navigation)
keymap.set("n", "]d", function()
  vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })
keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })
-- C++ Development shortcuts (handled by cpp-runner plugin)
-- <leader>cr - Compile and Run C++
-- <leader>cc - Compile and Run C
-- <leader>ci - Open Input File
-- <leader>co - Open Output File
-- F5 - Quick compile and run (when in C/C++ files)
-- F6 - Open input file (when in C/C++ files)
-- F7 - Open output file (when in C/C++ files)

-- Competitive Programming Keymaps
keymap.set("n", "<F5>", function()
  vim.cmd("w") -- save file
  local filename = vim.fn.expand("%:t:r") -- get filename without extension
  local filepath = vim.fn.expand("%:p") -- get full path
  local exe = "../outputs/" .. filename
  local input = "../io/input.txt"
  local output = "../io/output.txt"

  -- Create output directory if it doesn't exist (only if it doesn't exist)
  vim.cmd("!mkdir -p ../outputs")
  vim.cmd("!mkdir -p ../io")

  -- Check if input file exists
  local input_exists = vim.fn.filereadable(input) == 1
  if not input_exists then
    print("Creating input file at " .. input)
    vim.cmd("!touch " .. input)
  end

  -- Compile with better error reporting
  local compile_cmd = "g++ -o " .. exe .. " '" .. filepath .. "' -std=c++23 -O2 -Wall -Wextra"
  print("Compiling: " .. filename)

  -- Execute compilation and capture result
  local compile_result = vim.fn.system(compile_cmd)
  local compile_exit_code = vim.v.shell_error

  if compile_exit_code ~= 0 then
    print("Compilation failed!")
    print("Error: " .. compile_result)
    return
  end

  print("Compilation successful! Running...")

  -- Run the program
  local run_cmd = exe .. " < " .. input .. " > " .. output .. " 2>&1"
  local run_result = vim.fn.system(run_cmd)
  local run_exit_code = vim.v.shell_error

  if run_exit_code ~= 0 then
    print("Runtime error occurred!")
    print("Exit code: " .. run_exit_code)
  else
    print("Execution completed successfully!")
  end

  -- Check output
  local output_size = vim.fn.getfsize(output)
  if output_size > 0 then
    print("Output generated (" .. output_size .. " bytes). Press F7 to view.")
  else
    print("No output generated. Check your code or input.")
  end
end, { noremap = true, silent = true, desc = "Compile and Run C++" })

-- F6 - Open input file
keymap.set("n", "<F6>", function()
  vim.cmd("e ../io/input.txt")
end, { noremap = true, silent = true, desc = "Open input file" })

-- F7 - Open output file
keymap.set("n", "<F7>", function()
  vim.cmd("e ../io/output.txt")
end, { noremap = true, silent = true, desc = "Open output file" })

-- F8 - View output in split
keymap.set("n", "<F8>", function()
  vim.cmd("vsplit ../io/output.txt")
end, { noremap = true, silent = true, desc = "View output in split" })

-- Leader mappings for CP
keymap.set("n", "<leader>ci", ":e ../io/input.txt<CR>", { noremap = true, silent = true, desc = "Open input file" })
keymap.set("n", "<leader>co", ":e ../io/output.txt<CR>", { noremap = true, silent = true, desc = "Open output file" })
keymap.set("n", "<leader>cr", function()
  vim.cmd("w") -- save file
  local filename = vim.fn.expand("%:t:r")
  local filepath = vim.fn.expand("%:p")
  local exe = "../outputs/" .. filename
  local input = "../io/input.txt"
  local output = "../io/output.txt"

  -- Only create directories if they don't exist
  vim.cmd("!mkdir -p ../outputs")
  vim.cmd("!mkdir -p ../io")

  -- Check if input file exists
  local input_exists = vim.fn.filereadable(input) == 1
  if not input_exists then
    print("Creating input file at " .. input)
    vim.cmd("!touch " .. input)
  end

  -- Compile with error checking
  local compile_cmd = "g++ -o " .. exe .. " '" .. filepath .. "' -std=c++23 -O2 -Wall -Wextra"
  print("Compiling: " .. filename)

  local compile_result = vim.fn.system(compile_cmd)
  local compile_exit_code = vim.v.shell_error

  if compile_exit_code ~= 0 then
    print("Compilation failed!")
    print("Error: " .. compile_result)
    return
  end

  print("Compilation successful! Running...")

  -- Run the program
  local run_cmd = exe .. " < " .. input .. " > " .. output .. " 2>&1"
  local run_result = vim.fn.system(run_cmd)
  local run_exit_code = vim.v.shell_error

  if run_exit_code ~= 0 then
    print("Runtime error occurred!")
    print("Exit code: " .. run_exit_code)
  else
    print("Execution completed successfully!")
  end

  local output_size = vim.fn.getfsize(output)
  if output_size > 0 then
    print("Output generated (" .. output_size .. " bytes)")
  else
    print("No output generated. Check your code or input.")
  end
end, { noremap = true, silent = true, desc = "Compile and Run C++" })

-- Template creation for competitive programming
keymap.set("n", "<leader>ct", function()
  local template = [[#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    // Your code here

    return 0;
}]]

  -- Insert template at the beginning of the file
  vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(template, "\n"))
  -- Move cursor to the "Your code here" line
  vim.api.nvim_win_set_cursor(0, { 7, 4 })
end, { noremap = true, silent = true, desc = "Insert C++ template" })

-- F9 - Debug: Show input and output side by side
keymap.set("n", "<F9>", function()
  vim.cmd("split ../io/input.txt")
  vim.cmd("vsplit ../io/output.txt")
  vim.cmd("wincmd k") -- go to top window (current file)
end, { noremap = true, silent = true, desc = "Show input/output side by side" })

-- F10 - Run with terminal output (for debugging)
keymap.set("n", "<F10>", function()
  vim.cmd("w") -- save file
  local filename = vim.fn.expand("%:t:r")
  local filepath = vim.fn.expand("%:p")
  local exe = "../outputs/" .. filename
  local input = "../io/input.txt"

  -- Only create directories if they don't exist
  vim.cmd("!mkdir -p ../outputs")
  vim.cmd("!mkdir -p ../io")

  -- Ensure input file exists
  local input_exists = vim.fn.filereadable(input) == 1
  if not input_exists then
    vim.cmd("!touch " .. input)
  end

  local compile_cmd = "g++ -o " .. exe .. " '" .. filepath .. "' -std=c++23 -O2 -Wall -Wextra"
  local run_cmd = exe .. " < " .. input

  print("Compiling and running in terminal...")
  vim.cmd("!" .. compile_cmd .. " && echo 'Compilation successful! Running...' && " .. run_cmd)
end, { noremap = true, silent = true, desc = "Compile and run with terminal output" })

-- C++ snippet keymap
keymap.set("n", "cpp", function()
  local cpp_template = [[#include<bits/stdc++.h>
#include<ext/pb_ds/assoc_container.hpp>
#include<ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
using namespace std;
template <typename T> using pbds = tree<T, null_type, less<T>, rb_tree_tag, tree_order_statistics_node_update>;
#define ll long long
#define py cout<<"YES"<<endl
#define pn cout<<"NO"<<endl
#define piza ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);
#define fn(s,e,in) for(int i=s;i<e;i+=in)
#define ss(a) sort(a.begin(),a.end())
#define prn(c) cout << c <<"\n"
#define cc cout <<"\n"
#define pab(a,b) cout << a <<" "<<b
#define pa(a) cout << a <<" "
#define vc(v,n,l) vector<l>v(n)
#define elif else if
bool validIndex(int i, int n);
bool isEven(int n);
ll gcd(ll a,ll b);
ll lcm(ll a,ll b);
bool isPrime(ll n);
ll num_one_bits(ll n);

void alfa()
{

}

int main()
{
    piza
    int tt=1;
    cin>>tt;
    while(tt--)
        alfa();
 #ifndef ONLINE_JUDGE
            cerr<<"Time: "<<1000*((double)clock())/(double)CLOCKS_PER_SEC<<"ms\n";
        #endif
}

bool validIndex(int i,int n){
    return i>=0 && i<n;
}
bool isEven(int n){
    return n%2==0;
}
ll gcd(ll a,ll b){
return __gcd(a,b);
}
ll lcm(ll a,ll b){
return ((a/__gcd(a,b))*b);
}
ll num_one_bits(ll n){
return __builtin_popcountll(n);
}
bool isPrime(ll n){
if(n<=1)return false;
if(n<=3)return true;
if(n%2==0||n%3==0)return false;
for(ll i=5;i*i<=n;i+=6){
if(n%i==0||n%(i+2)==0)return false;
}
return true;
}


//=========================================
//      0 . O       /`-._           alamin
//   . o  O        /_,.._`:-
//      o    ,.-'  ,   ``-:_,-')
//       .  : o ):';       _  {
//           `-._ `'__,.-''\`-.)
//    \/         `\\  \,.-'``        \/
//=========================================
]]
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.split(cpp_template, "\n")
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + 7, 4 })
end, { desc = "Insert C++ template" })
-- C++ snippet keymap
keymap.set("n", "cph", function()
  local cpp_template = [[#include <bits/stdc++.h>
using namespace std;

]]
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.split(cpp_template, "\n")
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + 3, 0 })
end, { desc = "Insert C++ template" })

-- F11 - Debug compilation (shows compilation errors/warnings)
keymap.set("n", "<F11>", function()
  vim.cmd("w") -- save file
  local filename = vim.fn.expand("%:t:r")
  local filepath = vim.fn.expand("%:p")
  local exe = "../outputs/" .. filename

  -- Only create outputs directory if it doesn't exist
  vim.cmd("!mkdir -p ../outputs")

  local compile_cmd = "g++ -o " .. exe .. " '" .. filepath .. "' -std=c++23 -O2 -Wall -Wextra -v"

  print("Compiling with verbose output: " .. filename)
  vim.cmd("!" .. compile_cmd)
end, { noremap = true, silent = true, desc = "Debug compilation with verbose output" })

-- F12 - Show current directory structure (for debugging)
keymap.set("n", "<F12>", function()
  local current_dir = vim.fn.getcwd()
  print("Current directory: " .. current_dir)
  print("Looking for:")
  print("  Input: ../io/input.txt")
  print("  Output: ../io/output.txt")
  print("  Executable: ../outputs/")

  -- Check if paths exist
  local input_exists = vim.fn.filereadable("../io/input.txt") == 1
  local output_dir_exists = vim.fn.isdirectory("../outputs") == 1
  local io_dir_exists = vim.fn.isdirectory("../io") == 1

  print("Status:")
  print("  ../io/ directory: " .. (io_dir_exists and "EXISTS" or "NOT FOUND"))
  print("  ../io/input.txt: " .. (input_exists and "EXISTS" or "NOT FOUND"))
  print("  ../outputs/ directory: " .. (output_dir_exists and "EXISTS" or "NOT FOUND"))

  -- Show directory listing
  vim.cmd("!echo 'Directory listing:' && ls -la ../")
end, { noremap = true, silent = true, desc = "Debug directory structure" })

-- code runner
vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>rrc", ":RunClose<CR>", { noremap = true, silent = true })

-- Toggle the most recently used terminal (useful to show/hide the RunCode terminal)
keymap.set("n", "<leader>rt", function()
  -- Find the most recently used terminal buffer
  local term_buf = nil
  local lastused = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_option(b, "buftype") == "terminal" then
      local info = vim.fn.getbufinfo(b)[1]
      if info and info.lastused and info.lastused > lastused then
        lastused = info.lastused
        term_buf = b
      end
    end
  end

  -- If no terminal buffer found, try ToggleTerm if available, otherwise open a new terminal split
  if not term_buf then
    if vim.fn.exists(":ToggleTerm") == 2 then
      vim.cmd("ToggleTerm")
    else
      vim.cmd("botright 15split | terminal")
    end
    return
  end

  -- If the terminal buffer is already visible, close its window (toggle off)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(w) == term_buf then
      vim.api.nvim_win_close(w, true)
      return
    end
  end

  -- Otherwise, show the terminal in a bottom split and enter insert mode
  vim.cmd("botright 15split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, term_buf)
  vim.cmd("startinsert")
end, { noremap = true, silent = true, desc = "Toggle Run terminal" })

-- Compile current file from ./codeforces with debug info and place binary in /outputs
keymap.set("n", "<leader>gD", function()
  vim.cmd("w") -- save file
  local filepath = vim.fn.expand("%:p")
  -- Try to find a relative path under cp/ (case-insensitive)
  local low = filepath:lower()
  local s, e = low:find("[/\\]cp[/\\]")
  local out_base
  local rel
  if s then
    -- rel is path after cp/
    rel = filepath:sub(e + 1)
    -- prefix including up to the 'cp' directory
    local prefix_cp = filepath:sub(1, e - 1)
    out_base = prefix_cp .. "/outputs"
  else
    -- fallback: put outputs next to current working dir
    out_base = vim.fn.getcwd() .. "/outputs"
  end

  local out_path
  -- Flatten outputs to cp_root/outputs/{filename_without_ext}
  local name_no_ext = vim.fn.expand("%:t:r")
  out_path = out_base .. "/" .. name_no_ext

  -- Ensure parent directory for output exists using vim.fn.mkdir (portable)
  local out_dir = out_path:match("(.*/)") or out_base
  vim.fn.mkdir(out_dir, "p")

  local cmd = "g++ --debug '" .. filepath .. "' -o '" .. out_path .. "' 2>&1"
  print("Running: " .. cmd)
  local result = vim.fn.system(cmd)
  local code = vim.v.shell_error
  if code ~= 0 then
    print("Compilation failed (exit " .. code .. ")")
    print(result)
  else
    print("Compilation successful: " .. out_path)
  end
end, { noremap = true, silent = true, desc = "g++ --debug mirror cp/* -> /outputs/*" })

-- ============================================================================
-- THEME PICKER
-- ============================================================================
-- <leader>th - Open interactive theme picker (defined in plugins/theme.lua)

-- ============================================================================
-- COMMENT TOGGLE
-- ============================================================================
-- Toggle comment for selected lines (visual mode) or current line (normal mode)
-- Uses built-in commenting (gc operator from LazyVim/ts-comments)
keymap.set("n", "<leader>/.", "gcc", { desc = "Toggle comment", remap = true })
keymap.set("v", "<leader>/.", "gc", { desc = "Toggle comment", remap = true })

-- =====
-- TODO: COMMENTS
-- =====
keymap.set("n", "<leader>xt", ":TodoQuickFix<CR>", { desc = "Find TODO comments" })

----===========
---NOTE: typewriter mode
---==========

vim.keymap.set("n", "<leader>tyty", ":Speedtyper<CR>", { desc = "Start typing test" })
-- a============================================================================
-- COPILOT CHAT KEYBINDINGS
-- ============================================================================

-- Main inline chat - ask Copilot to write code at cursor position
--keymap.set({ "n", "v" }, "<leader>ai", function()
--  local input = vim.fn.input("Ask Copilot: ")
--  if input ~= "" then
--    vim.cmd("CopilotChat " .. input)
--  end
--end, { desc = "CopilotChat - Ask inline (write function here)" })
--
---- Quick chat toggle
--keymap.set("n", "<leader>aa", "<cmd>CopilotChatToggle<cr>", { desc = "CopilotChat - Toggle window" })
--
---- Explain selected code
--keymap.set({ "n", "v" }, "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "CopilotChat - Explain code" })
--
---- Fix code issues
--keymap.set({ "n", "v" }, "<leader>af", "<cmd>CopilotChatFix<cr>", { desc = "CopilotChat - Fix bugs" })
--
---- Optimize code
--keymap.set({ "n", "v" }, "<leader>ao", "<cmd>CopilotChatOptimize<cr>", { desc = "CopilotChat - Optimize" })
--
---- Generate documentation
--keymap.set({ "n", "v" }, "<leader>ad", "<cmd>CopilotChatDocs<cr>", { desc = "CopilotChat - Generate docs" })
--
---- Generate tests
--keymap.set({ "n", "v" }, "<leader>at", "<cmd>CopilotChatTests<cr>", { desc = "CopilotChat - Generate tests" })
--
---- Review code
--keymap.set({ "n", "v" }, "<leader>ar", "<cmd>CopilotChatReview<cr>", { desc = "CopilotChat - Review code" })
--
---- Quick prompts with visual selection
--keymap.set("v", "<leader>av", function()
--  local actions = require("CopilotChat.actions")
--  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
--end, { desc = "CopilotChat - Quick actions (visual)" })
