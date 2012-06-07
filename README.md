CoffeeRay
=========

A HTML 5 based raytracer written in CoffeeScript. It's a little project done mainly for fun and learning CoffeeScript, 
and to play around with a raytracing implementation. 

The project
-----------

I'm currently working on a CUDA-based raytracer for a course at my university. Using a scripting language 
is perfect for experimentation and exploring the general concepts, in preparation for the "real" implementation. 
Also, HTML 5 provides a very convenient environment for displaying rendered images and manipulating input parameters.
Finally, I'd like to see how well modern JS engines can cope with such a computationally intensive task, and how much
performance I can squeeze out of it ;)

Generated images are blitted onto a 2D canvas. Currently it supports only spheres, phong shading and hard shadows. 
No reflections/refractions (yet), no anti-aliasing, and no fancy stuff like depth-of-field etc.

Building
--------

I'm using my own python based "build tool" at the moment. `build-order.txt` contains a list of all CoffeeScript source files. 
Dependencies are reflected by the order of entries in that file. E.g., `point3d.coffee` is listed before `ray.coffee`, because 
the `Ray` class depends on the `Point3D` class.
Running `build.py` invokes the `coffee` command on all files specified there, and produces a single `web/coffee-ray.js` file.
So new source files should be added to `build-order.txt`. 

Running
-------

Run the build script (as described above) and open web/coffee-ray.html in your browser of choice.
