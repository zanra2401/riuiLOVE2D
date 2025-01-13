Hcenter = {};
Hcenter.__index = Hcenter;


function Hcenter.new(config)
    local self = setmetatable({}, Hcenter);
    local config = config or {};

    self.settings = {
        position = {x = 0, y = 0},
        width = 0,
        height = 0,
        child = config.child or nil,
        childInfo = {
            drawLoc = {
                x = 0, 
                y = 0
            }
        },
        autoLayout = true
    };

    return self;
end

function Hcenter:init(parent) 
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

    if self.settings.child ~= nil then
        local child = self.settings.child:init(self);
        self.settings.childInfo.height = child.height;
        self.settings.childInfo.width = child.width;
    end

    if self.parent.settings.falseParent then
        local widthWindow, heightWindow = love.graphics.getDimensions();
        self.settings.width = widthWindow;
        self.settings.height = self.settings.childInfo.height;
    else
        self.settings.width = self.settings.parent.settings.width;
        self.settings.height = self.settings.childInfo.height or 0;
    end
end

function Hcenter:draw() 
    
    self.settings.childInfo.drawLoc = {
        x = ((self.settings.position.x + self.settings.width) / 2) - (self.settings.childInfo.width / 2),
        y = self.settings.position.y
    }

    self.settings.child:draw(self);
end

return Hcenter;