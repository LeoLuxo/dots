{
  # Personal desktop computer
  "coffee" = {
    hostname = "coffee";
    os = "nixos";
    nixosConfig = import ./configs/coffee/nixos.nix;

    users = {
      "lili" = {
        uid = 1000;
        homeConfig = import ./configs/coffee/home.nix;

        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmKoOObf4uFjChrVj7UNEiHU5uxhNNY+rxSLoZvDy+t lili@coffee"
        ];
      };
    };

    ip.local = "192.168.0.88";

    ssh = {
      user = "lili";
      hostKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxk9qOGQi2ENzTE5+mC1pcJs29MC5pqQmYAUh/CjvXT host@coffee"
      ];
    };

    syncthing.id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";

    dots = "/etc/nixos/dots";
    dotsTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Surface Pro 7 laptop
  "pancake" = {
    hostname = "pancake";
    os = "nixos";
    nixosConfig = import ./configs/pancake/nixos.nix;

    users = {
      "lili" = {
        uid = 1000;
        homeConfig = import ./configs/pancake/home.nix;

        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuGccJyHZWCVDChXj3UUxTFLfU8fCM+vUYViYF+o6JF lili@pancake"
        ];
      };
    };

    ip.local = "192.168.0.173";

    ssh = {
      user = "lili";
      hostKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVxCq24Uq5HwnAxFiQHDCNoSusUtoTI/ndMzbXTVDWe host@pancake"
      ];
    };

    syncthing.id = "DS5FS25-BYJYFF2-TKBNJ4S-6RHZTEK-F4QS4EM-BNOPAPU-ULRHUA7-ORVTNA7";
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Raspberry Pi Zero
  "strobery" = {
    hostname = "strobery";
    os = "raspbian";

    ip.local = "192.168.0.37";

    ssh = {
      user = "cake";
      hostKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM4wZkAbrZ0bDiYeIk6P/C49Z1F3/d5DV4y2i7/wu+z host@strobery"
      ];
    };

    syncthing.id = "BH4QRX3-AXCRBBK-32KWW2A-33XYEMB-CKDONYH-4KLE4QA-NXE5LIX-QB4Q5AN";
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Phone
  "celestia" = {
    os = "android";

    ip.local = "192.168.0.142";

    syncthing.id = "2DPZ3IR-YH4YGS3-SGEZMRY-PMJNDZ4-3PBAE4D-V3IT5CA-4R4KVB5-MFH2WAL";
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Hetzner storage box
  "chestnut" = {
    ssh = {
      user = "u361673-sub2";
      hostname = "u361673.your-storagebox.de";
      port = 23;
      hostKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5EB5p/5Hp3hGW1oHok+PIOH9Pbn7cnUiGmUEBrCVjnAw+HrKyN8bYVV0dIGllswYXwkG/+bgiBlE6IVIBAq+JwVWu1Sss3KarHY3OvFJUXZoZyRRg/Gc/+LRCE7lyKpwWQ70dbelGRyyJFH36eNv6ySXoUYtGkwlU5IVaHPApOxe4LHPZa/qhSRbPo2hwoh0orCtgejRebNtW5nlx00DNFgsvn8Svz2cIYLxsPVzKgUxs8Zxsxgn+Q/UvR7uq4AbAhyBMLxv7DjJ1pc7PJocuTno2Rw9uMZi1gkjbnmiOh6TTXIEWbnroyIhwc8555uto9melEUmWNQ+C+PwAK+MPw=="
      ];
    };
  };
}
