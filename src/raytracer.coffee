class Raytracer
    constructor: (@target, @backgroundColor, @viewport) ->
        @viewport ?= Viewport.defaultViewport(@target.width, @target.height)
        @traceables = []
        @lights = []
    
    addTraceable: (object) -> 
        @traceables.push object
    
    addLightSource: (light) ->
        @lights.push light
    
    render: ->
        @processPixel(x, y) for x in [0..@target.width] for y in [0..@target.height]
        @target.finishedRendering()
    
    processPixel: (x, y) ->
        @target.setPixel(x, y, @determineColorAt(x, y))
        
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
