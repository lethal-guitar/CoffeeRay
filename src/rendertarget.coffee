#
# Abstraction for HTML5 canvas. Could be subclassed to
# support rendering images to additional targets, e.g. in
# an environment without canvas etc.
class RenderTarget
    constructor: (@canvas) ->
        [@width, @height] = [@canvas.width, @canvas.height]
        @setupCanvas()
   
    setupCanvas: ->
        @context = @canvas.getContext("2d")
        @image = @context.createImageData @width, @height     
   
    setPixel: (x, y, color) ->
        index = x + y*@width
        index *= 4
        @image.data[index]   = color.r
        @image.data[index+1] = color.g
        @image.data[index+2] = color.b
        @image.data[index+3] = color.a

    finishedRendering: ->
        @context.putImageData @image, 0, 0
