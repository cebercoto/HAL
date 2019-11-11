#!/bin/bash
i=${1}
CURRENTUSER=${2}
DATANAME=${3}
INSTRUMENT=${4}
USEREMAIL=`grep ${CURRENTUSER} /var/www/accounts.txt | awk '{ print $2 }'`
ADMINEMAIL=${5}
GROUPEMAIL=${6}
SERVERNAME=${7}
cd ${i}
bcl2fastq_2.19
if [ `echo ${DATANAME} | wc -c ` != 30 ]; then
    DATANAME=`echo ${DATANAME} | sed -e "s/_${CURRENTUSER}//"`
fi
mkdir /data/ngsdata/${INSTRUMENT}/Temp/${DATANAME}_${CURRENTUSER}
cp Data/Intensities/BaseCalls/${CURRENTUSER}/*.gz /data/ngsdata/${INSTRUMENT}/Temp/${DATANAME}_${CURRENTUSER}/
rm -r Data/Intensities/BaseCalls/${CURRENTUSER}/*.gz
rm Data/Intensities/BaseCalls/*.gz
cd /data/ngsdata/${INSTRUMENT}/Temp/
tar -zcvf ${DATANAME}_${CURRENTUSER}.tar.gz ${DATANAME}_${CURRENTUSER}
md5sum ${DATANAME}_${CURRENTUSER}.tar.gz > ${DATANAME}_${CURRENTUSER}.tar.gz.md5
rm -r ${DATANAME}_${CURRENTUSER}
ln -s `pwd`/${DATANAME}_${CURRENTUSER}.tar.gz /var/www/html/${CURRENTUSER}/${DATANAME}_${CURRENTUSER}.tar.gz
ln -s `pwd`/${DATANAME}_${CURRENTUSER}.tar.gz.md5 /var/www/html/${CURRENTUSER}/${DATANAME}_${CURRENTUSER}.tar.gz.md5
if [ ${SERVERNAME} = 'sunstrider' ]; then
    SERVERNAME=sunstrider.medgen
fi
{
    echo "Subject: ${DATANAME}"
    echo "To: ${USEREMAIL},${ADMINEMAIL}"
    echo "Dear SMCL user,"
    echo ""
    echo "Please follow the links below using your credentials to your new ${INSTRUMENT} data."
    echo ""
    echo "http://${SERVERNAME}.medschl.cam.ac.uk/${CURRENTUSER}/${DATANAME}_${CURRENTUSER}.tar.gz"
    echo "http://${SERVERNAME}.medschl.cam.ac.uk/${CURRENTUSER}/${DATANAME}_${CURRENTUSER}.tar.gz.md5"
    echo ""
    echo "Kind regards."
    #signature
} | sendmail ${USEREMAIL},${ADMINEMAIL}
cd /data/ngsdata/${INSTRUMENT}
if [ -e ${DATANAME}_${CURRENTUSER} ]; then
    tar -zcvf ${DATANAME}_${CURRENTUSER}.tar.gz ${DATANAME}_${CURRENTUSER}
elif [ -e ${DATANAME} ]; then
    tar -zcvf ${DATANAME}_${CURRENTUSER}.tar.gz ${DATANAME}
fi
md5sum ${DATANAME}_${CURRENTUSER}.tar.gz > ${DATANAME}_${CURRENTUSER}.tar.gz.md5
cp ${i}/SampleSheet.csv ${DATANAME}_${CURRENTUSER}.csv
{
    echo "Subject: ${DATANAME} ready to delete"
    echo "To: ${ADMINEMAIL}"
    echo "${INSTRUMENT} run ${DATANAME} has been processed and sent, the original folder has been compressed and is ready to delete"
} | sendmail ${ADMINEMAIL}
