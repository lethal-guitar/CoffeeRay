class Color
    constructor: (@r, @g, @b, @a) ->
        @g ?= @r
        @b ?= @r
        @a ?= 255.0
            
    add: (other) ->
        new Color(@r + other.r, @g + other.g, @b + other.b, @a)
            
    multiply: (other) ->
        new Color(@r * other.r, @g * other.g, @b * other.b, @a)
    
    multiplyFactor: (factor) ->
        new Color(@r * factor, @g * factor, @b * factor, @a)
    
    # assumes values are in [0.0..1.0]
    toRgbColor: () ->
        @multiplyFactor(255)
        
    # assumes values are in [0..255]
    toFloatColor: () ->
        @multiplyFactor(1.0 / 255.0)
