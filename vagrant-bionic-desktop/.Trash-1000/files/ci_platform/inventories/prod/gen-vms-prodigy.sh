
# echo "██████╗ ██████╗  ██████╗ ██████╗ ██╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗";
# echo "██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██║   ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║";
# echo "██████╔╝██████╔╝██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██╔██╗ ██║";
# echo "██╔═══╝ ██╔══██╗██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██║╚██╗██║";
# echo "██║     ██║  ██║╚██████╔╝██████╔╝╚██████╔╝╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║";
# echo "╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝  ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝";
# echo "                                                                                 ";



echo "██████╗ ██████╗ ███████╗";
echo "██╔══██╗██╔══██╗██╔════╝";
echo "██████╔╝██████╔╝█████╗  ";
echo "██╔═══╝ ██╔══██╗██╔══╝  ";
echo "██║     ██║  ██║███████╗";
echo "╚═╝     ╚═╝  ╚═╝╚══════╝";
echo "                        ";


# inst-ri0-ora121020
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4900 CI-0-4803 10.57.14.87 -scn=pipe -remove_vm -cpu=2 -db_ver=12 -legacy

# inst-ri0-ora122010
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4900 CI-0-4804 10.57.14.85 -scn=pipe -remove_vm -cpu=2 -db_ver=12.2 -legacy

# inst-ri0-ora193000
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4681 CI-0-4813 10.57.14.80 -scn=pipe -remove_vm -cpu=4 -db_ver=19c -allure_commandline -bin_tables -mem=16380

# pkg-ri0-ora19.3-db2
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4681 CI-0-4905 10.57.14.6 -scn=pipe -remove_vm -cpu=4 -db_ver=19c -allure_commandline -bin_tables -mem=16380 -db2

# pkg-ri0-ora122010 pkg-ri0-ora122010-db2 test-tools manual sonar
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4800 CI-0-4814 10.57.14.81 -scn=pipe -remove_vm -cpu=4 -db_ver=12.2 -db2 -bin_tables -mem=16380 -legacy

# ucs
# /home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4624 CI-0-4908 10.57.14.9 -scn=orig -remove_vm -db2 -db_ver=12.2 -mem=12288 -legacy

# winium_sikulix



echo "████████╗███████╗███████╗████████╗";
echo "╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝";
echo "   ██║   █████╗  ███████╗   ██║   ";
echo "   ██║   ██╔══╝  ╚════██║   ██║   ";
echo "   ██║   ███████╗███████║   ██║   ";
echo "   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ";
echo "                                  ";

# inst-ri0-ora121020
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4900 CI-0-4643 10.57.14.79 -scn=pipe -remove_vm -cpu=2 -db_ver=12 -legacy

# inst-ri0-ora122010
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4900 CI-0-4801 10.57.14.97 -scn=pipe -remove_vm -cpu=2 -db_ver=12.2 -legacy

# inst-ri0-ora193000
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4681 CI-0-4802 10.57.14.92 -scn=pipe -remove_vm -cpu=4 -db_ver=19c -allure_commandline -bin_tables -mem=16380

# pkg-ri0-ora19.3-db2
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4681 CI-0-4811 10.57.14.83 -scn=pipe -remove_vm -cpu=4 -db_ver=19c -allure_commandline -bin_tables -mem=16380 -db2

# pkg-ri0-ora122010 pkg-ri0-ora122010-db2 test-tools manual sonar
/home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4800 CI-0-4812 10.57.14.88 -scn=pipe -remove_vm -cpu=4 -db_ver=12.2 -db2 -bin_tables -mem=16380 -legacy

# ucs
# /home/vmadmin/vmhost/ri0_to_ci0/run.sh CI-0-4624 CI-0-4901 10.57.14.2 -scn=orig -remove_vm -db2 -db_ver=12.2 -mem=12288 -legacy

# winium_sikulix

