def make_plane(voxels, which_coords)
  output = {}

  voxels.each do |voxel|
    point = [voxel[which_coords[0]], voxel[which_coords[1]]]
    value = voxel[which_coords[2]]
    
    ary = output[point] || output[point] = []

    insertion = ary.find_index { |a| a > value } || ary.length

    ary.insert(insertion, value)
  end

  output
end

def count_nontouching_faces(voxels)
  xy_plane = make_plane(voxels, [0,1,2])
  xz_plane = make_plane(voxels, [0,2,1])
  yz_plane = make_plane(voxels, [1,2,0])

  total_faces = voxels.length * 6

  [xy_plane, xz_plane, yz_plane].each do |plane|
    plane.each do |_, third_coord_ary|
      third_coord_ary.each_cons(2) do |a1, a2|
        total_faces -= 2 if a2 - a1 == 1  # they are touching, two faces are hidden
      end
    end
  end

  total_faces
end

def count_exterior_faces(voxels)

  min = voxels.first.dup
  max = voxels.first.dup

  voxels.each do |x, y, z|
    min[0] = x if x < min[0]
    min[1] = y if y < min[1]
    min[2] = z if z < min[2]

    max[0] = x if x > max[0]
    max[1] = y if y > max[1]
    max[2] = z if z > max[2]
  end


  def voxel_neighbors(x, y, z)
    [ [x-1, y,   z  ],
      [x+1, y,   z  ],
      [x,   y-1, z  ],
      [x,   y+1, z  ],
      [x,   y,   z-1],
      [x,   y,   z+1],
    ]
  end

  # create 3d space
  space = Array.new(max[0] - min[0] + 1 + 2) do
    Array.new(max[1] - min[1] + 1 + 2) do
      Array.new(max[2] - min[2] + 1 + 2, 0)
    end
  end

  # fill blob's cubes
  voxels.each do |x, y, z|
    xmin, ymin, zmin = min

    space[x-xmin+1][y-ymin+1][z-zmin+1] = 1
  end

  # start from air
  queue = [[0,0,0]]
  # mark reachable locations
  until queue.empty?
    vox = queue.shift
    x, y, z = vox
    if space.dig(x,y,z) == 0
      space[x][y][z] = 2

      queue.concat(voxel_neighbors(x, y, z))
    end
  end

  bubbles = []

  space.length.times do |x|
    yz = space[x]
    yz.length.times do |y|
      z_ary = yz[y]
      z_ary.length.times do |z|

        if z_ary[z] == 0
          bubbles << [x, y, z]
        end

      end
    end
  end

  count_nontouching_faces(voxels) - count_nontouching_faces(bubbles)
end
