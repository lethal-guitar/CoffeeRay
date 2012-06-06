class Ray
    @makeDirectionVector: (from, to) ->
        to.subtract(from).normalize()

    constructor: (@origin, target) ->        
        @direction = Ray.makeDirectionVector @origin, target
    
    positionAt: (t) ->
        vector = @direction.multiplyScalar(t)
        @origin.add(vector)
