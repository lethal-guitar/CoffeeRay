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
        phongModel = new PhongModel(closestHit)
        _.each @lights, (light) =>
            @calculateLighting light, phongModel
        phongModel.getColor()
        
    calculateLighting: (light, phongModel) ->
        lightVector = light.position.subtract phongModel.targetPosition
        lightRay = Ray.fromDirection(phongModel.targetPosition, lightVector)

        unless @checkIfInShadow lightRay, lightVector.length()
            phongModel.contributeLight lightRay.direction, light
            
    checkIfInShadow: (ray, lightDistance) ->
        _.any @traceables, (each) -> 
            test = each.testIntersection ray
            test? and test.distance < lightDistance
