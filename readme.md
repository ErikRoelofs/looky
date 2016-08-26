This is a rendering engine inspired loosely by Android and built in Lua using Love2d.

Current status: Alpha.

Principles:

Just me and my kids: each view should ONLY know about itself and its direct kids. No further knowledge. No parent access. No idea where on the screen it is.
Total responsibility: each view has total responsibility for its child-views and has complete freedom to use them as it sees fit
A view is a view is a view: everything is a view, whether it's a built-in or custom or composite, and all act the same way