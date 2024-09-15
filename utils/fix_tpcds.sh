#! /bin/bash

# Description:
#   Script that fixes all issues regarding the installation of the TPC-DS benchmark suite.
#   The documented issues that fixes are the following:
#       - Add the missing _END substitution
#       - Be able to generate all 99 queries with ascending numbering name.
#       - Be able to also add variation numbers in case multiple iterations of the same query type is #         needed.
#   
#   Note: Add the coresponding function you wish to run to the end of the script. 

SCALE="8"
SEED="0121130900"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASEDIR="$SCRIPT_DIR/../.."
TEMPLATEDIR="$BASEDIR/DSGen-software-code-3.2.0rc1/query_templates"
TOOLSDIR="$BASEDIR/DSGen-software-code-3.2.0rc1/tools"
OUTDIR="$BASEDIR/queries"

function fix_query_template
{
    # add following line to beginning of each query template file
    #define _END = "";
    for file in $(find $TEMPLATEDIR -name "query*.tpl")
    do
        echo Processing $file
        # Remove line if exists
        sed -i '/^define _END = "";/d' $file
        # Add line to beginning
        sed -i '1s/^/define _END = "";\n/' $file
    done
} # end function fix_query_template

function gen_query
{
    # Generate queries from template for given scale
    echo $SCRIPT_DIR
    echo $BASEDIR
    cd $TOOLSDIR
    pwd
    for fullfile in `ls $TEMPLATEDIR/query*.tpl`
    do
        echo $fullfile
        filename=$(basename -- "$fullfile")
        filename="${filename%.*}"
        i=`echo "$filename"|cut -c 6-`

        j=$(printf "%03d" $i)
        # filename=query9 i=9 j=009
        #echo $filename $i $j

        \rm -f $OUTDIR/query_0.sql
        #cmd="./dsqgen -directory ../query_templates -template query${i}.tpl -distributions $TOOLSDIR/tpcds.idx -verbose y -qualify y -scale $SCALE -dialect netezza -output_dir $OUTDIR -rngseed $SEED"
        cmd="./dsqgen -directory ../query_templates -template query${i}.tpl -verbose y -scale $SCALE -dialect netezza -output_dir $OUTDIR -rngseed $SEED"
        echo "$cmd"; eval "$cmd"

        cmd="mv $MV_OPTION $OUTDIR/query_0.sql $OUTDIR/query${j}.sql"
        echo "$cmd"; eval "$cmd"
        echo ""
    done
} # end function gen_query

function gen_query_variant
{
    # Generate query variants from template for given scale
    pushd $TOOLSDIR
    #\cp $TEMPLATEDIR/netezza.tpl $TEMPLATEVARIANTDIR/netezza.tpl
    for fullfile in `ls $TEMPLATEVARIANTDIR/query*.tpl`
    do
        echo $fullfile
        filename=$(basename -- "$fullfile")
        filename="${filename%.*}"
        lastchar=`echo "${filename: -1}"`
        i=`echo "$filename"|rev|cut -c 2-|rev|cut -c 6-`
        j=$(printf "%03d" $i)
        # filename=query10a i=10 j=010 lastchar=a
        #echo $filename $i $j $lastchar

        cmd="./dsqgen -directory ../query_variants -template query${i}${lastchar}.tpl -verbose y -scale $SCALE -dialect netezza -output_dir $OUTDIR -rngseed $SEED"
        echo "$cmd"; eval "$cmd"

        cmd="mv $MV_OPTION $OUTDIR/query_0.sql $OUTDIR/query${j}${lastchar}.sql"
        echo "$cmd"; eval "$cmd"
        echo ""
    done
} # end function gen_query_variant



#fix_query_template
gen_query