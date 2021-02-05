using Luxor

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

N = 6
ps = [involute(T*i/N) for i in 0:N]
ps[end] = [ps[end][1],0.0]
append!(ps,[[1,-1].*ps[i] for i in N:-1:2])

cs = [[cospi(i/N),sinpi(i/N)] for i in 0:2N-1]

qs = [involute(T*(i-1/2)/N) for i in 1:N]
append!(qs,[[1,-1].*qs[i] for i in N:-1:1])

begin
    Drawing(1000, 1000, "tooth.png")
    origin()
    background("white")
    sethue("blue")
    circle(O,50,:stroke)

    sethue("red")
    for i in 1:2N-1
        line(point(ps[i]...),point(ps[i+1]...),:stroke)
    end
    line(point(ps[2N]...),point(ps[1]...),:stroke)

    sethue("green")
    for i in 1:2N-1
        line(point(qs[i]...),point(qs[i+1]...),:stroke)
    end
    line(point(qs[2N]...),point(qs[1]...),:stroke)

    fontsize(50)
    finish()
    preview()
end
