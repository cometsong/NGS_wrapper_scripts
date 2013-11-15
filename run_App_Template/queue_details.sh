#!/bin/bash -
#===============================================================================
#          FILE: queue_details.sh
#   DESCRIPTION: file to be sourced by run_APP.sh for host-specific qsub data
#        AUTHOR: B. Leopold (cometsong), bleopoldNOSPAM@uni-muenster.de
#       CREATED: 2013-08-20 12:26:12+0200
#       REVISED: 2013-09-23 12:20:38+0200 Create associative array of host/queue settings
#       REVISED: 2013-09-24 09:29:23+0200 Convert to 'normal' array method, as one host is bash <v4
#===============================================================================
set -o allexport    # auto-export all vars


# for bash<v4, use only a "normal" array with vals separated with spaces
declare -a QUEUE_INFO
# HOST    queue_or_job_detail   info_like_queue_resources
QUEUE_INFO=( #{{{
    "DEFAULT user_group ${USER_GROUP:-'users'}"
    "DEFAULT default    nodes=1"
    "DEFAULT unknown    'That queue is not set up for use!'"
    #
    "NGS-Anal user_group seqgroups"
    "NGS-Anal default    walltime=48:00:00,nodes=1:ppn=4,mem=24GB"
    "NGS-Anal long       walltime=160:00:00,nodes=1:ppn=10,mem=48GB"
    #
    "palma001 user_group ${USER_GROUP:-'e0hy'}"
    "palma001 default    walltime=48:00:00,nodes=2:himem:ppn=12"
    "palma001 long       walltime=100:00:00,nodes=2:himem:ppn=12"
    "palma001 mescashort walltime=160:00:00,nodes=2:ppn=32"
    "palma001 mescalong  walltime=48:00:00,nodes=2:ppn=32"
) #}}}


# function: get_hostname_alnum_caps
# incoming: HOSTname (default: uname -n)
# return: alnum caps, without extra chars
function get_hostname_alnum_caps () { #{{{
    HOST=${1:-''}
    # check HOST, default "uname -n", capitalize value
    local XHOST=( $(echo ${HOST:-$(uname -n)} | tr '[a-z]' '[A-Z]') )
    # remove icky nonalphanumeric chars
    local REMOVE="-*/+.,:;_#'~!$%&=?"
    XHOST=${XHOST//[$REMOVE]/}
    # send it back
    echo $XHOST
} #}}}


# function: return_queue_info 
# incoming: hostname, queue name (default: "DEFAULT", "unknown")
# return: elems in QUEUE_INFO array that match
function return_queue_info () { #{{{
    local XHOST=${1:-'DEFAULT'}
    #local XHOST=$(get_hostname_alnum_caps $HOST)
    local QUEUE=${2:-'unknown'}

    for Q in "${QUEUE_INFO[@]}"; do
        Q=($Q)  # split each elem on spaces
        QHOST=${Q[0]}
        QNAME=${Q[1]}
        QINFO=${Q[@]:2} # all remaining elems

        if [ "${QHOST}" == "$XHOST" ] ; then
            if [ "${QNAME}" == "$QUEUE" ] ; then
                echo $QINFO # return resulting info
                exit $?
            fi
        fi
    done
} #}}}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ modeline! ~~~~~ #{{{
# vim: ft=sh fdm=marker:
#}}}
