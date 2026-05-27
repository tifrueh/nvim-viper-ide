# Viper IDE for Neovim

This is a [viperserver](https://github.com/viperproject/viperserver) client
implementation for Neovim.

For further documentation, see `doc/viper-ide.txt`.

## Note

This plugin is heavily inspired by
[viper.nvim](https://github.com/HSMF/viper.nvim/tree/main) by
@[HSMF](https://github.com/HSMF). The main differences are the following:

* `nvim-viper-ide` integrates directly with the LSP configuration mechanism of
  Neovim, while `viper.nvim` does not. The trade-off is that `nvim-viper-ide`
  has a longer startup time because ViperServer needs to be running before the
  client can be initialised.
* `nvim-viper-ide` has a help file. :)

## See Also

* [`viper-ide`](https://github.com/viperproject/viper-ide/tree/master): The
  official Viper IDE plugin for VS Code.
* [`viperserver`](https://github.com/viperproject/viperserver): The LSP server
  powering everything.
* [Viper Project](https://www.pm.inf.ethz.ch/research/viper.html): The official
  website of the Viper project.
