==TUTORIAL==

In this tutorial, we are going to make a very simple "game" where you can fly a spaceship around a field of stars. The guide assumes you already are somewhat familiar with löve and have Looky installed.

First, we are going to setup the basic layout that we will use. It will consist of a few components that we want to identify:

- There will be a main screen, which will have the ship you can fly with
- There will be a HUD at the bottom, containing a game-clock and the current speed

The first thing we need to do, is set up a "root". The root is the base view for our Looky setup, and will contain all the components of our game screen. Since we want to have our main screen at the top, and our HUD at the bottom, we want a root that will display all its children under one another, in the vertical direction. The root will automatically fill up the whole screen.

So let's start by creating the root in the love.load function, after we've initialized Looky:

    rootView = looky:build("root", { direction = "v" })
    
We'll see this "build" method a lot, as it is the only way Looky creates new views for you to use. The first argument is the name of the view-type we want; the second is the options passed. In this sample, we want to build a "root" and we set it's direction to v(ertical) so that if it has multiple children, they will be rendered under each other.

Next, we identified that we have a main screen to play in. The main screen will contain our ship and a background with some stars. Since obviously no such view exists in the base set, we will need to create one. Fortunately, there is a base view that simply allows you to specify your own drawing function. In this situation, that will be the easiest way to get what we want. Let's set up an empty rendering function and then make one of those.

    renderGameScreen = function() end
    gameScreenView = looky:build("freeform", { width = "fill", height = "fill", render = renderGameScreen })
    
Note how we have to set a width and a height for this view. While root is of fixed size, all other views need to specify their size. In this case we're setting the value to "fill" which means "as big as possible". This will cause the view to expand until it fills up the whole parent.

The next thing we need, is the bottom HUD. This contains multiple items, which means we need a container type view that can have multiple children of its own. Since the various control options will be aligned horizontally, we will need a container that aligns items horizontally. We also give it a background, so you can see it later.
Looky comes with the "linear" view, which puts all its children next to each other, either horizontally or vertically. (If you think this sounds a lot like what "root" does, you would be correct. Root is a special type of "linear" view)
Now, let's make the bottom HUD container.

    HUDView = looky:build("linear", { width = "fill", height = 100, direction = "h", background = { 20, 20, 20, 255 } })
    
Here, the height is fixed to 100 pixels. When we build this layout, the root will have two children. Children whose layout has a fixed size get priority, while those who want to "fill" get whichever room is left. The result will be that the bottom 100 pixels will be our HUD and the rest of the screen will be the main game screen.

Next, we'll need the game clock, which will go in the HUD on the left side. Here, we want to draw some text to the screen, so we need to make an instance of the aptly named "text" view. It will need to be provided with a function that returns what to print. It also needs a font and a text color. For now, we'll use the default font and color (which is white).

    seconds = 0
    clockView = looky:build("text", { width = "fill", height = "fill", data = function() return math.floor(seconds) .. "s" end, gravity = {"center", "center"} })
    
Now the clock will return the number of (whole) seconds with the letter 's' at the end. The gravity property causes the text to be rendered in the center of the view. However, the clock won't run yet. In order to make it run, we'll have to update the value of the seconds variwable, which we can do in the love.update function:

    love.update = function(dt)
      seconds = seconds + dt
    end
    
This shows a bit of the basic architecture ideas of Looky, too. Note how seconds is not located in the view. It's something that's coming from your game-state, not the view, and so the variable is not a part of the view. Generally speaking, you want to build a working game model and then have views that show it to the player, not a working view and then being forced to talk to the view to get the gamestate data you need.

Next item on the list is the speed gauge. For this one, we'll use a bar. We will need to define a player model which holds the current and maximum speed, and then create a numberAsBar view to render the speed. While we're at it, we'll also add the current position and rotation to the player's model, since we'll need it soon anyway.

    player = {
      x = 200,
      y = 200,
      rotation = 0,
      speed = 0,
      maxSpeed = 300
    }
    
    speedView = looky:build("numberAsBar", { width = "fill", height = 20, gravity = { "center", "center" }, value = function() return player.speed end, maxValue = player.maxSpeed, filledColor = { 100, 150, 30, 255 } })    
    
Now, we have all the basic views for our layout. But we don't actually have anything on the screen yet, because the viwes have not been connected and the root is not being rendered. To finish it up, let's connect the views and tell Looky to draw to the screen.

First, the two HUD views need to be children of the HUD. They will be shown horizontally, left to right, so we put the clock first.

    HUDView:addChild(clockView)
    HUDView:addChild(speedView)
    
Next, we add the main screen and the HUD to the root.

    rootView:addChild(gameScreenView)
    rootView:addChild(HUDView)
    
