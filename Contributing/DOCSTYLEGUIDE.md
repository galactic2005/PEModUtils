# Documentation Style Guide

This style guide contains a list of guidelines to follow for PEModUtils to provide consistency across all Documentation.

## General

Here are some general guidelines to follow:

* Follow all [Markdown rules](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md) (except [MD013](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md#md013---line-length).)
* Use descriptive words and avoid foul language or slang.
* Do not abbreviate (for example, Psych Engine instead of PE.)
* Watch for typos.

Remember that documentation will be viewed by coders of all skill levels and types, so keep it easy-to-follow and easy-to-understand.

> It's understandable if an advanced topic isn't as easy-to-follow or understand as easier topics, but keeping this principal in mind will help you write better documentation.

## Structure

The structure of the document should always follow like this:

```markdown
# modulename

## Usage

## Dependencies

## Variables

## Functions

### function()

### function()
```

## Usage Section

The first paragraph should do the following:

* Tells what the module is named.
* Tells what it does in as few words as possible.

The name of the module in italics should be used as the first word of the paragraph, followed by a short description.

```markdown
*example* is a module used to give examples for documentation.
```

In the following paragraphs, provide information such as information regarding the module or links to helpful resources. Consider *haxeserialization*'s second paragraph:

```markdown
Refer to <https://haxe.org/manual/std-serialization.html> for more information on serialized data.
```

This link from <https://haxe.org> provides information about haxe's serialized data format. haxeserialization is about handling serialized data in this format, so the link is helpful for the reader.

### Disclaimers

Disclaimers should be a quoted paragraph at the end of the Usage Section.

```markdown
## Usage

*example* is a module used to give examples for documentation.

> We don't actually have a module called example.
```

## Dependencies Section

Dependencies should be listed in this section alongside their file path variable. Consider *mod*'s dependencies section:

```markdown
* [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home) - `dkJsonFilePath`
```

Each table element should be separated by one space. The variable should always be surrounded by single backticks.

## Variables Section

Variables that are given through the module should be listed here alongside their default value and description. Consider *file*'s variables section:

```markdown
* `mostRecentFileUsed = ''` - the most recent file used regardless of context.

* `mostRecentFileReadFrom = ''` - the most recent file read from.

* `mostRecentFileWrittenTo = ''` - the most recent file written to.
```

Each table element should be separated by one space. The variables and their default values should always be surrounded by single backticks.

## Functions Section

Every function is contained in a H3 header that contains the following:

* The function name.
* The function parameter names and types.
* What parameters are optional and their associated default values.

In each parameter, they're shown like this:

```markdown
parameterName: type
```

For optional parameters, they're shown like this:

```markdown
parameterName?: type = defaultValue
```

These ways of defining function parameters allow easy readability of the parameters, what types users should pass in, and whether the user can omit them or not. Consider this function from *listfile*:

```markdown
### read(filePath: string, startFromCurrentModDirectory?: boolean = true)
```

This tells us that:

* read has two parameters; one required and one optional.
* filePath needs to be a string.
* startFromCurrentModDirectory needs to be a boolean and can be optionally omitted. If it's omitted, it'll be true.

After the header, a description of the function and/or its parameters in the next paragraphs. Be sure to describe:

* What the function does.
* What it'll return (if any.)
* Any additional information (such as how to use it, or if spacial data needs to be passed in.)

Always use the word *return* when describing a function returning a value.

```markdown
<!-- Incorrect -->
Rounds a number to the nearest whole number.

<!-- Correct -->
Returns a number that's rounded to the nearest whole number.
```

## In-Code Documentation

When working in modules, every function and variable that gets passed into the module table must be documented. Documentation is created by using --- to denote a comment like so:

```lua
--- I'm a comment for documentation

-- I'm a regular comment
```

Placing a comment for documentation before a function or variable will allow users to view documenation by hovering over it (when applicable to the editor.)

```lua
--- True if we're Boyfriend from Friday Night Funkin'; else false
isBoyfriend

--- This is a test function that returns -1
function foo()
    return -1
end
```

You can also define in-code:

* What types parameters are and if they're optional.
* What type of data will be returned.
* If the function is depreciated.

The way you do that is through annotations. Below is an example with various annotations:

```lua
--- Comment
---
--- Continuation of comment.
---
--- ```lua
--- -- code in comment
--- ```
--- @deprecated
--- @param parameterOne string
--- @param parameterTwo? boolean
--- @return number
function foo(parameterOne, parameterTwo)
    return 0
end
```

For in-code comments, it's recommended to have no period on the first paragraph.

> For a full list of annotations, please visit <https://luals.github.io/wiki/annotations/>
