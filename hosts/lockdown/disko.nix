{
  disko.devices = {
    disk = {
      sd = {
        device = "/dev/mmcblk0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "100%";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
          };
        };
      };
      nvme = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}

