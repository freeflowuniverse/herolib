# module math.vec


## Contents
- [Constants](#Constants)
- [vec2](#vec2)
- [vec3](#vec3)
- [vec4](#vec4)
- [Vec2[T]](#Vec2[T])
  - [zero](#zero)
  - [one](#one)
  - [copy](#copy)
  - [from](#from)
  - [from_vec3](#from_vec3)
  - [as_vec3](#as_vec3)
  - [from_vec4](#from_vec4)
  - [as_vec4](#as_vec4)
  - [+](#+)
  - [add](#add)
  - [add_scalar](#add_scalar)
  - [plus](#plus)
  - [plus_scalar](#plus_scalar)
  - [-](#-)
  - [sub](#sub)
  - [sub_scalar](#sub_scalar)
  - [subtract](#subtract)
  - [subtract_scalar](#subtract_scalar)
  - [*](#*)
  - [mul](#mul)
  - [mul_scalar](#mul_scalar)
  - [multiply](#multiply)
  - [multiply_scalar](#multiply_scalar)
  - [/](#/)
  - [div](#div)
  - [div_scalar](#div_scalar)
  - [divide](#divide)
  - [divide_scalar](#divide_scalar)
  - [magnitude](#magnitude)
  - [magnitude_x](#magnitude_x)
  - [magnitude_y](#magnitude_y)
  - [dot](#dot)
  - [cross](#cross)
  - [unit](#unit)
  - [perp_cw](#perp_cw)
  - [perp_ccw](#perp_ccw)
  - [perpendicular](#perpendicular)
  - [project](#project)
  - [eq](#eq)
  - [eq_epsilon](#eq_epsilon)
  - [eq_approx](#eq_approx)
  - [is_approx_zero](#is_approx_zero)
  - [eq_scalar](#eq_scalar)
  - [distance](#distance)
  - [manhattan_distance](#manhattan_distance)
  - [angle_between](#angle_between)
  - [angle_towards](#angle_towards)
  - [angle](#angle)
  - [abs](#abs)
  - [clean](#clean)
  - [clean_tolerance](#clean_tolerance)
  - [inv](#inv)
  - [normalize](#normalize)
  - [sum](#sum)
- [Vec3[T]](#Vec3[T])
  - [zero](#zero)
  - [one](#one)
  - [copy](#copy)
  - [from](#from)
  - [from_vec2](#from_vec2)
  - [as_vec2](#as_vec2)
  - [from_vec4](#from_vec4)
  - [as_vec4](#as_vec4)
  - [+](#+)
  - [add](#add)
  - [add_vec2](#add_vec2)
  - [add_scalar](#add_scalar)
  - [plus](#plus)
  - [plus_vec2](#plus_vec2)
  - [plus_scalar](#plus_scalar)
  - [-](#-)
  - [sub](#sub)
  - [sub_scalar](#sub_scalar)
  - [subtract](#subtract)
  - [subtract_scalar](#subtract_scalar)
  - [*](#*)
  - [mul](#mul)
  - [mul_scalar](#mul_scalar)
  - [multiply](#multiply)
  - [multiply_scalar](#multiply_scalar)
  - [/](#/)
  - [div](#div)
  - [div_scalar](#div_scalar)
  - [divide](#divide)
  - [divide_scalar](#divide_scalar)
  - [magnitude](#magnitude)
  - [dot](#dot)
  - [cross](#cross)
  - [unit](#unit)
  - [perpendicular](#perpendicular)
  - [project](#project)
  - [eq](#eq)
  - [eq_epsilon](#eq_epsilon)
  - [eq_approx](#eq_approx)
  - [is_approx_zero](#is_approx_zero)
  - [eq_scalar](#eq_scalar)
  - [distance](#distance)
  - [manhattan_distance](#manhattan_distance)
  - [angle_between](#angle_between)
  - [abs](#abs)
  - [clean](#clean)
  - [clean_tolerance](#clean_tolerance)
  - [inv](#inv)
  - [normalize](#normalize)
  - [sum](#sum)
- [Vec4[T]](#Vec4[T])
  - [zero](#zero)
  - [one](#one)
  - [copy](#copy)
  - [from](#from)
  - [from_vec2](#from_vec2)
  - [as_vec2](#as_vec2)
  - [from_vec3](#from_vec3)
  - [as_vec3](#as_vec3)
  - [+](#+)
  - [add](#add)
  - [add_vec2](#add_vec2)
  - [add_vec3](#add_vec3)
  - [add_scalar](#add_scalar)
  - [plus](#plus)
  - [plus_scalar](#plus_scalar)
  - [-](#-)
  - [sub](#sub)
  - [sub_scalar](#sub_scalar)
  - [subtract](#subtract)
  - [subtract_scalar](#subtract_scalar)
  - [*](#*)
  - [mul](#mul)
  - [mul_scalar](#mul_scalar)
  - [multiply](#multiply)
  - [multiply_scalar](#multiply_scalar)
  - [/](#/)
  - [div](#div)
  - [div_scalar](#div_scalar)
  - [divide](#divide)
  - [divide_scalar](#divide_scalar)
  - [magnitude](#magnitude)
  - [dot](#dot)
  - [cross_xyz](#cross_xyz)
  - [unit](#unit)
  - [perpendicular](#perpendicular)
  - [project](#project)
  - [eq](#eq)
  - [eq_epsilon](#eq_epsilon)
  - [eq_approx](#eq_approx)
  - [is_approx_zero](#is_approx_zero)
  - [eq_scalar](#eq_scalar)
  - [distance](#distance)
  - [manhattan_distance](#manhattan_distance)
  - [abs](#abs)
  - [clean](#clean)
  - [clean_tolerance](#clean_tolerance)
  - [inv](#inv)
  - [normalize](#normalize)
  - [sum](#sum)
- [Vec2](#Vec2)
- [Vec3](#Vec3)
- [Vec4](#Vec4)

## Constants
[[Return to contents]](#Contents)

## vec2
[[Return to contents]](#Contents)

## vec3
[[Return to contents]](#Contents)

## vec4
[[Return to contents]](#Contents)

## Vec2[T]
## zero
[[Return to contents]](#Contents)

## one
[[Return to contents]](#Contents)

## copy
[[Return to contents]](#Contents)

## from
[[Return to contents]](#Contents)

## from_vec3
[[Return to contents]](#Contents)

## as_vec3
[[Return to contents]](#Contents)

## from_vec4
[[Return to contents]](#Contents)

## as_vec4
[[Return to contents]](#Contents)

## +
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add_scalar
[[Return to contents]](#Contents)

## plus
[[Return to contents]](#Contents)

## plus_scalar
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## sub_scalar
[[Return to contents]](#Contents)

## subtract
[[Return to contents]](#Contents)

## subtract_scalar
[[Return to contents]](#Contents)

## *
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## mul_scalar
[[Return to contents]](#Contents)

## multiply
[[Return to contents]](#Contents)

## multiply_scalar
[[Return to contents]](#Contents)

## /
[[Return to contents]](#Contents)

## div
[[Return to contents]](#Contents)

## div_scalar
[[Return to contents]](#Contents)

## divide
[[Return to contents]](#Contents)

## divide_scalar
[[Return to contents]](#Contents)

## magnitude
[[Return to contents]](#Contents)

## magnitude_x
[[Return to contents]](#Contents)

## magnitude_y
[[Return to contents]](#Contents)

## dot
[[Return to contents]](#Contents)

## cross
[[Return to contents]](#Contents)

## unit
[[Return to contents]](#Contents)

## perp_cw
[[Return to contents]](#Contents)

## perp_ccw
[[Return to contents]](#Contents)

## perpendicular
[[Return to contents]](#Contents)

## project
[[Return to contents]](#Contents)

## eq
[[Return to contents]](#Contents)

## eq_epsilon
[[Return to contents]](#Contents)

## eq_approx
[[Return to contents]](#Contents)

## is_approx_zero
[[Return to contents]](#Contents)

## eq_scalar
[[Return to contents]](#Contents)

## distance
[[Return to contents]](#Contents)

## manhattan_distance
[[Return to contents]](#Contents)

## angle_between
[[Return to contents]](#Contents)

## angle_towards
[[Return to contents]](#Contents)

## angle
[[Return to contents]](#Contents)

## abs
[[Return to contents]](#Contents)

## clean
[[Return to contents]](#Contents)

## clean_tolerance
[[Return to contents]](#Contents)

## inv
[[Return to contents]](#Contents)

## normalize
[[Return to contents]](#Contents)

## sum
[[Return to contents]](#Contents)

## Vec3[T]
## zero
[[Return to contents]](#Contents)

## one
[[Return to contents]](#Contents)

## copy
[[Return to contents]](#Contents)

## from
[[Return to contents]](#Contents)

## from_vec2
[[Return to contents]](#Contents)

## as_vec2
[[Return to contents]](#Contents)

## from_vec4
[[Return to contents]](#Contents)

## as_vec4
[[Return to contents]](#Contents)

## +
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add_vec2
[[Return to contents]](#Contents)

## add_scalar
[[Return to contents]](#Contents)

## plus
[[Return to contents]](#Contents)

## plus_vec2
[[Return to contents]](#Contents)

## plus_scalar
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## sub_scalar
[[Return to contents]](#Contents)

## subtract
[[Return to contents]](#Contents)

## subtract_scalar
[[Return to contents]](#Contents)

## *
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## mul_scalar
[[Return to contents]](#Contents)

## multiply
[[Return to contents]](#Contents)

## multiply_scalar
[[Return to contents]](#Contents)

## /
[[Return to contents]](#Contents)

## div
[[Return to contents]](#Contents)

## div_scalar
[[Return to contents]](#Contents)

## divide
[[Return to contents]](#Contents)

## divide_scalar
[[Return to contents]](#Contents)

## magnitude
[[Return to contents]](#Contents)

## dot
[[Return to contents]](#Contents)

## cross
[[Return to contents]](#Contents)

## unit
[[Return to contents]](#Contents)

## perpendicular
[[Return to contents]](#Contents)

## project
[[Return to contents]](#Contents)

## eq
[[Return to contents]](#Contents)

## eq_epsilon
[[Return to contents]](#Contents)

## eq_approx
[[Return to contents]](#Contents)

## is_approx_zero
[[Return to contents]](#Contents)

## eq_scalar
[[Return to contents]](#Contents)

## distance
[[Return to contents]](#Contents)

## manhattan_distance
[[Return to contents]](#Contents)

## angle_between
[[Return to contents]](#Contents)

## abs
[[Return to contents]](#Contents)

## clean
[[Return to contents]](#Contents)

## clean_tolerance
[[Return to contents]](#Contents)

## inv
[[Return to contents]](#Contents)

## normalize
[[Return to contents]](#Contents)

## sum
[[Return to contents]](#Contents)

## Vec4[T]
## zero
[[Return to contents]](#Contents)

## one
[[Return to contents]](#Contents)

## copy
[[Return to contents]](#Contents)

## from
[[Return to contents]](#Contents)

## from_vec2
[[Return to contents]](#Contents)

## as_vec2
[[Return to contents]](#Contents)

## from_vec3
[[Return to contents]](#Contents)

## as_vec3
[[Return to contents]](#Contents)

## +
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add_vec2
[[Return to contents]](#Contents)

## add_vec3
[[Return to contents]](#Contents)

## add_scalar
[[Return to contents]](#Contents)

## plus
[[Return to contents]](#Contents)

## plus_scalar
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## sub_scalar
[[Return to contents]](#Contents)

## subtract
[[Return to contents]](#Contents)

## subtract_scalar
[[Return to contents]](#Contents)

## *
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## mul_scalar
[[Return to contents]](#Contents)

## multiply
[[Return to contents]](#Contents)

## multiply_scalar
[[Return to contents]](#Contents)

## /
[[Return to contents]](#Contents)

## div
[[Return to contents]](#Contents)

## div_scalar
[[Return to contents]](#Contents)

## divide
[[Return to contents]](#Contents)

## divide_scalar
[[Return to contents]](#Contents)

## magnitude
[[Return to contents]](#Contents)

## dot
[[Return to contents]](#Contents)

## cross_xyz
[[Return to contents]](#Contents)

## unit
[[Return to contents]](#Contents)

## perpendicular
[[Return to contents]](#Contents)

## project
[[Return to contents]](#Contents)

## eq
[[Return to contents]](#Contents)

## eq_epsilon
[[Return to contents]](#Contents)

## eq_approx
[[Return to contents]](#Contents)

## is_approx_zero
[[Return to contents]](#Contents)

## eq_scalar
[[Return to contents]](#Contents)

## distance
[[Return to contents]](#Contents)

## manhattan_distance
[[Return to contents]](#Contents)

## abs
[[Return to contents]](#Contents)

## clean
[[Return to contents]](#Contents)

## clean_tolerance
[[Return to contents]](#Contents)

## inv
[[Return to contents]](#Contents)

## normalize
[[Return to contents]](#Contents)

## sum
[[Return to contents]](#Contents)

## Vec2
[[Return to contents]](#Contents)

## Vec3
[[Return to contents]](#Contents)

## Vec4
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
