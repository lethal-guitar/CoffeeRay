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
        phongModel = new PhongModel(closestHit)
        _.each @lights, (light) =>
            @calculateLighting light, phongModel
        phongModel.getColor()
        
    calculateLighting: (light, phongModel) ->
        lightRay = new Ray(phongModel.targetPosition, light.position)
        inShadow = false
        # TODO: Not used for now - has some strange artefacts
        #inShadow = @hasIntersection lightRay
        
        unless inShadow
            phongModel.contributeLight lightRay.direction, light
