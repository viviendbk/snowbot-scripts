local RatBonta1 = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "left"},
    {map = "-32,-56", path = "top"},
    {map = "-32,-57", path = "top"},
    {map = "-32,-58", door = "523"},
    {map = "216269574", fight = true, door = "402"},

    {map = "216269572", fight = true, path = "left"},
	{map = "216400644", fight = true, path = "left"},
	{map = "216401668", fight = true, path = "top"},
	{map = "216401670", fight = true, door = "259"},
	{map = "216401672", fight = true, path = "right"},
	{map = "216400648", fight = true, path = "right"},
}

local RatBonta2 = {
    {map = "216269576", fight = true, path = "left"},
    {map = "216400648", fight = true, path = "left"},
    {map = "216401672", fight = true, door = "468"},
    {map = "216269570", fight = true, path = "bottom"},
    {map = "216401668", fight = true, path = "right"},
    {map = "216400644", fight = true, path = "right"},
    {map = "216269572", fight = true, door = "484"},
    {map = "216401670", fight = true, path = "bottom"},
    {map = "216269312", fight = true, path = "left"},
    {map = "216400384", fight = true, path = "left"},
    {map = "216401408", fight = true, door = "520"},
    {map = "216401410", fight = true, door = "215"},
}

local RatBrakmar = {
    {map = "0,0", path = "zaap(212861955)"},
    {map = "-26,37", path = "right"},
    {map = "-25,37", path = "bottom"},
    {map = "-25,38", path = "bottom"},
    {map = "-25,39", door = "233"},
    {map = "216924682", fight = true, path = "right"},
    {map = "216793610", fight = true, path = "right"},
    {map = "216794632", fight = true, door = "262"},
    {map = "216794630", fight = true, path = "right"},
    {map = "216795142", fight = true, path = "top"},
    {map = "216795141", fight = true, path = "left"},
    {map = "216794629", fight = true, path = "top"},
    {map = "216794627", fight = true, path = "top"},
    {map = "216794625", fight = true, path = "left"},
    {map = "216793601", fight = true, path = "left"},
    {map = "216924673", fight = true, door = "466"},
    {map = "219415040", fight = true, path = "left"},
    {map = "216925697", fight = true, path = "left(532)"},
    {map = "216926723", fight = true, door = "534"},
    {map = "216926725", fight = true, path = "bottom"},
    {map = "216926727", fight = true, path = "bottom"},
    {map = "216926729", fight = true, path = "right"},
}

local CanyonSauvage1 = {
    {map = "0,0", path = "zaap(73400320)"},
    {map = "-16,1", path = "bottom"},
    {map = "-16,2", path = "bottom"},
    {map = "-16,3", path = "bottom"},
    {map = "-16,4", path = "bottom"},
    {map = "-16,5", path = "bottom"},
    {map = "-16,6", path = "bottom"},
    {map = "-16,7", path = "left"},
    {map = "-17,7", path = "bottom"},
    {map = "-17,8", path = "bottom"},
    {map = "-17,9", path = "left", fight = true},
    {map = "-18,9", path = "left", fight = true},
    {map = "-19,9", path = "bottom", fight = true},
    {map = "-19,10", path = "bottom", fight = true},
    {map = "-19,11", path = "bottom", fight = true},
    {map = "-19,12", path = "right", fight = true},
    {map = "-18,12", path = "top", fight = true},
    {map = "-18,11", path = "right", fight = true},
    {map = "-17,11", path = "top", fight = true},
    {map = "-17,10", path = "right", fight = true},
    {map = "-16,10", path = "bottom", fight = true},
}

local CanyonSauvage2 = {
    {map = "-16,11", path = "top(4)", fight = true},
}




local TableArea = {
    {Zone = {
        {RatBonta1, "216269576", false}, {RatBonta2, "212599815", false}
    }, MaxMonster = 7, MinMonster = 3, ListeVenteId = {25761, 25767, 25759, 25758}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {RatBrakmar, "216925706", false}
    }, MaxMonster = 7, MinMonster = 3, ListeVenteId = {25762, 25757, 25756, 25760}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {CanyonSauvage1, "-16,11", false}, {CanyonSauvage2, "-16,10", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {8075, 8002, 8077, 8060, 8059, 8062, 8061, 8055, 8054, 8086}, Farmer = false, PourcentageHdv = 0, Stop = false},
}