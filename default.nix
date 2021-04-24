{ callPackage,
  pkg-config,
  openssl,
  fetchFromGitHub,
  dockerTools,
  rev,
  sha256,
  sources ? import ./nix/sources.nix,
  naersk ? callPackage sources.naersk {},
}: rec {
  trup-rs = naersk.buildPackage rec {
    name = "trup-rs";
    version = "master";
    src = fetchFromGitHub {
      owner = "unixporn";
      repo = name;
      inherit rev sha256;
    };
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];
  };

  image = dockerTools.buildImage {
    name = "trup-rs";
    tag = rev;
    config = {
      Cmd = [ "${trup-rs}/bin/trup-rs" ];
    };
  };
}
