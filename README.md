### Change file ownership:

```
sudo chown -R marc:users rootfs/home/marc
```

### Ignore changes to file:

```
git update-index --assume-unchanged path/to/file
```

### List ignored files:

```
git ls-files -v | grep -e "^[hsmrck]"
```

### Track files again:

```
git update-index --no-assume-unchanged path/to/file
```
