class Sphere extends Raytraceable
    constructor: (@center, @radius, materialOrColor) ->
        @_material = @_makeMaterial materialOrColor 
    
    material: -> 
        @_material
    
    normal: (hit) ->
        Ray.makeDirectionVector @center, hit
    
    testIntersection: (ray) ->
        vector = ray.origin.subtract(@center)
        b = vector.dotProduct(ray.direction)
        c = vector.dotProduct(vector) - sqr(@radius)
        discriminant = sqr(b) - c
        
        return null if discriminant < 0 
        
        sqrtDiscriminant = Math.sqrt discriminant
        t0 = -b + sqrtDiscriminant
        t1 = -b - sqrtDiscriminant
        t = Math.min t0, t1
    
        @clippedIntersection ray, t
