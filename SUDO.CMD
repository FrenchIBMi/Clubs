             CMD        PROMPT('lancer une commande en QSECOFR')

             PARM       KWD(CMD) TYPE(*CMDSTR) MIN(1) +
                          PROMPT('Commande à lancer')
             PARM       KWD(USER) TYPE(*NAME) DFT(QSECOFR) +
                          PROMPT('Profil Utilisateur')
