class Material
    @DEFAULT_SPECULARITY = 90.0

    @makeColored: (ambient, diffuse, specular, specularity = Material.DEFAULT_SPECULARITY) ->
        [fAmbient, fDiffuse, fSpecular] = _.map [ambient, diffuse, specular], (each) -> each.toFloatColor()
        new Material(fAmbient, fDiffuse, fSpecular, specularity)
        
    @makeSimpleColored: (color, specularity = Material.DEFAULT_SPECULARITY) ->
        new Material(new Color(0.0), color.toFloatColor(), new Color(1.0), specularity)

    constructor: (@ambient, @diffuse, @specular, @specularity) ->
