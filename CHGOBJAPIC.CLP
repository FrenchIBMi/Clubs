/* Setup : CRTCLPGM CHGOBJAPIC, puis                             */
/* CRTCMD CHGOBJAPI PGM(CHGOBJAPIC)                              */
/*===============================================================*/  

             PGM        PARM(&OBJQ &OBJT &SRCELEM &SRCDATE +
                          &COMPILELEM &PRDELEM &OPTION &ATTRIB +
                          &COMPOS &ALWCHG)

             DCL        VAR(&OBJQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OBJT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCELEM) TYPE(*CHAR) LEN(32)
             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)
             DCL        VAR(&COMPILELEM) TYPE(*CHAR) LEN(15)
             DCL        VAR(&PRDELEM) TYPE(*CHAR) LEN(15)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ATTRIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMPOS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ALWCHG) TYPE(*CHAR) LEN(1)

             DCL        VAR(&RTNLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CODERR) TYPE(*CHAR) LEN(4) +
                          VALUE(X'00000000')
             DCL        VAR(&NBR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&VAR2000) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&X41) TYPE(*CHAR) LEN(1) VALUE(X'41')
             DCL        VAR(&DEP) TYPE(*DEC) LEN(4 0) VALUE(5)
 /* VARIABLES UTILISEES PAR LA GESTION DE MESSAGES */
             DCL        &ERRORSW *LGL                     /* SWITCH  */
             DCL        &MSGID *CHAR LEN(7)               /* ID MSG  */
             DCL        &MSGDTA *CHAR LEN(100)            /* DATA    */
             DCL        &MSGF *CHAR LEN(10)               /* FICHIER */
             DCL        &MSGFLIB *CHAR LEN(10)            /* BIBLI   */

             MONMSG     MSGID(CPF0000) EXEC(GOTO ERREUR)

 /* CORPS DU PROGRAMME */

 /*============================================================*/
 /* CHAQUE ATTRIBUT modifiable est identifié par une clé       */
 /* 1 pour le source, 2 pour la date, 3 le compilateur, etc... */
 /* L'ensemble des modifications à faire est placé à la suite  */
 /* dans une seule chaîne (ici VAR2000) structurée comme suit: */
 /* 1 à  4 = clé (en binaire)                                  */
 /* 5 à  8 = lg des data (en binaire)                          */
 /* data de la modif (suivant la clé)                          */
 /*============================================================*/


/* SOURCE*/ IF (%BIN(&SRCELEM 1 2) > 1) DO
               IF (%SST(&SRCELEM 3 5) ^= '*SAME')  THEN(DO)
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 1  /* CLE 1 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 30  /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %SST(&VAR2000 &DEP 30) %SST(&SRCELEM 3 30)
               CHGVAR &DEP (&DEP + 30)
               ENDDO
             ENDDO

/* DATE */   IF (&SRCDATE ^= '*SAME') THEN(DO)
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 2  /* CLE 2 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 13  /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %SST(&VAR2000 &DEP 13) &SRCDATE
               CHGVAR &DEP (&DEP + 13)
             ENDDO

/* COMPIL*/ IF (%BIN(&COMPILELEM 1 2) > 0) DO
               IF (%SST(&COMPILELEM 3 5) ^= '*SAME')  THEN(DO)
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 3   /* CLE 3 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 13   /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               IF (%SST(&COMPILELEM 3 5) = '*BLANK')    +
                 CHGVAR %SST(&VAR2000 &DEP 13) '             '
               ELSE +
                 CHGVAR %SST(&VAR2000 &DEP 13) %SST(&COMPILELEM 3 13)
               CHGVAR &DEP (&DEP + 13)
               ENDDO
             ENDDO

/* PROD  */ IF (%BIN(&PRDELEM 1 2) > 0) DO
               IF (%SST(&PRDELEM 3 5) ^= '*SAME')  THEN(DO)
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 5   /* CLE 5 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 13   /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               IF (%SST(&PRDELEM 3 5) = '*BLANK')    +
                 CHGVAR %SST(&VAR2000 &DEP 13) '             '
               ELSE +
                 CHGVAR %SST(&VAR2000 &DEP 13) %SST(&PRDELEM 3 13)
               CHGVAR &DEP (&DEP + 13)
               ENDDO
             ENDDO

/* OPTION*/ IF (%SST(&OPTION 1 1) ^= &X41) DO
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 13  /* CLE 13 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 2    /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %SST(&VAR2000 &DEP 2) &OPTION
               CHGVAR &DEP (&DEP + 2)
             ENDDO

/* ATTRIB*/ IF (%SST(&ATTRIB 1 1) ^= &X41) DO
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 9  /* CLE 9 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 10   /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %SST(&VAR2000 &DEP 10) &ATTRIB
               CHGVAR &DEP (&DEP + 10)
             ENDDO

/* COMPOS*/ IF (%SST(&COMPOS 1 1) ^= &X41) DO
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 14  /* CLE 14 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 4   /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %SST(&VAR2000 &DEP 4) &COMPOS
               CHGVAR &DEP (&DEP + 4)
             ENDDO

/* MODIF */ IF (&ALWCHG ^= '2') DO
               CHGVAR &NBR (&NBR + 1)
               CHGVAR %BIN(&VAR2000 &DEP 4) 8  /* CLE 8 */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %BIN(&VAR2000 &DEP 4) 1   /* LG INFOS */
               CHGVAR &DEP (&DEP + 4)
               CHGVAR %SST(&VAR2000 &DEP 1) &ALWCHG
             ENDDO
/* de 1 à 4, en binaire, nbr de modifs à faire */
             CHGVAR     VAR(%BIN(&VAR2000 1 4)) VALUE(&NBR)
             CALL QLICOBJD PARM(      +
                           &RTNLIB    +
                           &OBJQ      +
                           &OBJT      +
                           &VAR2000   +
                           &CODERR)

 /* RENVOI DES MESSAGES DE TYPE *COMP SI FIN NORMALE */
 COMPMSG:    RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
             IF         (&MSGID *EQ '       ') RETURN  /* FIN DU PGM */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*COMP)
             GOTO       COMPMSG /* BOUCLE SUR MESSAGES *COMP      */

              /*----------------------------------------*/
 ERREUR:      /*        GESTION DES ERREURS             */
              /*----------------------------------------*/
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9899) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE) /* 2EME FOIS*/
                                                         /* ARRET PGM*/
             CHGVAR     &ERRORSW '1' /* MISE EN PLACE DU SWTICH     */

 /* RENVOI DES MESSAGES DE TYPE *DIAG SI FIN ANORMALE */
 DIAGMSG:    RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
             IF         (&MSGID *EQ '       ') GOTO EXCPMSG
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       DIAGMSG /* BOUCLE SUR MESSAGES *DIAG      */

 /* RENVOI DU MESSAGE D'ERREUR                        */
 EXCPMSG:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             ENDPGM 