# False positives of the CVE scan, reviewed 10.11.2026 (docs/vulnerability-review.md). The scan matches
# names and versions only. Remove an entry when the package goes away or the reason no longer holds.
[
  # Other products with the same name.
  "CVE-2026-40920" # ranger: Apache Ranger (fixed in 2.9.0), not the file manager
  "CVE-2026-42537"
  "CVE-2026-44416"
  "CVE-2026-55799"
  "CVE-2026-55814"
  "CVE-2026-65942"
  "CVE-2026-65948"
  "CVE-2022-26345" # openmp: Intel oneAPI, not LLVM/ROCm OpenMP

  # Version read wrongly: the installed version already contains the fix.
  "CVE-2025-30160" # redlib: fixed in 0.36.0, installed is a snapshot after it
  "CVE-2026-6507" # dnsmasq: fixed in 2.93test9, installed is the 2.93 release
  "CVE-2021-4048" # lapack: version read as "3", fixed in 3.10.1

  # Kernel: fixed in 4.x to 6.x, specific to Android/Ubuntu/RHEL kernels, or known design issues
  # without a fix that do not apply here (CVE-2019-14899: VPN tracking, handled by Mullvad).
  "CVE-2016-3699"
  "CVE-2017-6264"
  "CVE-2018-10902"
  "CVE-2018-14625"
  "CVE-2019-14899"
  "CVE-2020-16119"
  "CVE-2020-1749"
  "CVE-2020-27815"
  "CVE-2021-20194"
  "CVE-2021-3864"
  "CVE-2022-0400"
  "CVE-2022-1247"
  "CVE-2022-3636"
  "CVE-2023-3640"
  "CVE-2023-39179"
  "CVE-2023-39180"
  "CVE-2023-6535"
  "CVE-2023-6610"

  # Fixed years ago, the scan has no version range for them.
  "CVE-2016-10132" # mujs 2016/17
  "CVE-2016-10133"
  "CVE-2016-10141"
  "CVE-2016-7504"
  "CVE-2016-7506"
  "CVE-2016-7563"
  "CVE-2016-7564"
  "CVE-2016-9017"
  "CVE-2016-9108"
  "CVE-2016-9109"
  "CVE-2016-9136"
  "CVE-2016-9294"
  "CVE-2017-5627"
  "CVE-2017-5628"
  "CVE-2009-1840" # thunderbird: Thunderbird 3
  "CVE-2009-3980"
  "CVE-2009-3981"
  "CVE-2009-3982"
  "CVE-2014-8139" # unzip 6.0: patched by nixpkgs
  "CVE-2014-8140"
  "CVE-2014-8141"
  "CVE-2018-1000035"
  "CVE-2016-0749" # spice: fixed in 0.12 to 0.14
  "CVE-2016-2150"
  "CVE-2018-10893"
  "CVE-2014-9826" # imagemagick
  "CVE-2017-5506"
  "CVE-2011-2411" # samba: HP-UX only
  "CVE-2011-3618" # atop
  "CVE-2011-1763" # xen
  "CVE-2015-8981" # podofo
  "CVE-2022-2989" # podman
  "CVE-2021-30499" # libcaca: fixed in 0.99.beta20
  "CVE-2022-33065" # libsndfile: fixed in 1.2.2

  # Not applicable: distribution specific or disputed.
  "CVE-2008-3844" # openssh: manipulated Red Hat packages of 2008
  "CVE-2023-51767" # openssh: Rowhammer, disputed by OpenSSH
  "CVE-2018-6553" # cups: Debian's AppArmor profile
  "CVE-2019-1010022" # glibc: disputed by glibc
  "CVE-2019-1010023"
  "CVE-2023-1386" # qemu: 9p, disputed
  "CVE-2023-2680" # qemu: RHEL only
]
