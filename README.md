CoffeeRay
=========

A HTML 5 based raytracer written in CoffeeScript. It's a little project done mainly for fun and learning CoffeeScript, 
and to play around with a raytracing implementation. 

I'm currently working on a CUDA-based raytracer for a course at my university. Using a scripting language 
is perfect for experimentation and exploring the general concepts, in preparation for the "real" implementation. 
Also, HTML 5 provides a very convenient environment for displaying rendered images and manipulating input parameters.
Finally, I'd like to see how well modern JS engines can cope with such a computationally intensive task, and how much
performance I can squeeze out of it ;)

Generated images are blitted onto a 2D canvas. Currently it supports only spheres, phong shading and hard shadows. 
No reflections/refractions (yet), no anti-aliasing, and no fancy stuff like depth-of-field etc.