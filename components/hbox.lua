Hbox = {};
Hbox.__index = Hbox;


function Hbox.new(config)

    local self = setmetatable({}, Hbox);

    self.settings = {
        width = 0,
        height = config.height or 0,
        maxWidth = config.maxWidth or 0,
        maxChild = 0,
        position = { x = ((config.position and config.position.x) or 0), y = ((config.position and config.position.y)  or 0)},
        child = config.child or {},
        autoLayout = true,
        yOffset = 0,
        xOffset = 0,
        align = config.align or 'start',
        gap = config.gap or 0,
        childInfo = {
            tallestChild = 0,
            lastPosX = 0,
            child = {},
            drawLoc = {
                x = 0,
                y = 0
            }
        }
    }

    return self;
end

function Hbox:init(parent)

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

    local fullWidth;
    local fullHeight;

    if self.settings.maxWidth == 'full' then
        fullWidth = true;
        if not(self.parent.settings.falseParent) then
            self.settings.maxWidth = self.parent.settings.width;
            self.settings.width = self.parent.settings.width;
        else
            self.settings.maxWidth = widthWindow
            self.settings.width = widthWindow
        end
    elseif type(self.settings.width) == 'table' then
        self.settings.maxWidth = self.parent.settings.width * (self.settings.width.number / 100);
    end

    if self.settings.height == 'full' then
        fullHeight = true;
        if not(self.parent.settings.falseParent) then
            self.settings.height = self.parent.settings.height;
        else
            self.settings.height = heightWindow
        end
    elseif type(self.settings.height) == 'table' then
        self.settings.height = self.settings.height.number * (self.settings.height.number / 100);
    end
    
    for i,v in ipairs(self.settings.child) do
        
        local child = v:init(self);
        if not(fullWidth) then
            self.settings.width = self.settings.width + child.width;
            
            if self.settings.width <= self.settings.maxWidth or self.settings.maxWidth == 0 then
                table.insert(self.settings.childInfo.child, child);
                if self.settings.childInfo.tallestChild < child.height then
                    self.settings.childInfo.tallestChild = child.height;
                end
            else
                self.settings.width = self.settings.maxWidth;
                break;
            end
        else
            table.insert(self.settings.childInfo.child, child);
            if self.settings.childInfo.tallestChild < child.height then
                self.settings.childInfo.tallestChild = child.height;
            end
        end
        
        self.settings.maxChild = self.settings.maxChild + 1;
    end

    if not(fullWidth) then
        self.settings.width = self.settings.width + (self.settings.gap * (#self.settings.child - 1));
    end

    if not(fullHeight) then
        self.settings.height = self.settings.childInfo.tallestChild;
    end

    return self.settings;
end

function Hbox:draw()
    
    if not(self.parent.settings.falseParent) then
        if self.parent.settings.autoLayout then
            self.settings.position.x = self.parent.settings.childInfo.drawLoc.x;
            self.settings.position.y = self.parent.settings.childInfo.drawLoc.y;
        else
            self.settings.position.x = self.settings.position.x + self.parent.settings.position.x +  self.parent.settings.padding.l + self.parent.settings.margin.l;
            self.settings.position.y = self.settings.position.y  + self.parent.settings.position.y + self.parent.settings.padding.t + self.parent.settings.margin.t;
        end

        self.settings.childInfo.lastPosX = self.settings.position.x;
    end
    
    if self.settings.align == 'center' then
        for i, v in ipairs(self.settings.child) do

            if i > self.settings.maxChild then
                break;
            end

            self.settings.childInfo.drawLoc = {
                y = ((self.settings.position.y + (self.settings.height/2))  ) - self.settings.childInfo.child[i].height / 2,
                x = i == 1 and self.settings.childInfo.lastPosX or (self.settings.childInfo.lastPosX + self.settings.gap)
            }


            
            v:draw(self, i);
            
            self.settings.childInfo.lastPosX = self.settings.childInfo.drawLoc.x + self.settings.childInfo.child[i].width
        end
    end

    if self.settings.align == 'start' then
        for i, v in ipairs(self.settings.child) do

            if i > self.settings.maxChild then
                break;
            end

            self.settings.childInfo.drawLoc = {
                y = self.settings.position.y,
                x = i == 1 and self.settings.childInfo.lastPosX or (self.settings.childInfo.lastPosX + self.settings.gap)
            }


            
            v:draw(self, i);
            
            self.settings.childInfo.lastPosX = self.settings.childInfo.drawLoc.x + self.settings.childInfo.child[i].width
        end
    end

    if self.settings.align == 'end' then
        for i, v in ipairs(self.settings.child) do

            if i > self.settings.maxChild then
                break;
            end

            self.settings.childInfo.drawLoc = {
                y = self.settings.position.y + self.settings.height - self.settings.childInfo.child[i].height,
                x = i == 1 and self.settings.childInfo.lastPosX or (self.settings.childInfo.lastPosX + self.settings.gap)
            }

            
            v:draw(self, i);
            
            self.settings.childInfo.lastPosX = self.settings.childInfo.drawLoc.x + self.settings.childInfo.child[i].width
        end
    end

    self.settings.position = self.settings.childInfo.drawLoc;


    -- love.graphics.rectangle('fill', self.settings.position.x, self.settings.position.y, self.settings.width, self.settings.height)

    return self.settings;
end

return Hbox;