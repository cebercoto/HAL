#!/bin/bash
i=${1}
CURRENTUSER=${2}
DATANAME=${3}
USEREMAIL=`grep ${CURRENTUSER} /var/www/accounts.txt | awk '{ print $2 }'`
tar -zcvf ${i}.tar.gz ${i}
md5sum ${i}.tar.gz > ${i}.tar.gz.md5
rm -r ${i}
ln -s ${i}.tar.gz /var/www/html/${CURRENTUSER}/${DATANAME}
ln -s ${i}.tar.gz.md5 /var/www/html/${CURRENTUSER}/${DATANAME}
{
    echo "Subject: ${i}"
    echo "To: jem220@medschl.cam.ac.uk,sa263@medschl.cam.ac.uk,${USEREMAIL}"
    echo "Dear CMDL user,"
    echo ""
    echo "Please follow the links below using your credentials to your new data."
    echo ""
    echo "http://thor.medschl.cam.ac.uk/${CURRENTUSER}/${DATANAME}.tar.gz"
    echo "http://thor.medschl.cam.ac.uk/${CURRENTUSER}/${DATANAME}.tar.gz.md5"
    echo ""
    echo "Kind regards."
    #signature
} | sendmail jem220@medschl.cam.ac.uk,sa263@medschl.cam.ac.uk,${USEREMAIL}
