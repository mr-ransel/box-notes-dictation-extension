handleSymLink()
{
    if [ -h "$1" ]; then
        echo SymLnk: "$(cd "$(dirname "$query")" && pwd)/$(basename "$query")"
    fi
}

getFilePath()
{
    if [ -a "$1" ]; then
        path=$(readlink -f "$1" | head -1)
    fi
    if [ -d "$path" ]; then 
        path="$path"/
    fi
    echo "$path"
}

handleRegexQuery()
{
    result=$(echo "$dataset" | cut -d " " -f 2 | grep -i "$1")
    echo "Puppet Regex Query Result:"
    if [[ "$(echo "$result" | wc -l)" == 1  && -n "$result" ]]; then
        echo "Trace for" "$result"
        puppetTrace=$(tracePuppetObj "$result")
        echo "$puppetTrace"
        exit
    elif [[ -z "$result" ]]; then
        echo "No Results, Try another query."
        exit
    fi
    echo "$result"
    exit
}

getRpmName()
{
    echo "$(rpm -qf "$1" --queryformat '%{NAME}\n')"
}

getRpmVer()
{
    echo "$(rpm -qf "$1" --queryformat '%{VERSION}\n')"
}

getPuppetFileObj()
{
    echo "$(echo "$dataset" | grep " File."$1"\S*$" | cut -d " " -f 2)";
}

getPuppetPackageObj()
{
    echo "$(echo "$dataset" | grep " Package."$1".$" | cut -d " " -f 2)";
}

tracePuppetObj()
{
    currentNode="$1"

    while true; do
        echo Puppet: "$currentNode"
        currentNode=$(echo "$dataset" | grep -F " $currentNode" | cut -d " " -f 1)
        if [ -z "$currentNode" ]; then
            echo "Messge: Trace complete"
            break
        fi
    done
} 

betaTracePuppetObj()
{
    catalog=/var/lib/puppet/client_yaml/catalog/eng-access1001.ve.box.net.yaml
    refline=$(grep -n -F reference:\ "$1" $catalog)
    if [[ z "$refLine" ]]; then
        
    fi
    refLineNum=$(echo "$refline" | sed 's/\([0-9]*\).*/\1/')
    ref=$(echo "$refline" | sed 's/^.*reference: \(\S*\)\s*/\1/')
    tagStartOffset=$(tail -n +"$refLineNum" "$catalog" | grep -n -m 1 tags: | sed 's/\([0-9]*\).*/\1/')
    tagLineNum=$(($tagStartOffset + $refLineNum))
    stopLineOffset=$(tail -n +"$tagLineNum" "$catalog" | grep -n -m 1 "^\s*file:" | sed 's/\([0-9]*\).*/\1/')
    traceData=$(tail -n +"$tagLineNum" "$catalog" | head -"$stopLineOffset")
    trace=$(echo "$traceData" | grep -o \".*\" | sed -e 's/^\"/Puppet: Class\[/' -e s/\"$/\]/)
    node=$(echo "$traceData" | grep -A 1 node | sed -n -e 's/\s*- \(.*\)$/\1/p' | tail -1)
    echo Puppet: "$ref"
    echo "$trace"
    echo Puppet: Node["$node"]
    echo "Messge: Trace complete"
}  

dataset=$(grep '\->' /var/lib/puppet/state/graphs/resources.dot | sed -e 's/.*"\(.*\)" \-> "\(.*\)".*/\1 \2/')

query="$1"

echo Query.: "$query"
handleSymLink "$query"
fpath=$(getFilePath "$query")
if [[ -z "$fpath" ]]; then
    handleRegexQuery "$query"
fi
echo File..: "$fpath"
rpmName=$(getRpmName "$fpath")
if [[ $rpmName =~ .*owned\ by.* ]]; then
    puppetObj=$(getPuppetFileObj "$fpath")
    if [[ -z "$puppetObj" ]]; then
        echo "Messge: File not directly managed by puppet"
        exit;
    fi
else
    echo Pkg...: "$rpmName"
    puppetObj=$(getPuppetPackageObj "$rpmName")
    if [[ -z "$puppetObj" ]]; then
        echo PkgVer: "$(getRpmVer "$fpath")"
        exit;
    fi
fi

puppetTrace=$(tracePuppetObj "$puppetObj")
echo "$puppetTrace"
exit
