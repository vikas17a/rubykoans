# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  sort = [a, b, c].sort
  if [a,b,c].any? {|x| x <= 0}
        raise TriangleError, "Sides length must be greater than zero"
  elsif sort[0] + sort[1] <= sort[2]
        raise TriangleError, "Do not satisfy triangle property"
  elsif a == b && a == c
	return :equilateral
  elsif a == b && b != c
	return :isosceles
  elsif b == c && c != a
	return :isosceles
  elsif a == c && c != b
	return :isosceles
  elsif a != b && b != c && c != a
	return :scalene
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
