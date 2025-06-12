{

  # https://www.reddit.com/r/linux/comments/lhgx9/how_can_i_reduce_my_power_consumption/
  boot.kernelParams = [
    "usbcore.autosuspend=1"
    # "cpuidle.governor=powersave"
    # "mitigations=off"
  ];
  # Disabled because I used it infrequently, and because it slows down boot time with about 3 seconds.
  # Use `systemd-analyse` to get start timings of services
  powerManagement = {
    enable = true;
    powertop.enable = true;
    # scsiLinkPolicy = "med_power_with_dipm";
    # cpuFreqGovernor = "powersave";
  };

  hardware.intel-gpu-tools.enable = true;

  services.auto-cpufreq.enable = false;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  services.power-profiles-daemon.enable = false;

  # services.tlp.enable = true;

  services.thermald.enable = true;
  # # TODO: check out services.auto-cpufreq
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 60;
      STOP_CHARGE_THRESH_BAT0 = 80;

      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
    };
  };

}
