# Neovim

This is a LazyVim-based configuration managed by Home Manager and linked into
`~/.config/nvim`.

## Structure

- `nvim/init.lua`: bootstrap entrypoint
- `nvim/lua/config`: core LazyVim options, keymaps, and setup
- `nvim/lua/plugins`: local plugin specs and overrides
- `nvim/lazyvim.json`: enabled LazyVim extras

## Apply Changes

Run:

```bash
sudo darwin-rebuild switch --flake .#erxis-macbook-pro
```

## Notes

- `lazy-lock.json` pins plugin revisions.
- API keys and other secrets should stay outside this repo.
