# Remote Console

  Remote console for debugging JS on mobile browser

## Installation

    $ component install ovaxio/remoteConsole

## Example

	```js
var remoteConsole, options;

RemoteConsole = require('remoteConsole');

options = {
  server : "http://localhost:8000",
  method : "post",
  headers : {
    'Content-Type': 'application/json',
    'Content-Language': 'fr'
  }
};

remoteConsole = new RemoteConsole(options);

throw new Error("ops!! You made a mistake");
```
