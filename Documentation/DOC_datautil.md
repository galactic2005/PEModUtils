# datautil

## Usage

*datautil* is a module used to convert or handle data.

## Functions

### round(numberToRound:Number)

Rounds a number to the nearest whole number.

### color Class

#### color.getClientRGBFromStrum(strumNoteID:Integer, usePixelRGB:Boolean)

Returns a client's RGB preference from a specified strum line as a string hex value. Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.

`strumNoteID` should be any integer between 0-3.

#### color.getPixelColor(obj:String, x:Number, y:Number)

A version of `getPixelColor` that automatically converts variables using the other functions listed.

Refer to documenation of  `getPixelColor` for more information on this function.
