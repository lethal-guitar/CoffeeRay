class Viewport
    @defaultViewport: (width, height) ->
        new Viewport(width, height, -12.0, 12.0, -9.0, 9.0, new Point3D(0.0, 0.0, -10.0))

    constructor: (width, height, @xLeft, @xRight, @yTop, @yBottom, @pointOfView) ->
        dx = Math.abs(@xRight - @xLeft)
        dy = Math.abs(@yTop - @yBottom)
        @dxPixel = dx / width
        @dyPixel = dy / height
            
    constructRayForPixel: (x, y) ->
        tx = @xLeft + x * @dxPixel
        ty = @yTop + y * @dyPixel
        pointOnViewplane = new Point3D(tx, ty, 0.0)
        Ray.fromPoints(@pointOfView, pointOnViewplane)
