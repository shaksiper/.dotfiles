-- require("lightspeed").setup({})
require("leap").add_default_mappings()
require('leap').opts.equivalence_classes = { ' \t\r\n'}
require("leap-spooky").setup({
    affixes = {
        -- Mappings will be generated corresponding to all native text objects,
        -- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.

        -- Special line objects will also be added, by repeating the affixes.
        -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
        -- window.

        -- The cursor moves to the targeted object, and stays there.
        magnetic = { window = "m", cross_window = "M" },
        -- The operation is executed seemingly remotely (the cursor boomerangs
        -- back afterwards).
        remote = { window = "r", cross_window = "R" },
    },
    -- If this option is set to true, the yanked text will automatically be pasted
    -- at the cursor position if the unnamed register is in use.
    paste_on_remote_yank = true,
})
require("flit").setup()
