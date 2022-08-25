function start(song) -- do nothing

end

function update(elapsed)

        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorY(_G['defaultStrum'..i..'Y'] + 48 * math.cos((currentBeat + i*0.375) * math.pi), i)
		end
   
end

function beatHit(beat) -- do nothing

end

function stepHit(step) -- do nothing
    if step == 2128 then
        strumLine1Visible = false
    end
end

