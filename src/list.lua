List = {}
List.__index  = List

function List.new(args)
    local this =
    {
        x = args.x,
        y = args.y,
        width = args.width or 1000,
        labels = args.labels,
        values = args.values or {},
        align = args.align or "left"
    }

    setmetatable(this, List)

    return this
end

function List:Drawv()
    love.graphics.setFont(Font.monogram_16)
    local f = love.graphics.getFont()
    local h = f:getHeight()

    local topOffset = self.y

    for _, v in ipairs(self.labels) do
        love.graphics.printf(v, self.x, topOffset + 4, self.width, self.align)
        topOffset = topOffset + h
    end

    topOffset = self.y
    for _, v in ipairs(self.values) do
        love.graphics.print(v, self.x + self.width + 2, topOffset + 4)
        topOffset = topOffset + h
    end
end