## This is a rendering engine inspired loosely by Android and built for Love2d.

### Current status: Alpha.

### Installation:
Put it in your project: 
    git clone git@github.com/ErikRoelofs/looky.git

Include it in your code: 
    looky = require "looky"

### Quickstart
There is a quickstart doc in the docs/ folder. You can also check the tutorial which explains the basics:        
    https://github.com/ErikRoelofs/looky-tutorial

### Principles
Looky is built on these 3 Principles. If you follow them, Looky should be kind to you.

* Just me and my kids: each view should ONLY know about itself and its direct kids. No further knowledge. No parent access. No idea where on the screen it is.
* Total responsibility: each view has total responsibility for its child-views and has complete freedom to use them as it sees fit.
* A view is a view is a view: everything is a view, whether it's a built-in or custom or composite, and all act the same way.