This gives us the basic view tree that we need to draw. Two things remain. Firstly; we need to tell the tree that it needs to determine the final size of each item. After all; we have set a number of components to be "as big as possible", but we haven't calculated how big that is yet. Now that all the views are connected, we can let the system do the calculations.
Call the layoutingPass method on the root view, and it will determine sizes for all its children, who will in turn determine sizes for their children, etc.

    rootView:layoutingPass()
    
You always need to call the layoutingPass function before trying to draw a root, but you only need to call it again if you change the game's basic layout.

That only leaves us with the last step, which is to actually render the root view. Let's add a line to our love.draw for that:

    love.draw = function()
      rootView:render()
    end

Now, if you run the program you should see... well, not very much honestly. The speed is zero so you can't see the speed bar; nothing is rendered in the main screen. Only the clock will be ticking in the HUD, but it will not look very flashy.
Let's render the actual ship to the screen. Make an images folder, take the "ship.png" from the assets folder and update your code to draw the ship:

    -- load the ship in your love.load
    shipImage = love.graphics.newImage("images/ship.png")

    -- add some content to renderGameScreen function
    function renderGameScreen()
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(shipImage, player.x, player.y, player.rotation, 1, 1, shipImage:getWidth() / 2, shipImage:getHeight() / 2)
    end

Because all Views in Looky have a localized coordinate system, it doesn't really matter where on the screen your View is rendered; the ship will be put x,y away from the top-left corner of the view you are rendering it in. Now, if we run the program again, we should see the ship rendered somewhere near the top-left corner (since starting coordinates are 200,200)

The next step then is to make the ship move. Because inputs are done against the game-model, this has nothing to do with Looky. We can simply add some code that reacts to key-presses and updates the coordinates, speed and rotation of the ship and the screen will reflect those changes. So the following block of code you can just paste into the love.update function, under the clock update.

    if love.keyboard.isDown("w") then
      player.speed = player.speed + 150 * dt
    end
    if love.keyboard.isDown("s") then
      player.speed = player.speed - 150 * dt
    end
    if love.keyboard.isDown("d") then
      player.rotation = player.rotation + 2 * dt
    end
    if love.keyboard.isDown("a") then
      player.rotation = player.rotation - 2 * dt      
    end
    
    player.speed = player.speed - ( player.speed * 0.4 * dt )
    
    if player.speed > player.maxSpeed then
      player.speed = player.maxSpeed
    end
    if player.speed < 0 then
      player.speed = 0
    end

    player.x = player.x + (player.speed * dt) * math.sin(player.rotation)
    player.y = player.y + (player.speed * dt) * (math.cos(player.rotation)*-1)

You can take my word for it that this works, or read it over to see what it does. It will allow you to move the ship using the wasd keys. Feel free to give it a try; it should work now. You'll also see the speed-gauge working now.

So we did what we set out to do; but of course it looks rather dreadful right now. Fortunately, Looky lets us redesign and modify existing views with ease. Let's add a little bit more prettyness to it. First; the main screen should have a border and a background.

We can add the following options to the creation of our main screen to set a background and border for it. The background is in the docs/assets folder as "background.png".

  background = { file = "images/background.png", fill = "fill" }, padding = looky.padding(5), border = { thickness = 5, color = { 60, 60, 60, 250 }  }
 
So the final View result will look like this:

  gameScreenView = looky:build("freeform", { width = "fill", height = "fill", render = renderGameScreen, background = { file = "images/background.png", fill = "fill" }, padding = looky.padding(5), border = { thickness = 5, color = { 60, 60, 60, 250 }  } })
  
Looky will automatically load the image for the background. If you want to re-use the image, it's better to load it yourself (once) and pass the variable to all the Views using that background. Both a filename and an actual image resource will work. The border property will assing a border to the view. The padding property will clean up a bit of space at the edges of the view to draw the border in; if you don't set this padding then it will look the same but the ship will be able to fly over the border.

We also want to upgrade the speed gauge. Right now, it is not clear at all that the bar is supposed to be speed and nothing is visible when the ship does not move. We'll add a handy title above the bar, as well as an icon before the gauge. While we're add it, we'll also add a background color and some notches on the bar.
Since this is a more serious modification, it's best if we start by registering a new type of view to use here, and put all of our work in there.
At the the of the page, we will define a new type of view. It needs to have a build method so we can create the instance, and then it needs a schema. For now, we'll leave the schema empty as we'll only have one instance of the view.

    speedGaugeType = {
      build = function(looky, options)
      
      end,
      schema = {}
    }
    looky:registerLayout("speedGauge", speedGaugeType)
    
