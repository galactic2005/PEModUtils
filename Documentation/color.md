# color

## Usage

*color* is a module used to manipulate colors.

## Functions

### getClientRGBFromStrum(strumNoteID: integer, usePixelRGB?: boolean = false)

Returns a client's RGB preference from a specified strum line as a string hex value. Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.

`strumNoteID` should be any integer between 0-`keyAmount - 1`. This means for 4 key/mania it'll be 0 to 3, with support for higher key-amounts being supported:

* 1 key/mania - 0
* 4 key/mania - 0 to 3
* 7 key/mania - 0 to 6

If `usePixelRGB` is true, it'll pull from the client's pixel RGB preference.

### getPixelColor(obj: string, x: number, y: number)

A version of `getPixelColor` that automatically converts variables using the other functions listed.

Refer to documenation of  `getPixelColor` for more information on this function.
