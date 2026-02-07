---
layout: post
title: Codeforces 2162C -  Asymptotic and practical improvement over editorial
date: 2025-02-07 03:33:00-0400
description: bit tricks to get a constant time solution
tags: cpp c++ codeforces algorithms
categories: codeforces
giscus_comments: false
related_posts: false
---

[Codeforces Problem 2162C](https://codeforces.com/problemset/problem/2162/C) reads as follows:

---

You are given two integers $$a$$ and $$b$$. You are allowed to perform the following operation any number of times (including zero):

- choose any integer $$x$$ such that $$0\le x\le a$$ (the current value of $$a$$, not initial),
- set $$a:=a \oplus x$$. Here, $$\oplus$$ represents the bitwise XOR operator.

After performing a sequence of operations, you want the value of $$a$$ to become exactly $$b$$.

Find a sequence of at most 100 operations (values of $$x$$ used in each operation) that transforms $$a$$ into $$b$$, or report that it is impossible.

---

The rest of this post will discuss solutions to this problem, so attempt the problem before reading ahead, if you'd like to.

The proposed [editorial solution](https://codeforces.com/blog/entry/147242), courtesy of user [wakanda-forever](https://codeforces.com/profile/wakanda-forever), involves iterating over each bit of $$a$$ and setting that bit of $$x$$ to high, and then unsetting bits in $$b$$ which are low. This guarantees a solution in fewer than 60 operations (due to the size constraints on $$a$$ and $$b$$). Since we are iterating over the bits, the author claims a complexity of $$O(\log_2(a))$$ (I normally see complexity implicitly be in terms of the size of the binary representation of inputs, so I would've said $$O(a)$$). The solution I'll present below is $$O(1)$$ and guarantees a solution in 2 or fewer operations.


Immediately, we realise that if $$\text{msb}(a) < \text{msb}(b)$$, then we cannot make $$b$$ from XORing $$a$$ with $$x$$, since $$x \le a$$ implies $$\text{msb}(x)\le \text{msb}(a)< \text{msb}(b)$$, and so we can never set the highest bit(s) of $$b$$. So if we have $$\text{msb}(a) < \text{msb}(b)$$, we can early return with `-1`. Otherwise, we know that $$\text{msb}(b) \le \text{msb}(a)$$.

Our goal is to find $$x$$ such that $$a \oplus x = b$$. We can use the cool property of XOR being that it is its own inverse, so from;

$$
a \oplus x = b
$$

we have;

$$
x = a \oplus b
$$

but let's convince ourselves. Applying $$a\oplus\cdot$$ to both sides;

$$
a \oplus (a \oplus x) = a\oplus (b)
$$

Since XOR is associative, we have;

$$
(a \oplus a) \oplus x = a \oplus (b)
$$

and the XOR of any $$y$$ with itself is 0, so from the above we have;

$$
0 \oplus x = a \oplus (b)
$$

...and the XOR of any $$z$$ with 0 is just $$z$$, so;

$$
x = a\oplus b
$$

So setting $$x = a \oplus b$$ will give us $$a\otimes x = b$$.

But there is a catch: this $$x$$ is not always valid. Consider $$a = 9, b = 6$$ gives us $$x = 15$$, which checks out: $$9 \oplus 15 = 6$$, but does not fit the other constraint of $$x \le a$$.

Luckily, we only have two cases to deal with:

**Case 1**: $$x \le a$$

We can solve in single operation: $$x$$.

**Case 2**: $$a < x$$

We know that $$\text{msb}(x)\le \text{msb}(a)$$ from above, but since $$a < x$$, we have the stronger condition of $$\text{msb}(x) = \text{msb}(a)$$[^1].

Let $$x'$$ be $$x$$ with its most significant bit set low, i.e. $$x' = x\ \&\ \lnot\text{msb}(x)$$ [^2], equivalently $$\text{msb}(x) \mathbin{\&} x' = x$$.

And since $$\text{msb}(x') < \text{msb}(x) \le \text{msb}(a)$$, we have $$x' < a$$ and $$\text{msb}(x) = \text{msb}(a) \le a$$, meaning we can return a vector of $$\{ \text{msb}(x), x'  \}$$ as our solution.

> We have proved that we never need more than 2 operations to solve the problem.

We can implement this in C++ with bit manipulation. I use a typedef of `num = uint64_t` in the snippets below.

To check whether $$\text{msb}(a) < \text{msb}(b)$$ and whether the problem is solvable, we use compiler intrinsics to "count leading zeros" of $$a$$ and $$b$$:

~~~null
if (__builtin_clzll(b) < __builtin_clzll(a)) {
    return {"-1"};
}
~~~

we then compute our $$x$$;

~~~null
num x = a ^ b;
~~~

check whether we can solve in a single operation;

~~~null
if (x <= a) {
    string out = "1\n" + to_string(x);
    return out;
}
~~~

use some more bit tricks to compute our $$x'$$, and then return our two operations;

~~~null
// get the msb of x
num msbit = 1ull << ((sizeof(num) * 8 - __builtin_clzll(x)) - 1);
// remove the msb from x to get x'
x ^= msbit;

string out = "2\n" + to_string(x) + ' ' + to_string(msbit);
return out;
~~~

The complete solution, with an initial check for trivial test cases, is:

~~~null
using namespace std;
using num = uint64_t;

string solve(num a, num b) {
    if (a == b) {
        return {"0"};
    }
    // if b has bits set high that are more significant than a's MSB, then we
    // can never set those high
    if (__builtin_clzll(b) < __builtin_clzll(a)) {
        return {"-1"};
    }

    // get our single x
    num x = a ^ b;

    // if we can do it in one
    if (x <= a) {
        string out = "1\n" + to_string(x);
        return out;
    }

    // get the msb of x
    num msbit = 1ull << ((sizeof(num) * 8 - __builtin_clzll(x)) - 1);
    // remove the msb from x to get x'
    x ^= msbit;

    string out = "2\n" + to_string(x) + ' ' + to_string(msbit);
    return out;
}
~~~

Not only is this solution $$O(1)$$, but it is almost entirely bitwise operations and intrinsics, meaning it's kind to the CPU. Ignoring constructing and returning the strings (only needed for codeforces I/O), `clang` generates fewer than 26 instructions to compute the answer ([godbolt](https://godbolt.org/z/f9bzajTeb)).

# Footnotes
[^1]: Because $$y < z \implies \text{msb}(y) \le\text{msb}(z)$$
[^2]: I'm using $$\text{msb}(y)$$ to be the binary representation of $$y$$ with all bits other than its most significant set low, e.g. $$y = 5 = 0101$$ would give $$\text{msb}(y) = 4 = 0100$$.
