{ pkgs, ... }:

{
  home.username = "zee";
  home.homeDirectory = "/home/zee";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # ─────────────────────────────────────────────
    # Core CLI
    # ─────────────────────────────────────────────

    git
    gh
    git-lfs
    delta

    curl
    wget
    btop

    ripgrep
    fd
    fzf
    eza
    bat
    tree

    jq
    yq
    unzip
    zip
    delta

    # ─────────────────────────────────────────────
    # C / C++
    # ─────────────────────────────────────────────

    gcc
    cmake
    gnumake
    ninja
    pkg-config
    gdb
    valgrind

    # ─────────────────────────────────────────────
    # Rust
    # ─────────────────────────────────────────────

    rustup

    # ─────────────────────────────────────────────
    # Go
    # ─────────────────────────────────────────────

    go

    # ─────────────────────────────────────────────
    # Python
    # ─────────────────────────────────────────────

    python3
		uv

    # ─────────────────────────────────────────────
    # JavaScript / TypeScript
    # ─────────────────────────────────────────────

    nodejs
    typescript
    typescript-language-server
    pnpm
    bun

    # ─────────────────────────────────────────────
    # Databases
    # ─────────────────────────────────────────────

    postgresql
    sqlite

    # ─────────────────────────────────────────────
    # Containers
    # ─────────────────────────────────────────────

    podman
    podman-compose

    # ─────────────────────────────────────────────
    # Nix development
    # ─────────────────────────────────────────────

    direnv
    nix-direnv

    # ─────────────────────────────────────────────
    # Browser
    # ─────────────────────────────────────────────

    librewolf
  ];

  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;

      core.pager = "delta";

			delta = {
				navigate = true;
				side-by-side = true;
			};
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -lah";
      la = "eza -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
      update = "sudo nix flake update --flake /etc/nixos";
      clean = "sudo nix-collect-garbage -d";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      # LSP / formatting infrastructure
      lua-language-server
      nil
      nixpkgs-fmt

      # Web
      vscode-langservers-extracted

      # General
      ripgrep
      fd
    ];

    initLua = ''
      		-- ─────────────────────────────────────────────
      		-- General
      		-- ─────────────────────────────────────────────
      		vim.g.mapleader = " "

      		vim.opt.shiftwidth = 2
      		vim.opt.smartindent = true
      		vim.opt.number = true
      		vim.opt.relativenumber = true
      		vim.opt.tabstop = 2

      		vim.opt.termguicolors = true
      		vim.opt.signcolumn = "yes"
      		vim.opt.cursorline = true

      		vim.opt.ignorecase = true
      		vim.opt.smartcase = true

      		vim.opt.splitright = true
      		vim.opt.splitbelow = true

      		vim.opt.scrolloff = 8
      		vim.opt.updatetime = 250

      		vim.opt.clipboard = "unnamedplus"

      		-- ─────────────────────────────────────────────
      		-- Keymaps
      		-- ─────────────────────────────────────────────
      		vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
      		vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
      		vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>")

      		-- Better window navigation
      		vim.keymap.set("n", "<C-h>", "<C-w>h")
      		vim.keymap.set("n", "<C-j>", "<C-w>j")
      		vim.keymap.set("n", "<C-k>", "<C-w>k")
      		vim.keymap.set("n", "<C-l>", "<C-w>l")

      		-- Miscellaneous
      		vim.keymap.set("n", "<C-a>", "gg<S-v>G")
      		vim.keymap.set("n", "<leader>pv>", vim.cmd.Ex)

      		-- ─────────────────────────────────────────────
      		-- LSP
      		-- ─────────────────────────────────────────────
      		vim.api.nvim_create_autocmd("LspAttach", {
      			callback = function(event)
      				local opts = { buffer = event.buf }

      				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

      				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      				vim.keymap.set("n", "<leader>f", function()
      					vim.lsp.buf.format()
      				end, opts)
      			end,
      		})

      		-- Native LSP config
      		vim.lsp.config("lua_ls", {
      			cmd = { "lua-language-server" },
      			filetypes = { "lua" },
      		})

      		vim.lsp.config("nil_ls", {
      			cmd = { "nil" },
      			filetypes = { "nix" },
      		})

      		vim.lsp.config("ts_ls", {
      			cmd = { "typescript-language-server", "--stdio" },
      			filetypes = {
      				"javascript",
      				"javascriptreact",
      				"typescript",
      				"typescriptreact",
      			},
      		})

      		vim.lsp.enable({ "lua_ls", "nil_ls", "ts_ls" })

      		-- ─────────────────────────────────────────────
      		-- Diagnostics
      		-- ─────────────────────────────────────────────

      		vim.diagnostic.config({
      			virtual_text = true,
      			signs = true,
      			underline = true,
      			update_in_insert = false,
      			severity_sort = true,
      		})
    '';
  };
}
