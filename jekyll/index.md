---
layout: post
title: Home
---

Content

## Heading 2

More content

### Heading 3

And yet more content.

> This is a block quote

<blockquote class="random-class-goes-here" id="random-id-goes-here">And the block quote processor doesn't break this</blockquote>
<blockquote id="random-id-goes-here">Or this</blockquote>

| Column A    | Column B    | Column C    | Column D    | Column E    |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| Entry 1     | Entry 2     | Entry 3     | Entry 4     | Entry 5     |
| Entry 6     | Entry 7     | Entry 8     | Entry 9     | Entry 10    |

Text can be **bold** or *italic* or ~~strikethrough~~ or `code`.

```
We can have code blocks!
```

And more code blocks:

```java
@SomeAnnotation
public class SomeClass {
    public SomeClass(int i) {}
}
```

Sticking HTML escapes in code blocks won't break stuff:
```html
<h1>Stuff</h1>
<blockquote>More stuff</blockquote>
```

> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

Do footnotes work?

Here is a simple footnote[^1].

[^1]: My reference.

We can insert horizontal rules:

------------------------------------------

We can have lists:

* A
* B
    * C

1. A
2. B
3. C
    4. D

{% details Expand summary %}
To see contents
{% enddetails %}

{% details With a code block %}
```java
public record Foo() {}
```
{% enddetails %}

{% details With a code block and other text %}
Text goes here

```java
public record Foo() {}
```

And here
{% enddetails %}

{% details With a code block then text %}
```java
public record Foo() {}
```

Text here
{% enddetails %}

{% details With a table %}
| Column A    | Column B    |
| ----------- | ----------- |
| Entry 1     | Entry 3     |
| Entry 2     | Entry 4     |
{% enddetails %}

{% details With a wide table %}
| Column A    | Column B    | Column C    | Column D    | Column E    |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| Entry 1     | Entry 2     | Entry 3     | Entry 4     | Entry 5     |
| Entry 6     | Entry 7     | Entry 8     | Entry 9     | Entry 10    |
{% enddetails %}
