             CMD        PROMPT('Modifier objet via API')
             PARM       KWD(OBJ) TYPE(Q1) MIN(1) PROMPT('Nom d''objet')
 Q1:         QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*LIBL)) +
                          PROMPT('Bibliothèque')
             PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(*ALRTBL *AUTL *BNDIR *CFGL *CHTFMT +
                          *CLD *CLS *CMD *CNNL *COSD *CRG *CRQD *CSI +
                          *CSMAP *CSPTBL *CTLD *DEVD *DTAARA *DTAQ +
                          *EDTD *EXITRG *FCT *FILE *FNTRSC *FNTTBL +
                          *FORMDF *FTR *GSS *IGCDCT *IGCSRT *IGCTBL +
                          *IMGCLG *JOBD *JOBQ *JOBSCD *JRN *JRNRCV +
                          *LIB *LIND *LOCALE *MGTCOL *MENU *MODD +
                          *MSGF *MSGQ *NODGRP *NODL *NTBD *NWID +
                          *NWSCFG *NWSD *OUTQ *OVL *PAGDFB *PAGSEG +
                          *PDFMAP *PDG *PGM *PNLGRP *PRDAVL *PRDDFN +
                          *PRDLOD *PSFCFG *QRYDFN *RCT *SBSD *SCHIDX +
                          *SPADCT *SQLUDT *SQLXSR *SRVPGM *SSND +
                          *SVRSTG *S36 *TBL *TIMZON *USRIDX *USRSPC +
                          *USRPRF *USRQ *VLDL) MIN(1) PROMPT('Type +
                          d''objet')
             PARM       KWD(SOURCE) TYPE(E1) DFT(*SAME) +
                          SNGVAL((*SAME)) PROMPT('Coordonnées +
                          source')
 E1:         ELEM       TYPE(Q2) MIN(1) PROMPT('Fichier source')
             ELEM       TYPE(*NAME) MIN(1) PROMPT('Membre source')
 Q2:         QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*LIBL)) +
                          PROMPT('Bibliothèque')
             PARM       KWD(SRCCHGDATE) TYPE(*CHAR) LEN(13) +
                          DFT(*SAME) PROMPT('Date de modif du source')
             PARM       KWD(COMPIL) TYPE(E2) DFT(*SAME) +
                          SNGVAL((*SAME) (*BLANK)) +
                          PROMPT(COMPILATEUR)
 E2:         ELEM       TYPE(*CHAR) LEN(7) MIN(1) PROMPT('Produit IBM +
                          (57XXnnn)')
             ELEM       TYPE(*CHAR) LEN(6) MIN(1) PROMPT('Version +
                          (VxRyMz)')
             PARM       KWD(PRODUIT) TYPE(E3) DFT(*SAME) +
                          SNGVAL((*SAME) (*BLANK)) PROMPT(PRODUIT)
 E3:         ELEM       TYPE(*CHAR) LEN(7) MIN(1) PROMPT('Produit +
                          (57XXnnn)')
             ELEM       TYPE(*CHAR) LEN(6) MIN(1) PROMPT('Version +
                          (VxRyMz)')
             PARM       KWD(OPTION) TYPE(*CHAR) LEN(2) DFT(*SAME) +
                          RANGE('00' '99') SPCVAL((*BASE 00) (*SAME +
                          X'41')) PROMPT('Option de produit')
             PARM       KWD(ATTRIBUT) TYPE(*CHAR) LEN(10) DFT(*SAME) +
                          SPCVAL((*BLANK '          ') (*SAME X'41')) +
                          PROMPT('Attribut utilisateur')
             PARM       KWD(COMPOSANT) TYPE(*CHAR) LEN(4) DFT(*SAME) +
                          SPCVAL((*BLANK '    ') (*SAME X'41')) +
                          PROMPT('Composant (à définir)')
             PARM       KWD(ALWAPICHG) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(*SAME) SPCVAL((*SAME '2') (*YES '1') +
                          (*NO '0')) PROMPT('Objet modifiable par API') 