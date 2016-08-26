## QUICKSTART GUIDE

### WHAT IS IT?

Looky is a library that allows you to create and render views to the screen. It helps you organize and re-use the various visible parts of your game, as well as easily make changes to all the styles within it. Looky comes with a bunch of prebuilt views that will help you quickly get started with prototyping gameplay, while also allowing you to later add some custom, final style to your game without having to restart from scratch.

Looky also tries to not force you into using basic components, but gives you the freedom to build the views you need, because it understands that games often aim to be unique, and have very different requirements from traditional business applications.

### INSTALLATION
To install Looky, first clone or download the repository into your project and put it in a subfolder 'looky'.

To clone it with git, run the following command:

    git clone git@github.com:ErikRoelofs/looky.git

    
To download it, go to the following webpage and click the "download" button:

    https://github.com/ErikRoelofs/looky.git

Next, you will have to create the module. To do so, add the following code to your love.load function:

    looky = require "looky"
    
This will give you an instance of Looky with all the default views described in this documentation.

### HOW TO BUILD A LAYOUT

Layouts are built by calling the "build" method on Looky and passing it a name and some options. Exact options can be found in the reference.

    looky:build("text", { width = 100, height = 50, data = function() return "Text to write" end })
    
New layouts can be registered by calling the registerLayout function with a name and a table containing the new layout's build method and its schema.

    looky:registerLayout("layoutName", { build = function(lc) return <YourBuiltViewHere> end, schema = { <YourSchemaHere> }})
  
You can modify layouts with styles by registering a new styled layout on top of another one and passing it the default options. You can also re-modify registered styled layouts this way.

    looky:registerStyledLayout("new.text", "text", { height = 100, font = "CoolFont", color = { 120, 200, 140, 255 }})
    looky:build("new.text", { width = 200, data = function() return "COOL" end })
  
You can register fonts for use with the registerFont function.

    looky:registerFont("someFont", love.graphics.newFont("myfont.fnt", 25))
  
Some views can have children, which are manipulated with the child functions.

    ContainerView:addChild(someChild)
    ContainerView:removeChild(someChild)
  
You usually start with a root view, which is the size of your whole screen. All your other views are children of that root, or children of other children. Before you can render a view, it must have its dimensions set by having layoutingPass() called on it. The layoutingPass function will also call itself on any children, so usually you only need to call it once on root.

    root = Looky:build("root")
    root:layoutingPass()
  
To render views; call the render method. This will draw the view and also all its children.

    love.draw = function()
      root:render()
    end
  
To update the contents of a view, you might have to call the update method. This will also update all children.

    love.update = function(dt)
      root:update(dt)
    end

### Available view types:

The following base views are available. You can find them in the layouts/ folder, you can also check their schema there.

  * 4pane: has a background view and four optional views that go into the 4 corners of the screen. Simple base setup for some arcade-like games.
  * aquarium: allows you to add many children, which can be positioned anywhere on the view by setting their offset
  * dragbox: allows you to add a single child, which can be positioned at any offset
  * empty: allows you to add empty space
  * filler: allows a single child, is used to add space around that child (for example, to center it within a larger view) Includes a set of quickwrappers such as "filler.topleft" to quickly position the child in the top-left of its larger parent
  * freeform: a simple view that allows you to specify a custom render and update function
  * grid: a grid type view; allows a set number of rows and columns worth of views, all the same size
  * image: an image view; displays an image of some sort
  * linear: a container view that puts its children in a line, either horizontally or vertically
  * list: a simple list view; allows an array of strings that it will write
  * numberAsBar: a simple health-bar or the like; displays a number like a length of line
  * numberAsImage: repeats an image a number of times based on a value; like having 4 hearts while you have 4 life
  * root: the basic root element; always as big as your screen. behaves like a linear-view
  * slotted: a view that allows you to specify fixed-size named slots, and then put children in each named slot
  * stack: a container view that puts all its children on top of each other. useful for dialogs, or stacking cards
  * stackroot: the other basic root element; also as big as your screen, but this one behaves like a stack-view
  * text: a view that writes a piece of text