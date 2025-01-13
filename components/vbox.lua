Vbox = {};
Vbox.__index = Vbox;


function Vbox.new(config)

    local self = setmetatable({}, Vbox);

    self.settings = {
        width = config.width or 0,
        height = 0,
        maxHeight = config.maxHeight or 0,
        position = { x = ((config.position and config.position.x) or 0), y = ((config.position and config.position.y)  or 0)},
        child = config.child or {},
        autoLayout = true,
        yOffset = 0,
        xOffset = 0,
        maxChild = 0,
        align = config.align or 'start',
        gap = config.gap or 0,
        childInfo = {
            longestChild = 0,
            lastPosY = 0,
            child = {},
            drawLoc = {
                x = 0,
                y = 0
            }
        }
    }

    return self;
end

function Vbox:init(parent)

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

    local fullWidth, fullHeight;

    if self.settings.width == 'full' then
        fullWidth = true;
        if not(self.parent.settings.falseParent) then
            self.settings.width = self.parent.settings.width;
        else
            self.settings.width = widthWindow
        end
    elseif type(self.settings.width) == 'table' then
        self.settings.width = self.parent.settings.width * (self.settings.width.number / 100);
    end

    if self.settings.maxHeight == 'full' then
        fullHeight = true;
        if not(self.parent.settings.falseParent) then
            self.settings.maxHeight = self.parent.settings.height;
        else
            self.settings.height = heightWindow
        end
    elseif type(self.settings.height) == 'table' then
        self.settings.maxHeight = self.settings.height.number * (self.settings.height.number / 100);
    end

    
  
    -- init child and set the configuration of vbox layout
    for i,v in ipairs(self.settings.child) do
        local child = v:init(self);

        if not(fullHeight) then
            self.settings.height = self.settings.height + child.height;
    
            if self.settings.maxHeight >= self.settings.height or self.settings.maxHeight == 0 then
                table.insert(self.settings.childInfo.child, child);
                if self.settings.childInfo.longestChild < child.width then
                    self.settings.childInfo.longestChild = child.width;
                end
            else
                self.settings.height = self.settings.maxHeight;
                break;
            end
        else
            table.insert(self.settings.childInfo.child, child);
            if self.settings.childInfo.longestChild < child.width then
                self.settings.childInfo.longestChild = child.width;
            end
        end

        self.settings.maxChild = self.settings.maxChild + 1;
    end
    
    if not(fullHeight) then
        self.settings.height = self.settings.height + (self.settings.gap * (#self.settings.child - 1));
    end

    if not(fullHeight) then
        self.settings.width = self.settings.childInfo.longestChild;
    end
    
    if not(self.parent.settings.falseParent) and not(self.parent.settings.autoLayout) then
        
    end

    return self.settings;
end

function Vbox:draw()

    if not(self.parent.settings.falseParent) then
        if self.parent.settings.autoLayout then
            self.settings.position.x = self.parent.settings.childInfo.drawLoc.x;
            self.settings.position.y = self.parent.settings.childInfo.drawLoc.y;
        else
            self.settings.position.x = self.settings.position.x + self.parent.settings.position.x +  self.parent.settings.padding.l + self.parent.settings.margin.l;
            self.settings.position.y = self.settings.position.y  + self.parent.settings.position.y + self.parent.settings.padding.t + self.parent.settings.margin.t;
        end
        self.settings.childInfo.lastPosY = self.settings.position.y;
    end
    
    if self.settings.align == 'center' then
        for i, v in ipairs(self.settings.child) do
            if i > self.settings.maxChild then
                break;
            end
            self.settings.childInfo.drawLoc = {
                x = ((self.settings.position.x + (self.settings.width/2))  ) - self.settings.childInfo.child[i].width / 2,
                y = i == 1 and self.settings.childInfo.lastPosY or (self.settings.childInfo.lastPosY + self.settings.gap)
            }
            



            v:draw(self, i);
            
            self.settings.childInfo.lastPosY = self.settings.childInfo.drawLoc.y + self.settings.childInfo.child[i].height
        end
    end

    if self.settings.align == 'start' then
        for i, v in ipairs(self.settings.child) do
            if i > self.settings.maxChild then
                break;
            end
            self.settings.childInfo.drawLoc = {
                x = self.settings.position.x,
                y = i == 1 and self.settings.childInfo.lastPosY or (self.settings.childInfo.lastPosY + self.settings.gap)
            }


            
            v:draw(self, i);
            
            self.settings.childInfo.lastPosY = self.settings.childInfo.drawLoc.y + self.settings.childInfo.child[i].height
        end
    end

    if self.settings.align == 'end' then
        for i, v in ipairs(self.settings.child) do
            if i > self.settings.maxChild then
                break;
            end
            self.settings.childInfo.drawLoc = {
                x = self.settings.position.x + self.settings.width - self.settings.childInfo.child[i].width,
                y = i == 1 and self.settings.childInfo.lastPosY or (self.settings.childInfo.lastPosY + self.settings.gap)
            }
            


            v:draw(self, i);
            
            self.settings.childInfo.lastPosY = self.settings.childInfo.drawLoc.y + self.settings.childInfo.child[i].height
        end
    end

    self.settings.position = self.settings.childInfo.drawLoc;
    return self.settings;
end

return Vbox;