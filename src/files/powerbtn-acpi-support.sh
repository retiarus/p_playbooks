if [ -x /etc/acpi/powerbtn.sh ] ; then
  # Compatibility with old config script from acpid package
  /etc/acpi/powerbtn.sh
elif [ -x /etc/acpi/powerbtn.sh.dpkg-bak ] ; then
  # Compatibility with old config script from acpid package
  # which is still around because it was changed by the admin
  /etc/acpi/powerbtn.sh.dpkg-bak
else
  # Normal handling.
  systemctl hybrid-sleep
fi
