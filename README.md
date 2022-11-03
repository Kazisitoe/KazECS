# KazECS

## Documentation
*WIP*

``World`` - Singleton class that contains and manages all entities

``World:Query(...Components): EntityIterator`` - Returns an iterator function that iterates over every entity with the given components
``EntityIterator(): Number, ...Component`` (Entity Iterator)
``EntityIterator:Without(...Components): EntityIterator`` - Returns a near-identical iterator function that skips the given components
``World:QueryChanged(ChangedComponent, ...Components): EntityRecordIterator`` - Returns an iterator function that iterates over every entity with the given components that experienced a change with the first component provided
``EntityRecordIterator(): Number, {New: Component, Old:Component}`` (Entity Record Iterator)
``EntityRecordIterator:Without(...Components): EntityRecordIterator`` - Returns a near-identical iterator function that skips the given components

## Installation
### Method 1: Wally
This can be installed with [wally]('https://github.com/UpliftGames/wally') by adding it to the dependencies
```toml
[dependencies]
KazECS = "kazisitoe/kazecs@x.x.x" # Replace this with the current version, or just get it at the wally.run website
```

### Method 2: RBXM
The most up to date RBXM files for the library are [here]('https://github.com/Kazisitoe/KazECS/releases')
