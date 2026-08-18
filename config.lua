config = {

    -- the postal map to read from (relative to resource root)
    postalFile = 'BigDaddy-postals.json',

    -- how often in milliseconds the HUD (compass/street/postal) is recalculated & pushed to NUI
    -- minimum: 50
    updateDelay = 300,

    hud = {
        -- NUI panel position (% from left / % from bottom)
        posX = 15.14,
        posY = 0.963,

        -- accent color for the street name text
        color = { r = 255, g = 20, b = 40 },

        -- only show the HUD while in a vehicle. set to false to always show.
        vehicleOnly = false,
    },

    postal = {
        -- format used for the postal code text in the HUD, %s = code
        format = 'POSTAL %s',
        -- format used for the distance text, %.0f = distance in meters
        distFormat = '%.0fm',
    },

    blip = {
        -- text to display in chat when setting a new /postal route
        blipText = 'Postal Route %s',

        -- blip sprite/color, see https://docs.fivem.net/docs/game-references/blips/
        sprite = 8,
        color = 3,

        -- when the player is this close (in meters) to the destination, the blip is removed
        distToDelete = 100.0,

        deleteText = 'Route deleted',
        drawRouteText = 'Drawing a route to %s',
        notExistText = "That postal doesn't exist",
    },
}
