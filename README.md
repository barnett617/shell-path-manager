# Shell Path Manager

spm (which is short for Shell Path Manager) is a simple small tool to make shell path management more simple and intuitive.

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/barnett617/shell-path-manager/main/tools/install.sh | bash
```

## Usage

### spm list

```shell
spm list
```

This will list all your exist binary paths clearly in lines.(Compare to `echo $PATH` which results a long string)

### spm check

```shell
spm check
```

This will list all the paths created by spm, it will show paths in key=value pairs so that you can get the key to remove a path.

### spm add

```shell
spm add go=/Users/mac/go/bin
```

This will help you append the new path to exist PATH and add a record in ~/.spm/record which make this path unique. Then it will source your ~/.zshrc to make it work right away.

> spm will first check whether the new path already exists in PATH, if it exists, it will not be added repeatly with a warning output.

### spm remove

```shell
spm remove go
```

> This will first get path from ~/.spm/record with the key, then delete the path from PATH. It will also source ~/.zshrc for you in order to prevent using relevant binary anymore.

## Uninstallation

```shell
spm uninstall
```

> This make spm to self destory then remove its binary path from PATH.

Or you can use remote script to uninstall if your local spm doesn't work correctly.

```sh
curl -fsSL https://raw.githubusercontent.com/barnett617/shell-path-manager/main/tools/uninstall.sh | bash
```

This will remove all files about spm(actually just a single folder ~/.spm) but won't update your PATH changes because spm is just a path manager tool to help you adding path and make it work more convenient. 

Your PATH is still your PATH with or without it, it won't break your binary paths after you stopping using spm.

> Except the paths you removed using spm, because spm will actually manipulate your PATH while adding or removing.

## How it works

### Installing

It will download a shell script and create a .spm folder in your user home including below files:

| File         | What for                                                                        |
| :----------- | :------------------------------------------------------------------------------ |
| .spm/bin/spm | The binary for executing from anywhere to use spm                               |
| .spm/record  | A text file to store each binary path's key in order to simplify a path removal |

That's it.

### List exist paths

```
echo "$PATH" | tr ':' '\n'
```

### List spm managed paths

```
cat ~/.spm/record
```

This is just list your PATH in a more friendly way.

### Adding a new path

spm requires a key=value pair for adding a new path, the key is used for quick deletion, and the value is the path which will be appended to your PATH.

### Remove a path

spm use a ~/.spm/record to store the record of each path so it can conveniently remove a path with just a key.

> Paths installed before using spm can't be removed by specific a name, because there is no such key for the path to retrieve.

### Uninstalling

It's just to remove of the ~/.spm folder, that's all the things spm works with. Then it will remove the spm binary from your PATH.

## File Structure

```
.spm
├── bin
│   └── spm
└── record
```

## Acknowledgement

Thanks for these projects for inspiring me:

- https://github.com/ohmyzsh/ohmyzsh
- https://github.com/nvm-sh/nvm
- https://github.com/oven-sh/bun
- https://github.com/Homebrew/homebrew-core
