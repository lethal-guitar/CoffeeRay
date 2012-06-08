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
        
    hasIntersection: (ray) ->
        # TODO: Ignore traceabes which are behind the light source..
        _.any @traceables, (each) -> (each.testIntersection ray)?
        
    determineHitColor: (closestHit) ->
        irradiance = new Irradiance(closestHit)
        _.each @lights, (light) =>
            @calculateLighting light, irradiance
        irradiance.toColor()
        
    calculateLighting: (light, irradiance) ->
        lightRay = new Ray(irradiance.position, light.position)
        inShadow = false
        # TODO: Not used for now - has some strange artefacts
        #inShadow = @hasIntersection lightRay
        
        unless inShadow
            irradiance.contributeLight lightRay.direction, light
