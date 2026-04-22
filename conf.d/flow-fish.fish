if status is-interactive
    if functions -q __pure_key_bindings
        __pure_key_bindings
    end

    bind \r ai_transform
    bind enter ai_transform
end
