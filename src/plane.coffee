class Plane extends Raytraceable
    constructor: (@position, @_normal, materialOrColor) ->
        @_material = @_makeMaterial materialOrColor
        @distanceToOrigin = @position.length()
        
    material: ->
        @_material
        
    normal: (hit) ->
        @_normal
        
    testIntersection: (ray) ->
        firstDot = @_normal.dotProduct ray.direction
        return null if firstDot >= 0.0
        
        secondDot = @_normal.dotProduct(ray.origin) + @distanceToOrigin
        t = -(secondDot) / firstDot
        
        @clippedIntersection ray, t 
