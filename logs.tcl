#
# WWWLIVE (c) roots
# 
# get your Channel(s) live on WWW
# 
# this script make a html page of your channel
# 
# Features:  
#  - multichannel, multiconfigurable
#  - mIRC look, so all lamers will be amazed
#
# inspired by Gateway-TCL v1.31 (c) Zor (klemm@nbnet.nb.ca)
# but programmed completely new, because I wanted the 
# parameters to be more convenient to configure and because there
# was some lack in the design (bugs, not using lrange) 
# ... so i recoded it, faster than improving something, 
# which is very boring also ;)))
#
# (c) roots 1998 (ia174@gm.fh-koeln.de)
#
############################################
#
# Instructions: 
#
# 1.) make sure you set the global parameters on the channel, file
#     of your choice
#
# 2.) adjust the html parameters to your needs
#
# 3.) from your partyline type .wwwlive on || off || help
#
# global parameters
#
set www_channel "#flirtnrw"
set www_file "log.html"
#
# html parameters
#
set www_title "roots live wwwgateway"
set www_bgcolor "#ffffff"
set www_fgcolor "#000000"




##########################################################################
#                 DO NOT CHANGE ANYTHING BELOW HERE                      #
##########################################################################
putlog "--- wwwlive 1.0 by --> roots <-- loaded ---"
putlog "--- type .wwwlive help to get some help ---"


set www_lines 0

proc init {hand idx mode} {
 if {$mode == "on"} { 
  www_htmlheader
  bind pubm * * www_pubm
  bind join * * www_join
  bind part * * www_part
  bind sign * * www_sign
  bind topc * * www_topc
  bind mode * * www_mode
  bind kick * * www_kick
  bind nick * * www_nick
  putlog "--> Initializing wwwlive"
 }  
 if {$mode == "off"} {
  unbind pubm * * www_pubm
  unbind join * * www_join
  unbind part * * www_part
  unbind sign * * www_sign
  unbind topc * * www_topc
  unbind mode * * www_mode
  unbind kick * * www_kick
  unbind nick * * www_nick
  www_htmlheader
  global www_file
  set fh [open $www_file a]
  puts $fh "<h2>LIVE WWW disabled.</h2>"
  close $fh
  putlog "--> Stopping wwwlive" 
 }
 if {$mode == "help"} {
  putlog "--> wwwlive help ... the commands :"
  putlog " .wwwlive on - turns on the gateway to the www"
  putlog " .wwwlive off - turns if off"
  putlog " .wwwlive help - shows this help"
 }
} 



proc www_pubm {nick uhost hand chan args} {
 global www_channel
 if { $chan == $www_channel} {
 www_newfile
 set text [lindex $args 0]
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "\&lt;$nick> $text<br>"
 close $fh
 incr www_lines 
}
}

proc www_join {nick host hand chan} {
 global www_channel
 if { $chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "*** $nick ($host) has joined $chan<br>"
 close $fh
 incr www_lines
}
}

proc www_part {nick host hand chan} {
 global www_channel
 if {$chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "*** $nick ($host) has left $chan<br>"
 close $fh
 incr www_lines
}
}

proc www_sign {nick host hand chan reason} {
 global www_channel
 if {$chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set text [lindex $reason 0]
 set fh [open $www_file a]
 puts $fh "*** $nick ($host) has quit irc ($text)<br>"
 close $fh
 incr www_lines
}
}

proc www_topc {nick host hand chan topc} {
 global www_channel
 if {$chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "*** roots has changed the topic on $chan to $topc<br>"
 close $fh
 incr www_lines
}
}

proc www_mode {nick host hand chan mc} {
 global www_channel
 if {$chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "*** Mode change $mc on $chan by $nick<br>"
 close $fh
 incr www_lines 
}
}

proc www_kick {nick host hand chan kn kr} {
 global www_channel
 if {$chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "*** $kn has been kicked off $chan by $nick ($kr)<br>"
 close $fh
 incr www_lines
}
}

proc www_nick {nick host hand chan newnick} {
 global www_channel
 if {$chan == $www_channel} {
 www_newfile
 global www_lines www_file
 set fh [open $www_file a]
 puts $fh "*** $nick is now known as $newnick<br>"
 close $fh
 incr www_lines
}
}


proc www_newfile {} {
 global www_lines
 if {$www_lines >25} {
  www_htmlheader
  set www_lines 0
 }
}

proc www_htmlheader {} {
 global www_file 
 global www_title www_bgcolor www_fgcolor
 set fh [open $www_file w]
 puts $fh "<html><head><title>$www_title</title>"
 puts $fh "<meta http-equiv=refresh content=5; url=log.html></head>"
 puts $fh "<body bgcolor=\"$www_bgcolor\" text=\"$www_fgcolor\"><tt>"
 close $fh
} 

 


bind dcc n wwwlive init


#(c) roots 1998 - http://roots.home.pages.de
