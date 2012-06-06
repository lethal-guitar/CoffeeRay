class Raytracer
    constructor: (@canvas, @backgroundColor) ->
        @context = canvas.getContext("2d")
        @setupImagePlane()            
        @setupViewport()
        @traceables = []
        @lights = []
    
    setupImagePlane: ->
        @imageData = @context.createImageData(@canvas.width, @canvas.height)
        
        # patch setPixel function into ImageData - it's not
        # provided out of the box
        @imageData.constructor::setPixel = (x, y, color) ->
            index = x + y*@width
            index *= 4
            @data[index]   = color.r
            @data[index+1] = color.g
            @data[index+2] = color.b
            @data[index+3] = color.a
        
    setupViewport: ->
        # TODO: Make these customizable - factor out
        # into a Viewport/Camera class??
        @xLeft = -12.0
        @xRight = 12.0
        @yTop = -9.0
        @yBottom = 9.0
        @viewPoint = new Point3D(0.0, 0.0, -10.0)        
        
        dx = Math.abs(@xRight - @xLeft)
        dy = Math.abs(@yTop - @yBottom)
        @dxPixel = dx / @canvas.width
        @dyPixel = dy / @canvas.height
        
    addTraceable: (object) -> 
        @traceables.push object
    
    addLightSource: (light) ->
        @lights.push light
    
    render: ->
        @processPixel(x, y) for x in [0..@canvas.width] for y in [0..@canvas.height]
        @context.putImageData(@imageData, 0, 0)
    
    processPixel: (x, y) ->
        color = @determineColorAt(x, y)
        @imageData.setPixel(x, y, color)
        
    determineColorAt: (x, y) ->
        ray = @constructPrimaryRay(x, y) 
        closestHit = @findIntersection(ray)
        
        if closestHit? 
            @determineHitColor closestHit 
        else
            @backgroundColor
    
    constructPrimaryRay: (x, y) ->
        tx = @xLeft + x * @dxPixel
        ty = @yTop + y * @dyPixel
        pointOnViewplane = new Point3D(tx, ty, 0.0)
        new Ray(@viewPoint, pointOnViewplane)
        
    findIntersection: (ray) ->
        findFunc = (left, right) -> 
            test = right.testIntersection ray
            return test if test?.distance < (left?.distance ? Infinity)
            left
            
        _.foldl @traceables, findFunc, null
        
    makeReflectVector: (normal, vector) ->
        nDot = normal.dotProduct vector
        normal.multiplyScalar(2.0 * nDot).subtract(vector).normalize()
        
    determineHitColor: (closestHit) ->
        ray = closestHit.ray
        normal = closestHit.normal()
        material = closestHit.material()

        ambient = new Color(0.0)
        diffuse = new Color(0.0)
        specular = new Color(0.0)        
        
        for light in @lights
            do (light) =>
                shadowTestRay = new Ray(closestHit.position, light.position)
                inShadow = false
                # TODO: Not used for now - has some strange artefacts
                #inShadow = _.any(@traceables, (each) -> (each.testIntersection shadowTestRay)?)
                
                unless inShadow
                    vectorIncoming = ray.direction.multiplyScalar(-1.0)
                    lightSourceVector = shadowTestRay.direction        
                    lightReflectVector = @makeReflectVector normal, lightSourceVector
                    
                    # Phong lighting!!
                    diffuseComponent = lightSourceVector.dotProduct normal
                    
                    if diffuseComponent > 0.0
                        addedDiffuse = light.diffuse.multiplyFactor diffuseComponent
                        diffuse = diffuse.add addedDiffuse
                    
                        specularDot = lightReflectVector.dotProduct vectorIncoming
                        
                        if specularDot > 0.0
                            specularComponent = Math.pow specularDot, material.specularity
                            addedSpecular = light.specular.multiplyFactor specularComponent
                            specular = specular.add addedSpecular
            
        # TODO: Provide global ambient color setting
        #ambient = material.ambient.multiplyFactor(...)
        
        @irradianceToColor material, ambient, diffuse, specular
        
    irradianceToColor: (material, ambient, diffuse, specular) ->
        ambientOut = material.ambient.multiply ambient
        diffuseOut = material.diffuse.multiply diffuse
        specularOut = material.specular.multiply specular
        ambientOut.add(diffuseOut).add(specularOut).toRgbColor()
