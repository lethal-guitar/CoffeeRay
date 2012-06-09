class Triangle extends Plane
    @ORIGIN = new Point3D(0.0, 0.0, 0.0)

    constructor: (@point1, @point2, @point3, material) ->
        super(@point1, @calculateNormal(), material)
            
    calculateNormal: ->
        vector1 = @point3.subtract @point1
        vector2 = @point2.subtract @point3
        vector1.crossProduct(vector2).normalize()

    testIntersection: (ray) ->
        test = super ray
        
        if test?
            return null unless @pointInTriangle test.position
        test

    pointInTriangle: (point) ->
        v0 = @point3.subtract @point1
        v1 = @point2.subtract @point1
        v2 = point.subtract @point1

        dot00 = v0.dotProduct v0
        dot01 = v0.dotProduct v1
        dot02 = v0.dotProduct v2
        dot11 = v1.dotProduct v1
        dot12 = v1.dotProduct v2

        invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01)
        u = (dot11 * dot02 - dot01 * dot12) * invDenom
        v = (dot00 * dot12 - dot01 * dot02) * invDenom

        (u >= 0.0) and (v >= 0.0) and (u + v < 1.0)
