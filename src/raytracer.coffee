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
        lightDistance = lightVector.length()
        
        # This has the same effect as calling normalize, but we save
        # one length calculation since the length is already known.
        lightVector = lightVector.multiplyScalar(1.0 / lightDistance) 
        lightRay = new Ray(phongModel.targetPosition, lightVector)

        unless @checkIfInShadow lightRay, lightDistance
            phongModel.contributeLight lightVector, light
            
    checkIfInShadow: (ray, lightDistance) ->
        _.any @traceables, (each) -> 
            test = each.testIntersection ray
            test? and test.distance < lightDistance
