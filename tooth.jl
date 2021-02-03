using Luxor

function involute(t)
    x = cos(t)+t*sin(t)
    y = sin(t)-t*cos(t)
    return (x,y)
end

point(x,y;ul=50) = Luxor.Point(ul*x,-ul*y)

begin
    Drawing(1000, 1000, "hello-world.png")
    origin()
    background("white")
    sethue("blue")
    circle(O,50,:stroke)
    sethue("red")
    for t in 0:0.1:4.2
        line(point(involute(t)...),point(involute(t+0.1)...),:stroke)
    end
    fontsize(50)
    finish()
    preview()
end

