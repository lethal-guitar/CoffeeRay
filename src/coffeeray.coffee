class CoffeeRay
    constructor: (canvas) ->
        @tracer = new Raytracer(new RenderTarget(canvas), new Color(80, 80, 80, 255))    
        @setupScene()
        @setupUI()

    setupScene: ->
        # TODO: Provide a UI to change the scene description 
        # (could be just a JSON input field for starters)
        @theSphere = new Sphere(new Point3D(-5.0, 20.0, 34.0), 5.0, new Color(255, 0, 0))
        @tracer.addTraceable @theSphere
        
        @tracer.addTraceable new Sphere(new Point3D(-20.0, 14.0, 30.0), 8.0, new Color(130, 200, 0))
        @tracer.addTraceable new Sphere(new Point3D(-10.0, 8.0, 38.0), 8.0, new Color(0, 200, 0))
        @tracer.addTraceable new Sphere(new Point3D(0.0, 2.0, 44.0), 8.0, new Color(80, 80, 210))
        
        @tracer.addLightSource new PointLight(new Point3D(12.0, -34.0, 30.0)) 
        @tracer.addLightSource new PointLight(new Point3D(0.0, 34.0, 34))

        
    setupUI: ->
        $('#traceBtn').click =>
            @moveSphere()
            @render()
                
        $('#sX').val @theSphere.center.x
        $('#sY').val @theSphere.center.y
        $('#sZ').val @theSphere.center.z
        $('#sRadius').val @theSphere.radius
        
    moveSphere: ->
        x = $('#sX').val() * 1.0
        y = $('#sY').val() * 1.0
        z = $('#sZ').val() * 1.0
        radius = $('#sRadius').val() * 1.0
        @theSphere.center = new Point3D(x, y, z)
        @theSphere.radius = radius;
                
    render: ->
        # Defer rendering, so UI event processing
        # does not hang
        @startRendering()
        window.setTimeout(@performRendering, 5)
    
    performRendering: =>
        startTime = @currentTimeMs()
        @tracer.render()
        @finishRendering(startTime)
    
    startRendering: ->
        $('#renderFinished').hide()
        $('#renderInProgress').show()        
    
    finishRendering: (startTime) ->
        $('#renderInProgress').hide()
        $('#renderFinished').show()
        $('#msDisplay').html @currentTimeMs() - startTime
    
    currentTimeMs: ->
        (new Date) * 1
