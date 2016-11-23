# generate data for tests
srand(42)


"""
changes tensor into super symmetric using its pyramidal part
axiliary function for data generation
"""
function symmetrise(m::Array)
  ret = zeros(m)
  for i in product(fill(collect(1:size(m, 1)), ndims(m))...)
    if issorted(i)
      for k in collect(permutations(i))
        ret[k...] = m[i...]
      end
    end
  end
  ret
end


"""
generates 3 mode tensor of size n

output:: array{Float64, 3}, super symmetric array, super symmetric array in
block form
"""
function generatedata(n::Int = 15, seg::Int = 4)
    rmat = randn(n,n,n)
    srmat = symmetrise(rmat)
    rmat, srmat, convert(SymmetricTensor, srmat, seg)
 end


"""
generates exceptions for SymmetricTensor constructor tests

false, false - nullable array with non symmetric diagonal

true - no nulls below diagonal [3,2,1]

false, true - on block not squaerd [1,2,3]
"""
 function create_except(dat::Array, nonull_el::Bool = false, nonsq_box::Bool = false)
 dims = ndims(dat)
    structure = NullableArray(Array{Float64, dims}, fill(4, dims)...)
    for i in product(fill(1:4, dims)...)
       issorted(i)? structure[i...] = dat : ()
    end
    if nonull_el
       structure[reverse(collect(1:dims))...] = dat
    elseif nonsq_box
       structure[collect(1:dims)...] = dat[1:2,:]
    end
    structure
end
