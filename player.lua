pulseX = 0 --Memory Location 0x0713
pulseY = 0 --Memory Location 0x070C
pulseTrig = 0 --Memory Location 0x0712
playerX = 0 --Memory Location 0x070F
playerY = 0 --Memory location 0x07
ButtonNames = {
    'A',
    'B',
    'Left',
    'Right'
}
red = 0xFFFF0000
green = 0xFF00FF00
blue = 0xFF0000FF

boxEdge = 100
nesHeight = 240
nesWidth = 255
pulsePos = {}
enemyPulse = {}
enemyPulsePos = {}
-------------Getters--------------------
function checkEnemyPulse()
    enemyPulse[0] = mainmemory.readbyte(0x0716)
    enemyPulse[1] = mainmemory.readbyte(0x071A)
    enemyPulse[2] = mainmemory.readbyte(0x071E)
    enemyPulse[3] = mainmemory.readbyte(0x0722)
    enemyPulse[4] = mainmemory.readbyte(0x0726)
end
function getEnemyPulsePos(i)
    local pos = {}
    pos[0] = mainmemory.readbyte(0x0717 + i*4)
    pos[1] = mainmemory.readbyte(0x0714 + i*4)
    return pos
end
function checkPulse()
   pulseTrig = mainmemory.readbyte(0x0712);
   return pulseTrig
end
function getPulsePos()
    pulseX = mainmemory.readbyte(0x0713)
    pulseY = mainmemory.readbyte(0x0710)
    pulsePos[0] = pulseX
    pulsePos[1] = pulseY
end
function getPlayerX() 
    return mainmemory.readbyte(0x070F)
end

function getPlayerY()
    return mainmemory.readbyte(0x070C)
end
--------------Getters--------------------

--------------Cell Fns-------------------
cells = {}

function clearCells()
    for i = 1, boxEdge do
        for j = 1, boxEdge do
            cells[j*boxEdge+i] = 0
        end
    end

end

function LoadCells()
    clearCells()
    if(checkPulse() == 0) then
        pos = getPulsePos()
        index = toCellX(pulsePos[0])+toCellY(pulsePos[1])*boxEdge
        cells[index] = 3
    end
    checkEnemyPulse()
    for i = 0, 4 do
        if(enemyPulse[i]==0) then
            pos = getEnemyPulsePos(i)
            index = toCellX(pos[0])+toCellY(pos[1])*boxEdge
            cells[index] = 4
        end
    end
    x = toCellX(getPlayerX())
    y = toCellY(getPlayerY())
    cells[y*boxEdge+x] = 1
    
end

function toCellX(pos)
    return math.floor(pos*boxEdge/nesWidth)
end

function toCellY(pos)
    return math.floor(pos*boxEdge/nesHeight)
end


function WillDrawShit()
     gui.drawRectangle(0,0,100,100,0x33FFFFFF,0x33FFFFFF)
     local val = 0
     for i = 1, boxEdge do
        for j = 1, boxEdge do 
            val = cells[j*boxEdge + i]
            if(val == 3) then
                gui.drawBox(i,j,i+1,j+1,red,red)
            end
            if(val == 4) then
                gui.drawBox(i,j,i+1,j+1,green,green)
            end
        end
    end


     x = toCellX(getPlayerX())
     y = toCellY(getPlayerY())
     
     gui.drawBox(x,y,x+1,y+1,blue,blue)
end
--------------Cell Fns-------------------


-------------Game Loop------------------
while true do
    LoadCells()
    WillDrawShit()
    emu.frameadvance()
end
------------Game Loop------------------
