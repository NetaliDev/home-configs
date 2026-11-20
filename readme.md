# Jennys home manager configurations

Some general parts of my home manager configurations. Feel free to use them as you want.

This repo currently includes:
  - `homeConfigs.vim`: My neovim configuration, which makes it look like VSCode
  - `homeConfigs.zsh`: My very basic zsh config

## Neovim configuration structure

`configs/vim.nix` declares plugins, tools and Vimscript options. Home Manager
links the Lua files from `configs/neovim/` into `~/.config/nvim/lua/`.
`configuration.lua` loads the modules in order:

- `editor-settings.lua`: general editor autocommands
- `buffer-management.lua`: Barbar buffer bar and buffer shortcuts
- `terminal-settings.lua`: ToggleTerm
- `appearance.lua`: icons and Dracula theme
- `file-tree.lua`: file explorer
- `completion.lua`: completion and snippets; supplies the LSP capabilities
- `language-servers.lua`: Python, Nix, PHP, LaTeX and Rust servers, shared LSP
  shortcuts, and loading `go-development.lua` with the completion capabilities

## Go development in Neovim

The Neovim module installs Go, gopls and Delve, Go snippets, Tree-sitter
parsers for Go/module/workspace files, Neotest and a debugger UI through Nix.
Apply your Home Manager configuration as usual (`home-manager switch`, or
`sudo nixos-rebuild switch --flake …` when using the NixOS integration below).
Open a `.go` file in a project with a `go.mod` or `go.work`; gopls starts
automatically. Neovim 0.11 or newer is required by the existing LSP setup.

Completion includes unimported packages and snippets (`Ctrl-Space`, `Tab`,
`Shift-Tab`, `Enter`). Saving a Go file organizes imports and formats it
synchronously through gopls. Diagnostics include Staticcheck analyses.
Go buffers use tabs with a display width of four.

The existing LSP shortcuts also work for Go: `gd` for definition, `gr` for
references, `K` for documentation, `Space rn` for rename, `Space ca` for code
actions (for example, generating implementations), and `Space e` for diagnostic
details. `Space f` formats manually.

| Shortcut | Action |
| --- | --- |
| `Space gb` / `:GoBuild` | Build all packages in the current module |
| `Space gr` / `:GoRun` | Run the package containing the current file |
| `Space gv` / `:GoVet` | Run `go vet ./...` in the current module |
| `Space gc` / `:GoCoverage` | Show test coverage per package in a terminal |
| `:GoModTidy` | Update the current module's dependencies |
| `Space tn` / `Space tf` | Run the nearest test / tests in the current file |
| `Space ts` | Run the module's tests recursively with Neotest |
| `Space tl` / `Space tx` | Repeat the last test run / stop tests |
| `Space tt` / `Space to` | Toggle test summary / open test output |
| `:GoTestSuite` | Run `go test -count=1 ./...` in a terminal |
| `F5` | Start debugging / continue; select a launch or attach configuration |
| `F10` / `F11` / `F12` | Step over / into / out |
| `Space db` / `Space dB` | Toggle a breakpoint / set a conditional breakpoint |
| `Space dt` | Debug the nearest Go test |
| `Space du` / `Space de` / `Space dq` | Toggle debugger UI / evaluate / terminate |

Go and test shortcuts are buffer-local to Go files; debugger shortcuts are
global so they also work inside the debugger UI. Commands and new test runs
save the current buffer first. Save any other edited files before building or
testing. Terminal output stays open after a command finishes.

Commands find the nearest `go.mod` independently of Neovim's working directory.
In a workspace with multiple modules, build/test/vet/tidy target the current
module; repeat for other modules as needed. `GoRun` runs the current package,
which must be a `main` package. The terminal (`Alt-Space`) is also available for
custom arguments, `go generate`, benchmarks, or `go test -race ./...`.
Projects using CGO need their C compiler and native libraries in the project
environment (for example, via `nix develop`); start Neovim from that environment.

The save hook follows the [gopls Neovim guidance](https://go.dev/gopls/editor/vim#imports-and-formatting).
See also [Neotest Go](https://github.com/nvim-neotest/neotest-go) and
[nvim-dap-go](https://github.com/leoluz/nvim-dap-go) for test and debugger details.

## Usage example
```
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    netali-home-configs.url = "github:netalidev/home-configs";
    netali-home-configs.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, netali-home-configs, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jdoe = {
              imports = [
                ./home.nix
                netali-home-configs.homeConfigs.vim
              ];
            };
          }
        ];
      };
    };
  };
}
```
