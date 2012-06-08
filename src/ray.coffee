class Ray
    @makeDirectionVector: (from, to) ->
        to.subtract(from).normalize()

    @fromPoints: (origin, target) ->
        vector = Ray.makeDirectionVector origin, target
        new Ray(origin, vector)

    constructor: (@origin, @direction) ->        
    
    positionAt: (t) ->
        vector = @direction.multiplyScalar(t)
        @origin.add(vector)
