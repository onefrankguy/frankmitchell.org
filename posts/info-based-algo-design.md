<!--
title: Information Based Algorithmic Design
created: 19 April 2005 - 4:31 pm
updated: 19 April 2005 - 5:12 pm
tags: coding
-->

Notes from Dr. Hiromoto's presentation to the ACM.

### Information Manifold ###

What happens when we add time to our information equations? Einstein's equations say we feel a stars birth instantaneously, but that's not true. We need to take time into account.

### Solution Manifold ###

You might be rushing towards the solution and leaving gaps in your information. Suppose we want to figure out tomorrow's weather. We can all take an almanac and look at the average of tomorrow's temperature for the whole year.

### Space-Time Information Cone ###

We're in the cone. Information speed, C, is constant (the speed of light). In order to move information faster than time, we need particles that move faster than light.

### Information based algorithm complexity: design of parallel systems ###

Joseph Traub introduced the idea of information based complexity. The basic framework revolved around the following ideas:

1. Information is derived and used by the computation to solve a problem
2. An algorithm, A, defines the information based solution method
3. THe number of iterations required to achieve convergence

At every step of the iteration, I<sub>n</sub>, you gain information. Bayes algorithm is kind of an iterative process.

### Adaptive vs. non-adaptive information ###

Let F be a set of problem elements and f and G be a normal linear space over the scalar field of real or complex numbers. Then the solution operator is defined by S:F->G.

Non-adaptive information is parallel. It only requires the current set of elements. It's always the same set.

Adaptive information is sequential. The next iteration requires that use use the previous value.

### Jacobi iteration scheme ###

Suppose you have a box (freezer) that's at a constant temperature. You need to insulate the box, but you might have different temperatures on each side of the container. [Similar to the plate problem we did in Operating Systems.] This is only a model, so it may be wrong for complex problems (like weather).

If you don't have to wait for a point to be updated, you can calculate every point simultaneously. This is highly parallel.

### Gauss-Seidel iteration levels ###

You update a point, and then allow other points to use the new value. This is adaptive. We're trying to pass the information as fast as possible.

If you were to write this out, you'd get a tri-diagonal matrix that you could solve the eigenvalues for. The results being that the Gauss-Seidel method is almost twice as fast as the Jacobi method.

### Info based algorithms ###

You need to know how the information drives the solution. You can solve really complex problems by knowing the solution, 'cause then you have a complexity of one.

How can I rearrange the information I know to use my algorithm most efficiently?

### Boundary Monte Carlo method ###

Finding the solution of non-homogeneous PDE's. The Monte Carlo solution of Poisson's equation:

* Simple random walk in rectangular coordinates
* Use of boundary information
* Rate of convergence
* Effects of discretization errors
* Experimental results

Particles wonder randomly around a grid and report the temperature when they hit a wall. n particles per grid point. m x m grid. Complexity is n x m<sup>4</sup> if you start a particle in the center.

There's a method that drops the complexity from m<sup>4</sup> to m<sup>3</sup>. The best you can do with p processors is m<sup>4</sup> / p. But making p bigger and bigger isn't really feasible.

The higher the dimension of the grid, the greater the probability you won't get trapped inside the grid.

### Conclusions ###

The results with the adjusted method are smoother.
