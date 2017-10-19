             PGM        PARM(&CMD &PRF)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURCOD) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PRFCOD) TYPE(*CHAR) LEN(12)
             DCL        VAR(&MDPL) TYPE(*INT) VALUE(32)
             DCL        VAR(&ERRCOD) TYPE(*CHAR) LEN(15) +
                          VALUE(X'00000000')
             DCL        VAR(&CCSID) TYPE(*INT) VALUE(-1)


             DCLF       FILE(SU_DSPF)
 /* VARIABLES UTILISEES PAR LA GESTION DE MESSAGES */
             DCL        &ERRORSW *LGL                     /* SWITCH  */
             DCL        &MSGID *CHAR LEN(7)               /* ID MSG  */
             DCL        &MSGDTA *CHAR LEN(100)            /* DATA    */
             DCL        &MSGF *CHAR LEN(10)               /* FICHIER */
             DCL        &MSGFLIB *CHAR LEN(10)            /* BIBLI   */
 /* GESTION DES ERREURS                            */
             MONMSG     MSGID(CPF0000) EXEC(GOTO ERREUR)


             SNDRCVF    RCDFMT(FMT)
             IF &IN03 DO
               SNDPGMMSG  MSG('Commande SUDO annulée') MSGTYPE(*COMP)
               RETURN
             ENDDO


 /* VALIDATION DU  PROFIL ACTUEL */
             CALL QSYGETPH  PARM('*CURRENT' ' ' &CURCOD)
 /* VALIDATION DU  PROFIL DEMANDÉ */
             CALL QSYGETPH  PARM(&PRF &PWD &PRFCOD &ERRCOD &MDPL &CCSID)


 /* CHANGEMENT DE PROFIL */
             CALL QWTSETP  PARM(&PRFCOD)
             CALL QCMDEXC  PARM(&CMD 256)


 /* RETOUR AU PROFIL D'ORIGINE */
             CALL QWTSETP  PARM(&CURCOD)
/* ANNULATION DES VALIDATIONS DE PROFIL */
             CALL QSYRLSPH  PARM(&PRFCOD)
             CALL QSYRLSPH  PARM(&CURCOD)


             RETURN


              /*----------------------------------------*/
 ERREUR:      /*        GESTION DES ERREURS             */
              /*----------------------------------------*/
           
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE) /* 2EME FOIS*/
                                                         /* ARRET PGM*/
             CHGVAR     &ERRORSW '1' /* MISE EN PLACE DU SWTICH     */


 /* RENVOI DES MESSAGES DE TYPE *DIAG SI FIN ANORMALE */
 DIAGMSG:    RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             IF         (&MSGID *EQ '       ') GOTO EXCPMSG
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       DIAGMSG /* BOUCLE SUR MESSAGES *DIAG      */


 /* RENVOI DU MESSAGE D'ERREUR                        */
 EXCPMSG:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             ENDPGM
    
