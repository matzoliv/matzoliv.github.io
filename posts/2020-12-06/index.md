# Cartesian product of infinite sequences

While practicing for this year's [Advent Of
Code](https://adventofcode.com/), I wondered how to to compute the
cartesian product of infinite sequences. I tried to come up with a
solution myself, and as a solution matured in my head, I wanted to
put it both in words & in code.

## The problem with regular cartesian product methods

By generating a cartesian product lexicographically, you will get
"stuck" iterating through an infinite sequence, never picking any
other element from the other sequences. To illustrate, here's how
you would generate a cartesian product in lexicographic order :

```
Let N be the set of natural numbers

for x in N
    for y in N
        for z in N
            yield (x, y, z)
```

In this case, we would never leave the inner-most loop, leaving x
and y never changing value.

## And now, to the solution

Let the `rank` of a tuple be the maximum index of any of its element in
its originating sequence. Using our last example with natural numbers :

```
x ∈ N x N x N
x = (10, 30, 20)
rank( x ) = 30
```

because the second element is the 30th element of the natural numbers.

The idea consists of computing elements of the cartesian product
in increasing order of rank. To find elements of a given rank `n`,
we can "pin" some sequences to their nth element, and limit other sequences
to their `n - 1` first elements. Then a lexicographic cartesian product
function is used to generate a subset of the rank. To cover the entire
rank, we need to do this for all combinations of "pinned"
positions, which we can generate using, you guessed it, a lexicographic
cartesian product function.

I thought it was kind of clever (in a that-code-is-unreadable way,
I guess).

## Show me the code, please

Here's a commented implementation in clojure that you can try for
yourself :

```clojure
(ns inthedust.core
  (:require [clojure.math.combinatorics :refer [cartesian-product]]))

(defn cartesian-product-by-rank [& seqs-init]
  (let [gen-for-rank
        (fn [elems-at-rank rank]
          (->>
           ;; compute all the permutations of pinned / unpinned sequences
           (apply cartesian-product
                  (map (fn [elem-at-rank seq-init]
                         [(take rank seq-init) ;; unpinned sequence
                          [elem-at-rank]]) ;; pinned sequence
                       elems-at-rank
                       seqs-init))
           ;; drop the first combination of all unpinned sequences
           ;; which would lead to produce all elements of previous ranks.
           (rest)
           ;; use those as successive arguments to a cartesian product
           ;; and concatenate everything
           (mapcat (partial apply cartesian-product))))
        ;; iterate all ranks
        gen-all
        (fn gen-all [seqs rank]
          (and (some seq seqs)
               (cons (gen-for-rank (map first seqs) rank)
                     (lazy-seq (gen-all (map rest seqs) (inc rank))))))]
    (cons
     ;; the very first element
     (vec (map first seqs-init))
     ;; plus the concatenation of all ranks
     (apply concat (gen-all (map rest seqs-init) 1)))))
```