The next step is to create the actual build function. Since the goal is an image on the left, and then a bar with a title on the right, we'll need some containers. We start by setting up a horizontal container. That will hold 2 children: an image (of a speedometer) and a second, vertical container. That vertical container also holds 2 children: a title and then our old speed gauge.

    build = function(options)
      local mainContainerView = looky:build("linear", { width = "fill", height = "fill", direction = "h" })
      mainContainerView:addChild( looky:build( "image", { width = "wrap", height = "wrap", file = "docs/assets/speedometer.png" }))
      
      local secondContainerView = looky:build("linear", { width = "fill", height = "fill", direction = "v" })
      secondContainerView:addChild( looky:build("text", { width = "fill", height = "fill", data = function() return "Speed:" end, gravity = { "center", "center" } }))
      local speedView = looky:build("numberAsBar", { width = "fill", height = 40, gravity = { "center", "center" }, value = function() return player.speed end, maxValue = player.maxSpeed, filledColor = { 100, 150, 30, 255 } })          
      secondContainerView:addChild(speedView)
      
      mainContainerView:addChild(secondContainerView)      
      return mainContainerView
    end,

That's all we need to do to allow us to use our new type of view wherever we want. So let's put it where we had the other speed gauge before. Replace the old declaration of speedView with this one:

    speedView = looky:build("speedGauge")
    
Now if you run the game, you should see a title, the image and our old bar. It's a start. The text label is rather small though, and the same can be said for the clock. We can override the default text-view with a styled version that writes text larger, and maybe in a prettier font. Take the font from the assets folder, put it in a folder called "fonts", and let's register it:

    looky:registerFont( "space", love.graphics.newFont( "fonts/Roboto-Bold.ttf", 30 ))
    
And then, register a styled version of the text-view. We'll add our font, and we'll center the text by default since that looks better. We'll also give it a bit of color and a background.

    looky:registerStyledLayout("new.text", "text", { font = "space", gravity = { "center", "center" }, textColor = { 180, 180, 60, 255 }, background = { 20, 20, 20, 255 } })
    
We will have to replace the instances where we were using the old text, to use the new one. Update both of the "text" views to now use "new.text". Remove the gravity option, since that's now default.

    -- update the speed gauge title
    secondContainerView:addChild( looky:build("new.text", { width = "fill", height = "fill", data = function() return "Speed:" end }))

    -- update the clock
    clockView = looky:build("new.text", { width = "fill", height = "fill", data = function() return math.floor(seconds) .. "s" end })
    
Let's apply some quick styling to the bar itself as well. Add a background, some padding and some notches like this:

    local speedView = looky:build("numberAsBar", { width = "fill", height = 40, gravity = { "center", "center" }, value = function() return player.speed end, maxValue = player.maxSpeed, filledColor = { 100, 150, 30, 255 }, background = { 40, 40, 45, 255 }, padding = looky.padding(5), notches = { amount = 4, color = { 255, 255, 255, 255 }, height = 0.4 } })
    
    
I'm going to leave off styling it further at this point. Consider making it look "not-dreadful" as an exercise in seeing if you understand it. Instead, I'm going to show you a little bit about signals. Signals are how different parts of the view can communicate with each other and with the outside world. (And for this game, not really required, so the next part is more "how does it work" than "this is when you use it")
We're going to add a warning light to the main panel, that lights up when your speed approaches the maximum speed. Then we'll add a second one that lights up when you are close to the borders of the screen. Both will have a small label, to explain their purpose, and they'll be turned on and off by receiving signal updates from an outside system.

Let's start by creating a new type of view for our warning lights. Since we're making two, it's best to make components out of them. The warning light has a vertical linear container, which contains two views: a label and a light. The label will be text; in order to reuse as much of our existing style as possible we will extend new text further but this time using a smaller version of the font. The light will be a simple image. Since this view will have some customizable parts, we'll also include a schema for it.

First, define an extension to our existing text to use a small font. We need to register the font also. And we need to load the two images to use.
    looky:registerFont( "small", love.graphics.newFont( "fonts/Roboto-Bold.ttf", 10))
    looky:registerStyledLayout( "new.text.label", "new.text", { font = "small" })
    
    lightOff = love.graphics.newImage("docs/assets/light_off.png")
    lightOn = love.graphics.newImage("docs/assets/light_on.png")

Then, create a new view type.

    warningLightType = {
      build = function(options)
        local container = looky:build("linear", { width = "cram", height = "wrap", direction = "v" })
        container:addChild(looky:build("new.text.label", { width = "fill", height = "wrap", data = function() return options.label end }))
        container:addChild(looky:build("image", { width = "wrap", height = "wrap", file = lightOff }))
        
        return container
      end,
      schema = {
        label = {
          required = true,
          schemaType = "string"
        }
      }
    
    }
    
    looky:registerLayout("light", warningLightType)
    
