{
  # Personal desktop computer
  "coffee" = {
    hostname = "coffee";
    os = "nixos";
    nixosConfig = import ./configs/coffee/nixos;

    users = {
      "lili" = {
        uid = 1000;
        homeConfig = import ./configs/coffee/home.nix;
      };
    };

    ip.local = "192.168.0.88";

    ssh.user = "lili";

    syncthing.id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";
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

    ip.local = "192.168.0.173";

    ssh.user = "lili";

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

    ssh.user = "cake";

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
    };
  };
}
