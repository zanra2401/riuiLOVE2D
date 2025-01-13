Center = {};
Center.__index = Center;


function Center.new(config)
    local self  = setmetatable({}, Center)

    config = config or {};

    self.settings = {
        width = 0,
        height = 0,
        child = config.child or nil,
        autoLayout = true,
        position = {x = 0, y = 0},
        childInfo = {
            drawLoc = {
                x = 0,
                y = 0
            }
        }
    }

    return self;
end

function Center:init(parent)
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
    
    if self.settings.child ~= nill then
        self.settings.child:init(self);
    end

    if self.parent.settings.falseParent then
        local widthWindow, heightWindow = love.graphics.getDimensions();

        self.settings.height = heightWindow;
        self.settings.width = widthWindow;
    else
        self.settings.height = self.parent.settings.height;
        self.settings.width = self.parent.settings.width;
        self.settings.position = self.parent.settings.position;
    end


 
   
end

function Center:draw(parent)   
    self.settings.childInfo.drawLoc = {
        x = ((self.settings.position.x + (self.settings.width/2))  ) - self.settings.child.settings.width / 2,
        y = ((self.settings.position.y + (self.settings.height/2))  ) - self.settings.child.settings.height / 2
    }
 
    self.settings.child:draw(self);
end

return Center;