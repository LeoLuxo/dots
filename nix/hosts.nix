{ lib, ... }:
rec {
  # Personal desktop computer
  "coffee" = {
    hostname = "coffee";
    nixosConfig = import ./configs/coffee;
    nixpkgs = "nixpkgs-stable";

    # TODO: change username
    user = "lili";
    users = {
      "lili" = {
        description = "Chloé";
        uid = 1000;

        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmKoOObf4uFjChrVj7UNEiHU5uxhNNY+rxSLoZvDy+t lili@coffee"
        ];

        openssh.authorizedKeys.keys = lib.flatten [ pancake.users.${pancake.user}.publicKeys ];

        picture = ./configs/coffee/pic.png;
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
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Surface Pro 7 laptop
  "pancake" = {
    hostname = "pancake";
    nixosConfig = import ./configs/pancake;
    nixpkgs = "nixpkgs-25-11";

    user = "lili";
    users = {
      "lili" = {
        description = "Chloé";
        uid = 1000;

        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuGccJyHZWCVDChXj3UUxTFLfU8fCM+vUYViYF+o6JF lili@pancake"
        ];

        openssh.authorizedKeys.keys = lib.flatten [ coffee.users.${coffee.user}.publicKeys ];

        picture = ./configs/pancake/pic.png;
      };
    };

    ip.local = "192.168.0.173";

    ssh = {
      user = "lili"; # Default user from above
      hostKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVxCq24Uq5HwnAxFiQHDCNoSusUtoTI/ndMzbXTVDWe host@pancake"
      ];
    };

    syncthing.id = "DS5FS25-BYJYFF2-TKBNJ4S-6RHZTEK-F4QS4EM-BNOPAPU-ULRHUA7-ORVTNA7";

    dots = "/etc/nixos/dots";
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Raspberry Pi Zero
  "strobery" = {
    hostname = "strobery";

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
  "luna" = {
    ip.local = "192.168.0.154";

    syncthing.id = "YNXUKWI-S3D57O7-4P347QV-7NYE4ZK-4F7UTMU-PN7DXAX-PVLNHS6-AZQWJAV";
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # VPS
  "wasabi" = {
    ssh = {
      user = "admin";
      hostname = "wasabi";

      hostKeys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIvfBbik4ta4QPYgIhzuLSoY7HWbrJ58dbD05Z0edHVXhoE+khDu5HZ9zaUo1S1eMFsoYPdUjuG32MRUdwgib3M= host@wasabi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhUeeTSzlNPa4YPjEMGXX6FEUT7cIbBdu54GFRJ+2yj host@wasabi"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCOkkFraY34F5FdXfspy6q2+Vyq5+7XWAF9oLAXusQV7MzS5SK4tEBTcv1mnROS4gjwwaLSm3aFkcSZG4gnGwqw6SIbebjbj9+RVGPDDXmv3UjFamkPv1qQdBNZfpwTXZK2yEf+bQNyS3cw7wtXoc/mouc2QuyY7XlT56fLOMaGm7ufAsvyp4NFJ+GdLEfA8Vfdt4Y8Ahxb18AWywd3fu6FyRP0kpFXBiLkA1ux0RsrDzikQsfjufc480JODvWMC88KkbWqyutJ9pd7pcPLwoSb7/0gGcN5Ysx37VH1JqYngqgtBcPSEiUKD2N0r4txju3sHwlA1HWWA1MEQxYkAv29eBVevyxK6K2dya2HHhLHG3PwuDZicnqY0j+49w4xIGypPooHHKeaeNpJGafbUq93InnD5SxOzvjPda1fyFleMcSndWH0U+8u7ek5QH0JkHPS5mKQXdTHy/5GoleYzKzzAlhIbjyZn7W8YuWf0RG3cyhV8YUKImOsicb4eaU9C+s= host@wasabi"
      ];
    };
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
