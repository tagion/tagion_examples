# Examples of how to use the tagion library

The examples can compiled and executed as follows.
```sh
make run
```
The help for the build can be displayed with:
```sh
make help
```
**Note: If "tagion not installed" then try to run `make all` or `make libtagion secp256k1`.**

The compile environment can be displayed by:
```sh
make env
```
The build can be erased with:
```sh
make clean
```
A complete clean-up can be done by:
```
make proper
```

The make script by default uses `dmd` compiler to change to `ldc2` just write.
```
# First clean the build
make proper
# Compile and run with ldc2
make DC=ldc2 run

```

Examples:
1. hibon_example.d
Sample code of how to create a HiBON record.
2. dart_example.d
Sample code of how to create a DART database.



