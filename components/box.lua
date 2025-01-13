Box = {};
Box.__index = Box;


function Box.new(config)
    local self  = setmetatable({}, Box)

    config = config or {};

    self.settings = {
        width = config.width or 0,
        height = config.height or 0,
        position = { x = ((config.position and config.position.x) or 0), y = ((config.position and config.position.y)  or 0)},
        margin = { t = (config.margin and config.margin.t) or 0, b = (config.margin and config.margin.b) or 0, r = (config.margin and config.margin.r) or 0, l = (config.margin and config.margin.l) or 0},
        padding = { t = (config.padding and config.padding.t) or 0, b = (config.padding and config.padding.b) or 0, r = (config.padding and config.padding.r) or 0, l = (config.padding and config.padding.l) or 0},
        child = config.child or {},
        autoLayout = false,
        yOffset = 0,
        xOffset = 0,
        backgroudColor = config.backgroudColor or {1, 1, 1, 0}
    }

    return self;
end


function Box:draw()

    if self.parent.settings.autoLayout then
        self.settings.position.x = self.parent.settings.childInfo.drawLoc.x;
        self.settings.position.y = self.parent.settings.childInfo.drawLoc.y;
    else
        if self.settings.position.x ~= 'left' and self.settings.position.x ~= 'right' then
            self.settings.position.x = self.settings.position.x + self.parent.settings.position.x +  self.parent.settings.padding.l + self.parent.settings.margin.l;
        end

        if self.settings.position.y ~= 'top' and self.settings.position.y ~= 'bottom' then
            self.settings.position.y = self.settings.position.y  + self.parent.settings.position.y + self.parent.settings.padding.t + self.parent.settings.margin.t;
        end

        if self.parent.settings.falseParent then
            if self.settings.position.y == 'top' then
                self.settings.position.y = 0;
            elseif self.settings.position.y == 'bottom' then
                self.settings.position.y = heightWindow - self.settings.height;
            end
        else
            if self.settings.position.x == 'left' then
                self.settings.position.x = self.parent.settings.position.x;
            elseif self.settings.position.x == 'right' then
                self.settings.position.x = (self.parent.settings.position.x + self.parent.settings.width) - self.settings.width;
            end
        end
    end

    

    local drawConfig = {
        self.settings.position.x,
        self.settings.position.y
    };
    
    if self.settings.width == 'fit' then
        table.insert(drawConfig, (self.settings.xOffset) + self.settings.padding.r + self.settings.padding.l);
    else 
        table.insert(drawConfig, self.settings.width);
    end
    
    if self.settings.height == 'fit' then
        table.insert(drawConfig, (self.settings.xOffset) + self.settings.padding.t + self.settings.padding.b);
    else 
        table.insert(drawConfig, self.settings.height);
    end



    love.graphics.setColor(unpack(self.settings.backgroudColor))
    love.graphics.rectangle('fill', unpack(drawConfig))
    
    -- love.graphics.rectangle('line', self.settings.position.x + self.settings.margin.l, self.settings.position.y + self.settings.margin.t, self.settings.width + self.settings.padding.r + self.settings.padding.l, self.settings.height + self.settings.padding.t + self.settings.padding.b);
    -- love.graphics.rectangle('line', self.settings.position.x + self.settings.margin.l, self.settings.position.y + self.settings.margin.t, (self.settings.xOffset) + self.settings.padding.r + self.settings.padding.l, (self.settings.yOffset) + self.settings.padding.t + self.settings.padding.b);
    
    for i, v in ipairs(self.settings.child) do
        v:draw(self, i); 
    end


    return self.settings;
end

function Box:init(parent)

    self.parent = parent or {
        settings = {
            position = {
                x = 0,
                y = 0
            },
            padding = {
                t = 0,
                b = 0,
                l = 0,
                r = 0,
            },
            margin = {
                t = 0,
                b = 0,
                l = 0,
                r = 0,
            },
            falseParent = true
        }
    };
    
    local widthWindow, heightWindow = love.graphics.getDimensions();



    if self.settings.width == 'full' then
        if not(self.parent.settings.falseParent) then
            self.settings.width = self.parent.settings.width;
        else
            self.settings.width = widthWindow
        end
    elseif type(self.settings.width) == 'table' then
        self.settings.width = self.parent.settings.width * (self.settings.width.number / 100);
    end

    if self.settings.height == 'full' then
        if not(self.parent.settings.falseParent) then
            self.settings.height = self.parent.settings.height;
        else
            self.settings.height = heightWindow
        end
    elseif type(self.settings.height) == 'table' then
        self.settings.height = self.settings.height.number * (self.settings.height.number / 100);
    end


    for i, v in ipairs(self.settings.child) do 
        v:init(self);
    end
    
    return self.settings;
end


return Box;