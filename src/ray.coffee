class Ray
    @makeDirectionVector: (from, to) ->
        to.subtract(from).normalize()

    @fromDirection: (origin, direction) ->
        ray = new Ray()
        ray.origin = origin
        ray.direction = direction.normalize()
        ray

    constructor: (@origin, target) ->        
        if @origin?
            @direction = Ray.makeDirectionVector @origin, target
    
    positionAt: (t) ->
        vector = @direction.multiplyScalar(t)
        @origin.add(vector)
