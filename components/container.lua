Container = {};
Container.__index = Container;


function Container.new(config, parent)
    local self = setmetatable({}, Container);
    config = config or {};

    self.settings = {
        margin = { t = (config.margin and config.margin.t) or 0, b = (config.margin and config.margin.b) or 0, r = (config.margin and config.margin.r) or 0, l = (config.margin and config.margin.l) or 0},
        padding = { t = (config.padding and config.padding.t) or 0, b = (config.padding and config.padding.b) or 0, r = (config.padding and config.padding.r) or 0, l = (config.padding and config.padding.l) or 0},
        child = config.child or nil,
        position = { x = ((config.position and config.position.x) or 0), y = ((config.position and config.position.y) or 0)},
        width = 0,
        height = 0,
        childInfo = {
          drawLoc = {
            x = ((config.position and config.position.x) or 0), y = ((config.position and config.position.y) or 0)
          }  
        },
        autoLayout = true
    };    

    return self;
end


function Container:init(parent)

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
    
    -- INIT CHILD
    if not(self.settings.child == nil) then
        local child = self.settings.child:init(self);
        self.settings.width = child.width + self.settings.margin.l + self.settings.padding.l;
        self.settings.height = child.height + self.settings.margin.t + self.settings.padding.t;
    end 

   
    -- MENGATUR UKURAN PARENT JIKA TIDAK AUTOLAYOUT
    if not(self.parent.settings.falseParent) and not(self.parent.settings.autoLayout) then
        -- MENGATUR LEBAR PARENT JIKA UKURAN CHILD MELEBIHI PARENT
        if self.settings.position.x + self.settings.width + self.settings.padding.l + self.settings.padding.r + self.settings.margin.l + self.settings.margin.r - self.settings.position.x > self.parent.settings.xOffset and self.parent.settings.width == 'fit' then
            self.parent.settings.xOffset = self.settings.position.x + self.settings.width + self.settings.padding.l + self.settings.padding.r + self.settings.margin.l + self.settings.margin.r - self.parent.settings.position.x;
        end

        -- MENGATUR TINGGI PARENT JIKA UKURAN CHILD MELEBIHI PARENT
        if self.settings.position.y + self.settings.height + self.settings.padding.t + self.settings.padding.b + self.settings.margin.t + self.settings.margin.b - self.settings.position.y > parent.settings.yOffset and parent.settings.height == 'fit' then
            self.parent.settings.yOffset = self.settings.position.y + self.settings.height + self.settings.padding.t + self.settings.padding.b + self.settings.margin.t + self.settings.margin.b - self.parent.settings.position.y;
        end
    end

    return self.settings;
end

function Container:draw()

     -- MENGATUR POSISI DARI COMPONENTS BERDASARKAN AUTOLAYOUT    
    if not(self.parent.settings.autoLayout) then
        self.settings.position.x = self.settings.position.x  + self.parent.settings.position.x;
        self.settings.position.y = self.settings.position.y  + self.parent.settings.position.y;
    else
        -- MENGIKUTI DRAWLOC DARI PARENT
        self.settings.position.x = self.parent.settings.childInfo.drawLoc.x;
        self.settings.position.y = self.parent.settings.childInfo.drawLoc.y;
        self.settings.childInfo.drawLoc = {
            x = self.settings.position.x,
            y = self.settings.position.y
        }
    end

    
    love.graphics.rectangle('line', self.settings.position.x + self.settings.margin.l, self.settings.position.y + self.settings.margin.t, self.settings.width + self.settings.padding.r + self.settings.padding.l, self.settings.height + self.settings.padding.t + self.settings.padding.b);
    
    if not(self.settings.child == nil) then
        self.settings.child:draw();
    end

    -- parent.settings.width = parent.settings.width + self.settings.width + self.settings.padding.l + self.settings.padding.r
    -- parent.settings.height = parent.settings.width + self.settings.height

    return self.settings;
end

return Container;