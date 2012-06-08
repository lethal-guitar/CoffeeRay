#
# Implements the Phong lighting model
#
# Cumulates a surface color value from several
# contributing light sources.
class PhongModel
    constructor: (intersection) ->
        @ambient = new Color(0.0)
        @diffuse = new Color(0.0)
        @specular = new Color(0.0)
        @copyIntersectionParameters(intersection)
        # TODO: Provide global ambient color setting
        #@ambient = @material.ambient.multiplyFactor(...)

    copyIntersectionParameters: (intersection) ->
        @material = intersection.material()
        @normal = intersection.normal()
        @position = intersection.position
        @viewVector = intersection.ray.direction.multiplyScalar -1.0

    contributeLight: (lightVector, light) ->
        diffuseComponent = @calcDiffuse lightVector
        if diffuseComponent > 0.0
            radiance = light.radianceAt @position
            @contributeDiffuse diffuseComponent, radiance
            
            specularDot = @calcSpecular lightVector
            if specularDot > 0.0
                @contributeSpecular specularDot, radiance
                
    getColor: ->
        ambientOut = @material.ambient.multiply @ambient
        diffuseOut = @material.diffuse.multiply @diffuse
        specularOut = @material.specular.multiply @specular
        ambientOut.add(diffuseOut).add(specularOut).toRgbColor()
    
    contributeDiffuse: (value, radiance) ->
        @diffuse = @diffuse.add(radiance.diffuse.multiplyFactor value)
        
    contributeSpecular: (value, radiance) ->
        specularComponent = Math.pow value, @material.specularity
        addedSpecular = radiance.specular.multiplyFactor specularComponent
        @specular = @specular.add addedSpecular
        
    calcDiffuse: (lightVector) ->
        lightVector.dotProduct @normal
        
    calcSpecular: (lightVector) ->
        lightReflectVector = @makeReflectVector lightVector
        lightReflectVector.dotProduct @viewVector
        
    makeReflectVector: (vector) ->
        nDot = @normal.dotProduct vector
        @normal.multiplyScalar(2.0 * nDot).subtract(vector).normalize()
