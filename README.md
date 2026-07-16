# homebrew-cleverswitch

A [Homebrew](https://brew.sh) tap for [CleverSwitch](https://github.com/MikalaiBarysevich/CleverSwitch) — a headless daemon that synchronizes Logitech Easy-Switch host switching between a keyboard and mouse.

> macOS only.

## Install

```bash
brew install MikalaiBarysevich/cleverswitch/cleverswitch
```

or:

```bash
brew tap MikalaiBarysevich/cleverswitch
brew install cleverswitch
```

## Run at login

```bash
brew services start cleverswitch
```

Logs are written to `$(brew --prefix)/var/log/cleverswitch.log`.

## Input Monitoring permission

On first run, macOS prompts for **Input Monitoring** permission. If no prompt appears, grant it manually in **System Settings → Privacy & Security → Input Monitoring**, adding the installed binary:

```bash
brew --prefix cleverswitch   # then append /bin/cleverswitch to that path
```

## Configuration

CleverSwitch reads `~/.config/cleverswitch/config.yaml`. See the [main project README](https://github.com/MikalaiBarysevich/CleverSwitch#configuration) for the config and hook reference.

## Maintaining this tap

On each CleverSwitch release, bump `url` in `Formula/cleverswitch.rb` to the new tag, then regenerate its `sha256`:

```bash
curl -sL https://github.com/MikalaiBarysevich/CleverSwitch/archive/refs/tags/v1.4.2.tar.gz | shasum -a 256
```

Then regenerate the Python resource stanzas **on a Mac**:

```bash
brew install pipgrip
brew update-python-resources Formula/cleverswitch.rb
brew audit --new --formula cleverswitch
brew install --build-from-source ./Formula/cleverswitch.rb
```
