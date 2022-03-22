import re

LONGEST_KEY = 1

starters = {
                "SWR":"I",
                "KPWR":"you",
                "KWHR":"he",
                "SKWHR":"she",
                "TWH":"they",
                "TWR":"we",
                "KPWH":"it",
                "STKPWHR":"",
                "STWR": ""
}

are = {
            "SWR":"am",
            "KPWR":"are",
            "KWHR":"is",
            "SKWHR":"is",
            "TWH":"are",
            "TWR":"are",
            "KPWH":"is",
            "STKPWHR":"are",
            "WHAE":"is",
            "WHAU":"are",
            "WHAEU":"am",

            "SKPWE":"is",
            "SKPWU":"are",
            "SKPWEU":"am",

            "STKOE":"is",
            "STKOU":"are",
            "STKOEU":"am",

            "STKPWOE":"is",
            "STKPWOU":"are",
            "STKPWOEU":"am",

            "STHAE":"is",
            "STHAU":"are",
            "STHAEU":"am",

            "STPAE":"is",
            "STPAU":"are",
            "STPAEU":"am",

            "SWHE":"is",
            "SWHU":"are",
            "SWHEU":"am"
}

middles = {
            "A":"really",
            "O":"can't",
            "OE":"don't",
            "E":"just",
            "U":"really",
            "AU":"didn't",
            "AEU":"didn't really",
            "AOU":"really didn't",
            "AOEU":"kinda",
            "AOEUF":"kind of",
            "X":"have",
            "XY":"haven't",
            "YN":"haven't really",
            "Y":"can",
            "XYQ":"really do",
            "YQ":"do",
            "XQ":"just didn't",
            "Q":"can't just",
            "N":"just can't",
            "XYN":"really did",
            "XQN":"did really",
            "XYQN":"ever",
            "XYQNF":"ever just",
            "XN":"did",
            "F":"even",
            "":""
}

what = {
            "WHAE":"what he",
            "WHAU":"what you",
            "WHAEU":"what I",

            "SKPWE":"doesn't he",
            "SKPWU":"don't you",
            "SKPWEU":"don't I",

            "STKOE":"does he",
            "STKOU":"do you",
            "STKOEU":"do I",

            "STKPWOE":"did he",
            "STKPWOU":"did you",
            "STKPWOEU":"did I",

            "STHAE":"that he",
            "STHAU":"that you",
            "STHAEU":"that I",

            "STPAE":"if he",
            "STPAU":"if you",
            "STPAEU":"if I",

            "SWHE":"when he",
            "SWHU":"when you",
            "SWHEU":"when I"
}

