PRO update_gaps

base = getenv('DATAHOME')
IF base EQ '' THEN $
   message, 'Set $DATAHOME first...'


socn = file_search(base+'/*/*', /test_directory)
soc_seqid = file_basename(socn)

latest = 0
all_ctr = 0
openw, lun2, 'all_gaps.txt', /get_lun
FOR i = 0, n_elements(socn) - 1 DO BEGIN
;   print, i, ' of ', n_elements(socn) -1 
   ; Find the right socname:

;;   IF i LT 1201 THEN continue

   ;; IF strmid(soc_seqid[i], 0, 1) EQ '0' OR $
   ;;    strmid(soc_seqid[i], 0, 1) EQ '2' OR $
   ;;    strmid(soc_seqid[i], 0, 1) EQ '1' THEN BEGIN
   ;;    print, 'Skipping '+soc_seqid[i]
   ;;    CONTINUE
   ;; ENDIF
   
   IF stregex(soc_seqid[i], 'old', /boolean) OR $
      stregex(soc_seqid[i], 'bad', /boolean) OR $
      stregex(soc_seqid[i], 'backup', /boolean) OR $
      stregex(soc_seqid[i], 'fail', /boolean) OR $
      stregex(soc_seqid[i], 'orig', /boolean) OR $
      stregex(soc_seqid[i], 'pre', /boolean) THEN BEGIN
;      print, 'Skipping '+soc_seqid[i]
      CONTINUE
   ENDIF


   evt_gap = socn[i]+'/EVT_gaps.txt'
   evt_gap = socn[i]+'/MET_gaps.txt'

   f = file_info(evt_gap)
   IF ~f.exists THEN CONTINUE

   openr, lun, /get_lun, evt_gap
   input = 'line'
   ctr = 0
   cum_dt = 0
   WHILE ~(eof(lun)) DO BEGIN
      readf, lun, input
      IF ctr GT 0 THEN BEGIN
         fields = strsplit(input, ' ', /extract)
         dt = float(fields[3]) - float(fields[2])

         IF dt gt 5 THEN $
            printf, lun2, soc_seqid[i] + ' ' + string(dt)

         cum_dt += dt

      ENDIF
      ctr += 1
   ENDWHILE
   IF cum_dt GT 0 THEN begin
      push, all_touch, f.mtime
      push, all_socn, socn[i]
      push, all_dt, cum_dt
   ENDIF
   

   close, lun
   free_lun, lun

 
;   print, soc_seqid[i]

ENDFOR

close, lun2
free_lun, lun2

print, 'Total number of observations with gaps: ', n_elements(all_touch) 

sortind = reverse(sort(all_touch))

print, 'Last 10 observations with gaps: '
FOR i = 0, 10 DO BEGIN
   print, all_socn[sortind[i]]
   print, '     Last touched: ',  $
          systime(0, all_touch[sortind[i]])
   print, '     Total gap: ', all_dt[sortind[i]]
ENDFOR


END

