# GNU parallel in much fewer lines of bash

### _TL;DR Full shell script here : [parallel.sh](https://github.com/oliviermatz/parallel.sh/blob/main/parallel.sh)_

Let's say you have a large number of wav files that you want to encode.
Chances are your computer has more than one core, so you want to process
more than one file at a time. On the other hand, spawning one
process for each file might overwhelm your computer. Using the shell, how do you
process a set of items using a target number of parallel workers ?

Sure, you can use [GNU parallel](https://www.gnu.org/software/parallel/), but
surely there must be straightforward way to implement it ourselves, right ?
Well, yes, and here is a step by step description of a possible implementation.

## Implementation

Spawn a fixed set of shell jobs that share the same file as their standard input.
We'll use this file as queue of work item to process.

```
for i in $(seq $worker_count)
do
    spawn_worker &
done <&0
```

Each worker reads a line, give it as parameter to the command, and loops until the end of the input.

```
spawn_worker() {
    next_item=$(read_next)

    while [ -n "$next_item" ]; do
        $task "$next_item" < /dev/null
        next_item=$(read_next)
    done
}
```

The tricky part is to make sure that workers read lines from the
shared standard input _transactionally_ (i.e. readers stepping on
each others toes might read partial or mangled lines). To achieve
that, we serialize reading from the input using flock around a temporary file.

```
read_next() {
    (
        flock -x 200
        read line
        echo $line
    ) 200> $lock_file
}
```

The complete solution can be bundled in a 30 lines [shell script](https://github.com/oliviermatz/parallel.sh/blob/main/parallel.sh)
that can be used like this :

```
# find . -name '*.wav' | parallel.sh 3 oggenc
```
