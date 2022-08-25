-- this gets called starts when the level loads.
frames = 0


function start (song) -- arguments, the song name
    frames = 0
    print('Modchart initialised!')
end

-- this gets called every frame
function update (elapsed) -- arguments, how long it took to complete a frame
    frames = frames + 1
    local currentBeat = (songPos / 1000)*(bpm/60)
    for i=0,7 do
        setActorY(defaultStrum0Y + 20 * math.cos((currentBeat + i*0.5) * math.pi), i)
    end
end

-- this gets called every beat
function beatHit (beat) -- arguments, the current beat of the song
    
end


-- this gets called every step
function stepHit (step) -- arguments, the current step of the song (4 steps are in a beat)
 
        
    
    
end