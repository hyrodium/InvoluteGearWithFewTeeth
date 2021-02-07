using Luxor
using MeshIO
using GeometryBasics
using FileIO

struct CyclicVector{T<:AbstractVector}
    vector::T
end
Base.length(v::CyclicVector) = length(v.vector)
Base.getindex(v::CyclicVector,i) = v.vector[mod(i-1,length(v))+1]
Base.eachindex(v::CyclicVector) = eachindex(v.vector)
Base.vec(v::CyclicVector) = vec(v.vector)

function involute(t)
    x = cos(t)+t*sin(t)
    y = sin(t)-t*cos(t)
    return [x,y]
end

function point(x,y;ul=50)
    return Luxor.Point(ul*x,-ul*y)
end

f(t) = sin(t)-t*cos(t)
g(t) = t*sin(t)
newton(t) = t-f(t)/g(t)

t0 = 4.5
const T = newton(newton(newton(newton(t0))))

M = 180
_ps = [involute(T*sqrt(i/(M÷2))) for i in 0:(M÷2)]
_ps[end] = [_ps[end][1],0.0]
append!(_ps,[[1,-1].*_ps[i] for i in (M÷2):-1:2])
ps = CyclicVector(_ps)
cs = CyclicVector([[cospi(2i/M),sinpi(2i/M)] for i in 0:M-1])
_qs = [involute(T*sqrt((i-1/2)/(M÷2))) for i in 1:(M÷2)]
append!(_qs,[[1,-1].*_qs[i] for i in (M÷2):-1:1])
qs = CyclicVector(_qs)

facetype=GLTriangleFace
pointtype=Point3f0
normaltype=Vec3f0

N = 180

R(t) = [cos(t) -sin(t);sin(t) cos(t)]

D = 1.5
L = 100
B = 5
Ps = [pointtype([(B*R(3π*j/N)*ps[i])...,L*j/N]) for i in eachindex(ps), j in 0:N]
Qs = [pointtype([(B*R(3π*(j-1/2)/N)*qs[i])...,L*(j-1/2)/N]) for i in eachindex(qs), j in 1:N]
Cs = [pointtype([D*cs[i]...,j*L]) for i in eachindex(qs), j in 0:1]

points = vcat(vec(Ps),vec(Qs),vec(Cs))
faces01 = [TriangleFace{Int}(i+(j-1)*M, mod(i,M)+1+(j-1)*M, i+(N+1)*M+(j-1)*M) for i in 1:M, j in 1:N]
faces02 = [TriangleFace{Int}(mod(i,M)+1+j*M, i+j*M, i+(N+1)*M+(j-1)*M) for i in 1:M, j in 1:N]
faces03 = [TriangleFace{Int}(i+j*M, i+(j-1)*M, i+(N+1)*M+(j-1)*M) for i in 1:M, j in 1:N]
faces04 = [TriangleFace{Int}(mod(i,M)+1+(j-1)*M, mod(i,M)+1+j*M, i+(N+1)*M+(j-1)*M) for i in 1:M, j in 1:N]
faces05 = [TriangleFace{Int}(mod(i,M)+1+M*(N+1)+M*N, i+M*(N+1)+M*N, i+M*(N+1)+M*N+M) for i in 1:M]
faces06 = [TriangleFace{Int}(i+M*(N+1)+M*N+M, mod(i,M)+1+M*(N+1)+M*N+M, mod(i,M)+1+M*(N+1)+M*N) for i in 1:M]
faces07 = [TriangleFace{Int}(i+M*(N+1)+M*N, mod(i,M)+1+M*(N+1)+M*N, i) for i in 1:M]
faces08 = [TriangleFace{Int}(mod(i,M)+1, i, mod(i,M)+1+M*(N+1)+M*N) for i in 1:M]
faces09 = [TriangleFace{Int}(mod(i,M)+1+M*(N+1)+M*N+M, i+M*(N+1)+M*N+M, mod(i+M÷2,M)+1+M*N) for i in 1:M]
faces10 = [TriangleFace{Int}(mod(i+M÷2,M)+1+M*N, mod(i+M÷2+1,M)+1+M*N, mod(i,M)+1+M*(N+1)+M*N+M) for i in 1:M]

faces = vcat(vec(faces01),vec(faces02),vec(faces03),vec(faces04),vec(faces05),vec(faces06),vec(faces07),vec(faces08),vec(faces09),vec(faces10))
m = Mesh(meta(points), faces)
save("inv.stl", m)
