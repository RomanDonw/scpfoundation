function on_use(pid)
    useitem(pid)
end

function on_use_on_block(x, y, z, pid, normal)
    useitem(pid)

    return false
end

function useitem(pid)
    
    audio.play_sound_2d("items/scp513_" .. math.random(1, 3), 0.5, 1)
end