ends = {
            "PB":"know",
            "PBT":"know that",
            "*PBT":"know the",
            "PBD":"knew❌",
            "PBTD":"knew that❌",
            "*PBTD":"knew the❌",
            "P":"want",
            "PT":"want to",
            "PTD":"wanted to❌",
            "*PT":"want the",
            "*PTD":"wanted the❌",
            "*P":"wanna❌",
            "RPBL":"make",
            "RPBLT":"make that",
            "*RPBLT":"make the",
            "RPBLD":"made❌",
            "RPBLTD":"made that❌",
            "*RPBLTD":"made the❌",
            "RPL":"remember",
            "RPLD":"remembered❌",
            "RPLT":"remember that",
            "RPLTD":"remembered that❌",
            "*RPLT":"remember the",
            "*RPLTD":"remembered the❌",
            "RPLS":"matter",
            "RPLTS":"matter to",
            "*RPLTS":"matter to",
            "RPLSZ":"mattered❌",
            "RPLTSDZ":"mattered to❌",
            "*RPLTSDZ":"mattered to❌",
            "RBL":"see",
            "RBLT":"see that",
            "*RBLT":"see the",
            "RBLD":"saw❌",
            "RBLTD":"saw that❌",
            "*RBLTD":"saw the❌",
            "BG":"can❌",
            "BGT":"cannot❌",
            "BGD":"could❌",
            "*BGD":"couldn't❌",
            "BL":"believe",
            "BLT":"believe that",
            "*BLT":"believe the",
            "BLD":"believed❌",
            "BLTD":"believed that❌",
            "*BLTD":"believed the❌",
            "D":"had❌",
            "TD": "had to❌",
            "*TD": "had the❌",
            "T":"have❌",
            "TS":"have to❌",
            "*TS":"have the❌",
            "S":"was❌",
            "SZ":"was not❌",
            "SZ":"wasn't❌",
            "PBLGS":"must❌",
            "L":"will❌",
            "LD":"would❌",
            "PBG":"think",
            "PBGT":"think that",
            "*PBGT":"think the",
            "PBGD":"thought❌",
            "PBGTD":"thought that❌",
            "*PBGTD":"thought the❌",
            "PBLG":"find",
            "PBLGT":"find that",
            "*PBLGT":"find the",
            "PBLGD":"found❌",
            "PBLGTD":"found that❌",
            "*PBLGTD":"found the❌",
            "PL":"may❌",
            "PLS":"seem",
            "PLTS":"seem to",
            "*PLTS":"seem like",
            "PLSZ":"seemed❌",
            "PLTSDZ":"seemed to❌",
            "*PLTSDZ":"seemed like❌",
            "PLT":"might❌",
            "RB":"shall❌",
            "RBD":"should❌",
            "RBLG":"try",
            "RBLGT":"try to",
            "*RBLGT":"try the",
            "RBLGD":"tried❌",
            "RBLGTD":"tried to❌",
            "*RBLGTD":"tried the❌",
            "RPBLG":"look",
            "RPBLGT":"look like",
            "*RPBLGT":"look at",
            "RPBLGD":"looked❌",
            "RPBLGTD":"looked like❌",
            "*RPBLGTD":"looked at❌",
            "RL":"recall",
            "RLD":"recalled❌",
            "RLS":"realise",
            "RLTS":"realise that",
            "*RLTS":"realise the",
            "RLSZ":"realised❌",
            "RLTSDZ":"realised that❌",
            "*RLTSDZ":"realised the❌",
            "RP":"were❌",
            "RPBT":"were not❌",
            "*RPBT":"weren't❌",
            "RPT":"were the❌",
            "*RPT":"were the❌",
            "RPB":"understand",
            "RPBD":"understood❌",
            "RPG":"need",
            "RPGT":"need to",
            "*RPGT":"need the",
            "RPGD":"needed❌",
            "RPGTD":"needed to❌",
            "*RPGTD":"needed the❌",
            "LS":"feel",
            "LTS":"feel like",
            "LSZ":"felt❌",
            "LTSDZ":"felt like❌",
            "PBL":"mean",
            "PBLT":"mean that",
            "*PBLT":"mean the",
            "PBLD":"meant❌",
            "PBLTD":"meant that❌",
            "*PBLTD":"meant the❌",
            "BLG":"like",
            "BLGT":"like to",
            "*BLGT":"like the",
            "BLGD":"liked❌",
            "BLGTD":"liked to❌",
            "*BLGTD":"liked the❌",
            "LG":"love",
            "LGT":"love to",
            "*LGT":"love the",
            "LGD":"loved❌",
            "LGTD":"loved to❌",
            "*LGTD":"loved the❌",
            "RBG":"care",
            "RBGD":"cared❌",
            "RBGT":"care about",
            "G":"get",
            "GD":"got❌",
            "GT":"get to",
            "GTD":"got to❌",
            "PLD":"mind❌",
            "RG":"forget",
            "RGD":"forgot❌",
            "RGT":"forget to",
            "RGTD":"forgot to❌",
            "*RGT":"forget the",
            "*RGTD":"forgot the❌",
            "RBS":"wish",
            "RBTS":"wish to",
            "*RBTS":"wish the",
            "RBSZ":"wished❌",
            "RBTSDZ":"wished to❌",
            "*RBTSDZ":"wished the❌",
            "PGS":"expect",
            "PGTS":"expect to",
            "*PGTS":"expect the",
            "PGSZ":"expected❌",
            "PGTSDZ":"expected to❌",
            "*PGTSDZ":"expected the❌",
            "RPBG":"ever❌",
            "B":"be❌",
            "BT":"be the",
            "*BT":"be the",
            "BS":"said❌",
            "BTS":"said to❌",
            "*BTS":"said the❌",
            "BZ":"say",
            "BTZ":"say to",
            "*BTZ":"say the",
            "PLG":"imagine",
            "PLGT":"imagine that",
            "*PLGT":"imagine the",
            "PLGD":"imagined❌",
            "PLGTD":"imagined that❌",
            "*PLGTD":"imagined the",
            "":""
}

