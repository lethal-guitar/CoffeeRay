class PointLight
    @DEFAULT_COLOR = new Color(1.0)

    @makeColored: (position, diffuse, specular) ->
        new PointLight(position, diffuse?.toFloatColor(), specular?.toFloatColor())

    constructor: (@position, @diffuse = PointLight.DEFAULT_COLOR, @specular = PointLight.DEFAULT_COLOR) ->
