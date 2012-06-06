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
