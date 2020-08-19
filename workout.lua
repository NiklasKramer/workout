-- workout: crow outputs
-- shapes (advanced output)
--
-- output 1 = LFO
-- output 2 = envelope
--


local scope = {0,0,0,0}
local rates = {1,1,1,1}
local depths ={1,1,1,1}
local options = {'LFO','RANDOM','OFFSET'}
local outputs = {"LFO","LFO","LFO","LFO"}
local selectedOutput = 1
output1 = 'LFO'
local position = 1
local adjustedRate = {0,0,0,0}
local adjustedDepth = {0,0,0,0}


function init()
  crow.output[1].receive = function(v) out(1,v) end
  crow.output[2].receive = function(v) out(2,v) end
  crow.output[3].receive = function(v) out(3,v) end
  crow.output[4].receive = function(v) out(4,v) end
  
  r = metro.init()
  r.time = 0.05 
  r.event = function()
    crow.output[1].query()
    crow.output[2].query()
    crow.output[3].query()
    crow.output[4].query()
    redraw()
  end
  r:start()
  
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
end

function out(i,v)
  scope[i] = v
end

function redraw()
  screen.clear()
  screen.move(15,20)
  screen.text("OUTPUT "..selectedOutput)
  if options[position] == "LFO" then
    screen.move(15,40)
    screen.text("lfo rate: "..string.format("%.2f",(adjustedRate[selectedOutput])))
    screen.move(15,50)
    screen.text("depth: "..string.format("%.2f",(adjustedDepth[selectedOutput])))
  end
  
  if options[position] == "RANDOM" then
    screen.move(10,40)
    screen.text("random rate: "..string.format("%.1f",rates[selectedOutput]))
  end
  
    if options[position] == "OFFSET" then
    screen.move(10,40)
    screen.text("offset: "..string.format("%.1f",rates[selectedOutput]))
  end
  --screen.text(": "..string.format("%.3f",slew))

  screen.move(2,40)
  screen.line_rel(0,scope[1]*-4)
  screen.stroke()
  screen.move(4,40)
  screen.line_rel(0,scope[2]*-4)
  screen.stroke()
  screen.move(6,40)
  screen.line_rel(0,scope[3]*-4)
  screen.stroke()
  screen.move(8,40)
  screen.line_rel(0,scope[4]*-4)
  screen.stroke()
  screen.update()
end

function key(n,z)
  --if n==2 then
  --  position = position + d
  --  if position < 1 then
  --    position = 1
  --  end
  --  if position > #options then
  --    position = #options
  --  end
  --  print(options[position])
  --  redraw()
  end
  
  
  local selectOutput = 0

function enc(n,d)

  if n==1 then
    selectOutput = selectOutput + d
    if selectOutput < 1 then
      selectOutput = 1
    end
    if selectOutput > 4 then
      selectOutput = 4
    end
    selectedOutput = selectOutput
    print(selectedOutput)
  end

   if n==2 then
    rates[selectedOutput] = rates[selectedOutput] + d
    if rates[selectedOutput] < 1 then
      rates[selectedOutput] = 1 
    end
    if rates[selectedOutput] > 1000 then
      rates[selectedOutput] = 1000 
    end
    adjustedRate[selectedOutput] = (rates[selectedOutput])/100
    updateLFO(selectedOutput, adjustedRate[selectedOutput], adjustedDepth[selectedOutput])
  end
  
  if n==3 then
    depths[selectedOutput] = depths[selectedOutput] + d
     if depths[selectedOutput] < 0 then
      depths[selectedOutput] = 0 
    end
    if depths[selectedOutput] > 500 then
      depths[selectedOutput] = 500 
    end
    --print( depths[selectedOutput])
    adjustedDepth[selectedOutput]=(depths[selectedOutput])/100
    print(adjustedDepth[selectedOutput])
    updateLFO(selectedOutput, adjustedRate[selectedOutput], adjustedDepth[selectedOutput])

  end
  
  redraw()
 
end


function updateLFO(selectedOutput,rate,depth)
    crow.output[selectedOutput].action = "lfo("..rate..","..depth..")"
    crow.output[selectedOutput].execute()
end
  
