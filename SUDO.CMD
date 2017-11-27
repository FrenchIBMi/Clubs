             CMD        PROMPT('lancer une commande en QSECOFR')

             PARM       KWD(CMD) TYPE(*CMDSTR) MIN(1) +
                          PROMPT('Commande à lancer')
             PARM       KWD(USER) TYPE(*NAME) DFT(QSECOFR) +
                          PROMPT('Profil Utilisateur')
             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(128) DFT(*PROMPT) +
                          SPCVAL((*PROMPT)) PASSVAL(*DFT) DSPINPUT(*NO) +
                           PROMPT('Mot de passe ou *PROMPT')                                            
