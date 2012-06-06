#
# Implements the Phong lighting model
class Irradiance
    constructor: (@material) ->
        @ambient = new Color(0.0)
        @diffuse = new Color(0.0)
        @specular = new Color(0.0)
        # TODO: Provide global ambient color setting
        #@ambient = @material.ambient.multiplyFactor(...)

        
    contributeLight: (viewVector, lightVector, normal, lightSource) ->
        diffuseComponent = @calcDiffuse lightVector, normal        
        if diffuseComponent > 0.0
            @contributeDiffuse diffuseComponent, lightSource
            
            specularDot = @calcSpecular viewVector, lightVector, normal
            if specularDot > 0.0
                @contributeSpecular specularDot, lightSource
                
    toColor: ->
        ambientOut = @material.ambient.multiply @ambient
        diffuseOut = @material.diffuse.multiply @diffuse
        specularOut = @material.specular.multiply @specular
        ambientOut.add(diffuseOut).add(specularOut).toRgbColor()
    
    contributeDiffuse: (value, lightSource) ->
        @diffuse = @diffuse.add(lightSource.diffuse.multiplyFactor value)
        
    contributeSpecular: (value, lightSource) ->
        specularComponent = Math.pow value, @material.specularity
        addedSpecular = lightSource.specular.multiplyFactor specularComponent
        @specular = @specular.add addedSpecular
        
    calcDiffuse: (lightVector, normal) ->
        lightVector.dotProduct normal
        
    calcSpecular: (viewVector, lightVector, normal) ->
        lightReflectVector = @makeReflectVector normal, lightVector
        lightReflectVector.dotProduct viewVector
        
    makeReflectVector: (normal, vector) ->
        nDot = normal.dotProduct vector
        normal.multiplyScalar(2.0 * nDot).subtract(vector).normalize()
