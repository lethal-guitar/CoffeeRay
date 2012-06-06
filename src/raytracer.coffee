class Raytracer
    constructor: (@canvas, @backgroundColor, @viewport) ->
        @context = @canvas.getContext("2d")
        @viewport ?= Viewport.defaultViewport(@canvas.width, @canvas.height)
        @setupImagePlane()
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
        ray = @viewport.constructRayForPixel(x, y) 
        closestHit = @findIntersection(ray)
        
        if closestHit? 
            @determineHitColor closestHit 
        else
            @backgroundColor
    
    findIntersection: (ray) ->
        findFunc = (current, next) -> 
            test = next.testIntersection ray
            return test if test?.distance < (current?.distance ? Infinity)
            current
            
        _.foldl @traceables, findFunc, null
        
    determineHitColor: (closestHit) ->
        irradiance = new Irradiance(closestHit.material())
        @calculateLighting closestHit, irradiance 
        irradiance.toColor()
        
    calculateLighting: (closestHit, irradiance) ->
        for light in @lights
            do (light) =>
                shadowTestRay = new Ray(closestHit.position, light.position)
                inShadow = false
                # TODO: Not used for now - has some strange artefacts
                #inShadow = _.any(@traceables, (each) -> (each.testIntersection shadowTestRay)?)
                
                unless inShadow
                    viewVector = closestHit.ray.direction.multiplyScalar(-1.0)
                    lightVector = shadowTestRay.direction
                    irradiance.contributeLight viewVector, lightVector, closestHit.normal(), light
