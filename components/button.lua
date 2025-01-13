Button = {};
Button.__index = Button;



function Button.new(config)
    local self = setmetatable({}, Button);
    config = config or {};

    self.settings = {
        width = config.width or 0,
        height = config.height or 0,
        child = config.child or nil,
        radius = config.radius or 0,
        backgroundColor = config.backgroundColor or {1, 1, 1, 0},
        borderColor = config.borderColor or {1, 1, 1, 1},
        lineWidth = config.lineWidth or 2,
        position = { x = ((config.position and config.position.x) or 0), y = ((config.position and config.position.y)  or 0)},
    };
    return self;
end


function Button:init(parent)

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

    
    return self.settings;
end


function Button:draw()
    
    local widthWindow, heightWindow = love.graphics.getDimensions();

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

            if self.settings.position.x == 'left' then
                self.settings.position.x = 0;
            elseif self.settings.position.x == 'right' then
                self.settings.position.x = widthWindow - self.settings.width;
            end
            
        else
            if self.settings.position.y == 'top' then
                self.settings.position.y = 0;
            elseif self.settings.position.y == 'bottom' then
                self.settings.position.y = (self.parent.settings.position.y + self.parent.settings.height) - self.settings.height;
            end

            if self.settings.position.x == 'left' then
                self.settings.position.x = self.parent.settings.position.x;
            elseif self.settings.position.x == 'right' then
                self.settings.position.x = (self.parent.settings.position.x + self.parent.settings.width) - self.settings.width;
            end
        end
    end
    
    print(self.settings.position.x)

    love.graphics.setColor(unpack(self.settings.backgroundColor))
    love.graphics.rectangle("fill", self.settings.position.x, self.settings.position.y, self.settings.width, self.settings.height, self.settings.radius)
    
    love.graphics.setColor(unpack(self.settings.borderColor))
    love.graphics.setLineWidth(self.settings.lineWidth)
    -- Draw the rounded rectangle with built-in function
    love.graphics.rectangle("line", self.settings.position.x, self.settings.position.y, self.settings.width, self.settings.height, self.settings.radius)

    return self.settings;
end

return Button;