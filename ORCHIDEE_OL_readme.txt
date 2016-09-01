!**************************************************************
! Author: Rachid Benshila
! Contact: rbipsl@ipsl.jussieu.fr
! $Date: 2011/09/12 12:17:41 $
! $Name: ATLAS_672_1_1 $
! $Revision: 1.1.1.10 $
! History:
! Modification:
!
!**************************************************************

****************************************************************************************

                          diagnostics ORCHIDEE off-line :

****************************************************************************************

Il s'agit de 4 scripts ferret utilisant FAST destines a des diagnostics sur une annee de
simulation sur UN POINT pour des sorties toutes les 30 minutes.

****************************************************************************************

3winsize.jnl : utilitaire calculant le maximum absolu de 3 champs 1D (peut etre plutot 
destine a rejoindre FAST), est appele pour dimensionner les fenetres de trace.

****************************************************************************************

ORCHIDEE_3sbxdif.jnl : calcule la moyenne glissante (1/48) pour une annee de simulation
pour trois champs, trace les trois moyennes sur le meme graphique, trace au dessous la 
des champs 2 et 3 avec le champ 1 de reference.

****************************************************************************************

month2day_3plot.jnl : calcule pour un mois donne un jour type pour 3 champs et les trace
sur un meme graphique.

****************************************************************************************

ORCHIDEE_12day.jnl : appelle month2day_3plot pour les 12 mois, et partitionne la fenetre
en 12.

****************************************************************************************

contact : rbipsl@ipsl.jussieu.fr
