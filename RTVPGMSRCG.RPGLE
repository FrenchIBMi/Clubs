     h copyright('Volubis')

     Dusrspc           s             20    inz('RTVPGMSRC QTEMP')

     Dcompteur         s              3  0

     Dpointeur         s               *
     Dptrinfos         s               *
     Dinfosliste       ds                  based(ptrinfos)
     D  offset                       10i 0
     D  taille                       10i 0
     D  nbpostes                     10i 0
     D  lgposte                      10i 0

     dptrliste         s               *
     DPGML0100         ds                  based(ptrliste)
     d  pgm                          10
     d  bib                          10
     d  module                       10
     d  bibmodule                    10
     d  srcf                         10
     d  srcl                         10
     d  srcm                         10
     d  attribut                     10


     dQBNLPGMI         PR                  EXTPGM('QBNLPGMI')
     d  space                        20
     d  format                        8    const
     d  pgmlib                       20    const
     d  erreur                        8    const

     dQUSPTRUS         PR                  EXTPGM('QUSPTRUS')
     d  space                        20
     d  ptr                            *


     C     *entry        plist
     C                   parm                    pgmlib           20
     C                   parm                    demande           3 0
     C                   parm                    wsrcf            10
     C                   parm                    wsrcl            10
     C                   parm                    wsrcm            10
     C                   parm                    wnbr              3 0




     c                   callp     QBNLPGMI(usrspc : 'PGML0100' :
     c                                     pgmlib : x'0000000000000000')

     c                   callp     QUSPTRUS(usrspc : pointeur)


      * gestion de la liste (positionnement sur la partie entête)
     c                   eval      ptrinfos = pointeur + 124

      * positionnement sur le premier poste
     c                   eval      ptrliste = pointeur + offset

     c                   eval      wnbr = nbpostes

      * boucle (nbpostes fois)
     c                   do        nbpostes
     c                   eval      compteur = compteur + 1
     c                   if        compteur > 1
     c                   eval      ptrliste = ptrliste + lgposte
     c                   endif
      * recherche si N° de module = N° demandé
     c                   if        compteur = demande
     c                   eval      wsrcf = srcf
     c                   eval      wsrcl = srcl
     c                   eval      wsrcm = srcm
     c                   leave
     c                   endif
     c                   enddo

     c                   eval      *inLR = *On                