We will cram our warning lights between the speed gauge and the clock. Looky will figure out how that should look. We'll add a vertical container there and put our two lights in it.

    local lightsDisplay = looky:build("linear", { width = "wrap", height = "wrap", direction = "v" })
    lightsDisplay:addChild( looky:build( "light", { label = "Speed" } ))
    lightsDisplay:addChild( looky:build( "light", { label = "Edge" } ))
    
    -- add it to the hud between the other two
    HUDView:addChild(clockView)
    HUDView:addChild(lightsDisplay)
    HUDView:addChild(speedView)

You'll see the two lights and their labels on the HUD now. Notice how the schema definition allowed us to pass a label to the build() function, which is now shown above the light. Also notice how the labels have the same basic colors as the previously defined text-type, but smaller text.

The next step is to make them light up when something is wrong. This requires two things: the first is to swap out the image when a problem happens, the second is to be able to receive a signal when an update is required. Let's start by setting up a simple controller that will push out the signals. We will do speed first. It will send out a signal when the speed goes over 240, and one when the speed falls under 240 again. Most of the code is simple lua, except for the call the receiveOutsideMessage(). 

    -- add to love.load
    isSpeeding = false
    
    -- add to love.update
    if isSpeeding and player.speed < 240 then
      isSpeeding = false
      rootView:receiveOutsideSignal("warning", { name = "speeding", active = true })
    elseif not isSpeeding and player.speed > 240 then
      isSpeeding = true
      rootView:receiveOutsideSignal("warning", { name = "speeding", active = false })
    end

Now, this will send out a signal to the root whenever we start or stop moving at high speed. By default, views will transfer these signals to all their children. So eventually, the signal will end up at our warning lights. However; the warning lights won't actually do anything with it. Let's add a bit of code to the warning lights to handle the signal. We'll need to update the warning light Schema, so that they can accept the warning-signal name they should respond to ("speeding" for the speed light). Then, we'll need to setup an event handler inside the code. 
    
    -- change the build function to this:
    build = function(options)
      local container = looky:build("linear", { width = "cram", height = "wrap", direction = "v" })
      container:addChild(looky:build("new.text.label", { width = "fill", height = "wrap", data = function() return options.label end }))
      local imageView = looky:build("image", { width = "wrap", height = "wrap", file = lightOff })
      container:addChild(imageView)
      
      -- the following line tells the view that it should listen to signals coming from outside that have "warning" as their signal
      imageView.externalSignalHandlers.warning = function(self, signal, payload)
        if payload.name == options.respondTo then
          if payload.active then
            imageView:setImage(lightOn)
          else
            imageView:setImage(lightOff)
          end
        end
      end
      
      return container
    end,
    
    -- change the schema to this, so that we can say which warning type it should react to
    schema = {
      label = {
        required = true,
        schemaType = "string"
      },
      respondTo = {
        required = true,
        schemaType = "string"
      }
    }
    
Now if you run the program, you'll see what happens when you update the schema but forget to update the actual build calls. Looky will complain about the missing respondTo properties. So last step: we update the calls to build these lights to pass them some names of signals to react to:

    lightsDisplay:addChild( looky:build( "light", { label = "Speed", respondTo = "speeding" } ))
    lightsDisplay:addChild( looky:build( "light", { label = "Edge", respondTo = "edge" } ))

Now if you run the program and you speed up to close to the maximum speed, you should see the "speed" indicator flip on. And we can make any number of warning lights, anywhere on the screen, and have them react to any signal we want without having to put any new code in the lights themselves. Whatever code is handling the warnings also does not need to know where on the page the lights are and it's simple to have multiple control systems that give off the same warning.

Here's the code for the edge detector. It works roughly the same way; some love code in the load/update is all we need.

    -- add this in love.load
    nearEdge = false
    
    -- add this in love.update
    if nearEdge and player.x > 100 and player.x < gameScreenView:availableWidth() - 100 and player.y > 100 and player.y < gameScreenView:availableHeight() - 100 then
      nearEdge = false
      rootView:receiveOutsideSignal("warning", { name = "edge", active = false })
    elseif not nearEdge and (player.x < 100 or player.x > gameScreenView:availableWidth() - 100 or player.y < 100 or player.y > gameScreenView:availableHeight() - 100 ) then
      nearEdge = true
      rootView:receiveOutsideSignal("warning", { name = "edge", active = true })
    end

We use the actual assigned size to the gameScreenView (minus the borders) so that it works for any size of screen.

This is where I'm going to leave off. I hope you have a basic idea of the idea behind Looky and how you can use it to set up your game's layout. In case you get stuck with the tutorial, you can always download the complete project from my github: 