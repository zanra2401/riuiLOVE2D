Vcenter = {};
Vcenter.__index = Vcenter;


function Hcenter.new(config)
    local self = setmetatable({}, Vcenter);
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

function Vcenter:init(parent) 
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
        self.settings.height = heightWindow;
        self.settings.width = self.settings.childInfo.width;
    else
        self.settings.hcenter = self.settings.parent.settings.hcenter;
        self.settings.width = self.settings.childInfo.width or 0;
    end
end

function Vcenter:draw() 
    
    self.settings.childInfo.drawLoc = {
        y = ((self.settings.position.y + self.settings.height) / 2) - (self.settings.childInfo.height / 2),
        x = self.settings.position.y
    }


    self.settings.child:draw(self);
end

return Hcenter;