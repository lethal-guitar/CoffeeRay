class Point3D
    constructor: (@x, @y, @z) ->
    
    length: ->
        Math.sqrt(@x*@x + @y*@y + @z*@z)
    
    normalize: ->
        new Point3D(@x, @y, @z).multiplyScalar(1.0 / @length())
    
    add: (other) ->
        new Point3D(@x + other.x, @y + other.y, @z + other.z)
        
    subtract: (other) ->
        @add other.multiplyScalar(-1.0)
        
    dotProduct: (other) ->
        @x*other.x + @y*other.y + @z*other.z
    
    crossProduct: (other) ->
        x = @y*other.z - @z*other.y
        y = @z*other.x - @x*other.z
        z = @x*other.y - @y*other.x
        new Point3D(x, y, z)
        
    multiplyScalar: (scalar) ->
        new Point3D(@x * scalar, @y * scalar, @z * scalar)