def lookup(key):
    assert len(key) <= LONGEST_KEY

    if key[0] == "WHAEUL": return "whale"

    dict = { #Dictionary to convert the numbers
        '1': 'S',
        '2': 'T',
        '3': 'P',
        '4': 'H',
        '5': 'X',
        '6': 'F',
        '7': 'P',
        '8': 'L',
        '9': 'T',
        '0': 'Y',
        'E': 'Q',
        'U': 'N'
    }

    stroke = key[0]

    if '#' in stroke or any(char.isdigit() for char in stroke): #Convert numbers
        for (i, j) in dict.items():
            stroke = stroke.replace(i, j)

    sk = stroke #Start keys
    sw = '' #Start words
    mk = '' #Middle keys
    mw = '' #Middle words
    ek = '' #Ending keys
    ew = '' #Ending words

    midPtrn = ['A', 'O', 'E', 'U', 'X', 'Y', 'Q', 'N', 'F', '-', '*'] #Medials to split the stroke

    for x in midPtrn:
        sk = sk.split(x)[0] #Split stroke at medials to determine start keys
        if x in stroke and not x in '-*':
            mk += x #Add the medial to the middle keys if it is in the stroke

    ek = stroke.replace(sk, '').replace('-', '') #Define end keys (remove start keys from stroke)
    for i in mk: #Remove middle keys
        ek = ek.replace(i, '')

    mk = mk.replace('*', '') #Remove asterisk from middle key

    wk = sk + mk #'What' key (for alternative starters)

    if sk in starters:
        sw = starters[sk] #Assign start words according to starters dictionary

        mkTMP = mk

        while mkTMP != '':                      #Determine middle words by finding
            for i in range(len(mkTMP), 0, -1):  #longest match according to the dictionary
                if mkTMP[:i] in middles:        #and repeat through the remaining keys
                    mw += ' ' + middles[mkTMP[:i]]
                    mkTMP = mkTMP.replace(mkTMP[:i], '')

        " ".join(mw)

    elif wk in what: #If alternative starters are used, no need to determine middle words
        sw = what[wk]
        sk = wk
        mw = ''
    else:
        raise KeyError

    if ek in ["R", "RT", "*RT"]: #Special case for -R
        if ek == "R":
            ew = are[sk] + " ❌"
        elif ek == "RT":
            ew = are[sk] + " not❌"
        elif ek == "*RT":
            ew = are[sk] + "n't❌"
    else: ew = ends[ek]

    if sw in ['he', 'she', 'it', '', 'what he'] and sk != 'STWR': #Special case for does/doesn't
        mw += " "
        if "do " in mw:
            mw = mw.replace("do ", "does ")
        elif "don't " in mw:
            mw = mw.replace("don't ","doesn't ")
        mw = mw[:-1]

        if 'have' in ew and not "does" in mw and not "can't" in mw and not "did" in mw:
            ew = ew.replace('have', 'has') #Special case for have/has
        if 'have' in mw: mw = mw.replace('have', 'has') #Special case for have/has

        if not any(x in mw for x in ['does', 'did', 'can']) and not '❌' in ew and sk != 'STWR' and ew != '': #Pluralise
            if not 'try' in ew: #Special case for "try"
                for i in [' to', ' the', ' about', ' that', ' like', ' at']:
                    lastWord = ""
                    if i in ew:
                        lastWord = i
                        ew = ew.split(i)[0]
                        break
                ew += "s" + lastWord
            else:
                ew = ew.replace('try', 'tries')

    stm = sw + mw

    ret = stm + " " + ew.replace('❌', '')

    return " ".join(ret.split())
