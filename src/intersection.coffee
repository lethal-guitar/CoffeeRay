class Intersection
    constructor: (@traceable, @distance, @ray) ->        
        @position = @ray.positionAt(@distance)
    
    material: ->
        @traceable.material()
    
    normal: -> 
        @traceable.normal(@position)
