<!--
title: Iterate and delete
created: 3 February 2005 - 4:37 pm
updated: 3 February 2005 - 4:45 pm
slug: erase-remove
tags: coding
-->

Every once in a while, I stumble across really elegant solutions (in code) to
common problems. Iterate and delete is one of those problems. How do you process
an array of elements, and delete any that shouldn't be there, without leaving
the iteration? It's assumed that the order of the elements is inconsequential.

Dierk Ohlerich provides the following [solution][]:

    struct element {
      int data;
      bool selected;
    };

    struct element *array;
    int count;

    for(int i = 0; i < count;)
    {
      if(array[i].selected)
      {
        count--;
        array[i] = array[count];
      }
      else
      {
        i++;
      }
    }

Sometimes, code is just sexy.

[solution]: http://www.xyzw.de/c130.html "Dierk Ohlerich (xyzw.de): Iterate & Delete"
