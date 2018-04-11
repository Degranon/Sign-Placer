require "/scripts/vec2.lua"

local oldInit = init
local oldUpdate = update
init = function()
  if oldInit then oldInit() end
  self.signDimension = {4, 1}
  self.anchor = {0, 0}

  self.goodPlaceColor = {150, 255, 150, 96}
  self.badPlaceColor = {255, 150, 150, 128}

  self.customSignPath = "/objects/outpost/customsign/signplaceholder.png"
  message.setHandler("drawImagePreview", drawImagePreview)
end

function drawImagePreview(_, _, anchor, data)
    self.anchor = vec2.floor(anchor)

    localAnimator.clearDrawables()
  	sb.setLogMap("^cyan;Sign Folder Name^reset;", data.name)
  	for i = 0, data.wNumber - 1 do
  	  for j = 0, data.hNumber - 1 do
  	    local position = vec2.add(self.anchor, vec2.mul(self.signDimension, {i ,j}))
        localAnimator.addDrawable({
          image = self.customSignPath .. root.assetJson("/"..data.name.."/"..data.name.." ["..i..","..j.."].json").parameters.signData[1],
          position = vec2.sub(position, world.entityPosition(player.id())),
          color = SetColor(position),
          centered = false,
          fullbright = true
        }, "overlay")
  	  end
  	end
  end

  function SetColor(position)
    local temp = position

    -- we need to check 4 blocks for every sign
    for i = 0, self.signDimension[1] - 1 do
      temp = vec2.add(position, {i, 0})
  	-- is there a tile on the background and if it's occupied by other objects / tiles already and the tile is not protected
      if not world.tileIsOccupied(temp, false) or world.tileIsOccupied(temp, true) or world.isTileProtected(temp) then
  	  return self.badPlaceColor
      end
    end

    return self.goodPlaceColor
  end
