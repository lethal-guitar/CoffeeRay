class Raytraceable
    testIntersection: (ray) ->
        abstractMethod()
    
    normal: (intersectionPoint) ->
        abstractMethod()        
        
    material: ->
        abstractMethod()
        
    # Convenience function, turns a single Color
    # value into a full-fledged Material, or passes
    # it through if it's already a Material.
    _makeMaterial: (materialOrColor) ->
        if materialOrColor instanceof Color
            Material.makeSimpleColored materialOrColor
        else
            materialOrColor
