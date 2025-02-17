{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    bandit = buildMix rec {
      name = "bandit";
      version = "1.6.5";

      src = fetchHex {
        pkg = "bandit";
        version = "${version}";
        sha256 = "b6b91f630699c8b41f3f0184bd4f60b281e19a336ad9dc1a0da90637b6688332";
      };

      beamDeps = [ hpax plug telemetry thousand_island websock ];
    };

    bcrypt_elixir = buildMix rec {
      name = "bcrypt_elixir";
      version = "3.2.0";

      src = fetchHex {
        pkg = "bcrypt_elixir";
        version = "${version}";
        sha256 = "563e92a6c77d667b19c5f4ba17ab6d440a085696bdf4c68b9b0f5b30bc5422b8";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.11";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "e03990b4db988df56262852f20de0f659871c35154691427a5047f4967a16a62";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.12.0";

      src = fetchHex {
        pkg = "certifi";
        version = "${version}";
        sha256 = "ee68d85df22e554040cdb4be100f33873ac6051387baf6a8f6ce82272340ff1c";
      };

      beamDeps = [];
    };

    comeonin = buildMix rec {
      name = "comeonin";
      version = "5.5.0";

      src = fetchHex {
        pkg = "comeonin";
        version = "${version}";
        sha256 = "6287fc3ba0aad34883cbe3f7949fc1d1e738e5ccdce77165bc99490aa69f47fb";
      };

      beamDeps = [];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.7.0";

      src = fetchHex {
        pkg = "db_connection";
        version = "${version}";
        sha256 = "dcf08f31b2701f857dfc787fbad78223d61a32204f217f15e881dd93e4bdd3ff";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.3.0";

      src = fetchHex {
        pkg = "decimal";
        version = "${version}";
        sha256 = "a4d66355cb29cb47c3cf30e71329e58361cfcb37c34235ef3bf1d7bf3773aeac";
      };

      beamDeps = [];
    };

    dns_cluster = buildMix rec {
      name = "dns_cluster";
      version = "0.1.3";

      src = fetchHex {
        pkg = "dns_cluster";
        version = "${version}";
        sha256 = "46cb7c4a1b3e52c7ad4cbe33ca5079fbde4840dedeafca2baf77996c2da1bc33";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.12.5";

      src = fetchHex {
        pkg = "ecto";
        version = "${version}";
        sha256 = "6eb18e80bef8bb57e17f5a7f068a1719fbda384d40fc37acb8eb8aeca493b6ea";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.12.1";

      src = fetchHex {
        pkg = "ecto_sql";
        version = "${version}";
        sha256 = "aff5b958a899762c5f09028c847569f7dfb9cc9d63bdb8133bff8a5546de6bf5";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.9.0";

      src = fetchHex {
        pkg = "elixir_make";
        version = "${version}";
        sha256 = "db23d4fd8b757462ad02f8aa73431a426fe6671c80b200d9710caf3d1dd0ffdb";
      };

      beamDeps = [];
    };

    esbuild = buildMix rec {
      name = "esbuild";
      version = "0.8.2";

      src = fetchHex {
        pkg = "esbuild";
        version = "${version}";
        sha256 = "558a8a08ed78eb820efbfda1de196569d8bfa9b51e8371a1934fbb31345feda7";
      };

      beamDeps = [ castore jason ];
    };

    ex_aws = buildMix rec {
      name = "ex_aws";
      version = "2.1.9";

      src = fetchHex {
        pkg = "ex_aws";
        version = "${version}";
        sha256 = "3e6c776703c9076001fbe1f7c049535f042cb2afa0d2cbd3b47cbc4e92ac0d10";
      };

      beamDeps = [ hackney jason sweet_xml ];
    };

    ex_aws_s3 = buildMix rec {
      name = "ex_aws_s3";
      version = "2.5.6";

      src = fetchHex {
        pkg = "ex_aws_s3";
        version = "${version}";
        sha256 = "9874e12847e469ca2f13a5689be04e546c16f63caf6380870b7f25bf7cb98875";
      };

      beamDeps = [ ex_aws sweet_xml ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "1.1.0";

      src = fetchHex {
        pkg = "expo";
        version = "${version}";
        sha256 = "fbadf93f4700fb44c331362177bdca9eeb8097e8b0ef525c9cc501cb9917c960";
      };

      beamDeps = [];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "1.1.0";

      src = fetchHex {
        pkg = "file_system";
        version = "${version}";
        sha256 = "bfcf81244f416871f2a2e15c1b515287faa5db9c6bcf290222206d120b3d43f6";
      };

      beamDeps = [];
    };

    finch = buildMix rec {
      name = "finch";
      version = "0.19.0";

      src = fetchHex {
        pkg = "finch";
        version = "${version}";
        sha256 = "fc5324ce209125d1e2fa0fcd2634601c52a787aff1cd33ee833664a5af4ea2b6";
      };

      beamDeps = [ mime mint nimble_options nimble_pool telemetry ];
    };

    floki = buildMix rec {
      name = "floki";
      version = "0.37.0";

      src = fetchHex {
        pkg = "floki";
        version = "${version}";
        sha256 = "516a0c15a69f78c47dc8e0b9b3724b29608aa6619379f91b1ffa47109b5d0dd3";
      };

      beamDeps = [];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.26.2";

      src = fetchHex {
        pkg = "gettext";
        version = "${version}";
        sha256 = "aa978504bcf76511efdc22d580ba08e2279caab1066b76bb9aa81c4a1e0a32a5";
      };

      beamDeps = [ expo ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.20.1";

      src = fetchHex {
        pkg = "hackney";
        version = "${version}";
        sha256 = "fe9094e5f1a2a2c0a7d10918fee36bfec0ec2a979994cff8cfe8058cd9af38e3";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hpax = buildMix rec {
      name = "hpax";
      version = "1.0.2";

      src = fetchHex {
        pkg = "hpax";
        version = "${version}";
        sha256 = "2f09b4c1074e0abd846747329eaa26d535be0eb3d189fa69d812bfb8bfefd32f";
      };

      beamDeps = [];
    };

    idna = buildRebar3 rec {
      name = "idna";
      version = "6.1.1";

      src = fetchHex {
        pkg = "idna";
        version = "${version}";
        sha256 = "92376eb7894412ed19ac475e4a86f7b413c1b9fbb5bd16dccd57934157944cea";
      };

      beamDeps = [ unicode_util_compat ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.4";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
      };

      beamDeps = [ decimal ];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "metrics";
        version = "${version}";
        sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.6";

      src = fetchHex {
        pkg = "mime";
        version = "${version}";
        sha256 = "c9945363a6b26d747389aac3643f8e0e09d30499a138ad64fe8fd1d13d9b153e";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.3.0";

      src = fetchHex {
        pkg = "mimerl";
        version = "${version}";
        sha256 = "a1e15a50d1887217de95f0b9b0793e32853f7c258a5cd227650889b38839fe9d";
      };

      beamDeps = [];
    };

    mint = buildMix rec {
      name = "mint";
      version = "1.6.2";

      src = fetchHex {
        pkg = "mint";
        version = "${version}";
        sha256 = "5ee441dffc1892f1ae59127f74afe8fd82fda6587794278d924e4d90ea3d63f9";
      };

      beamDeps = [ castore hpax ];
    };

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.1.1";

      src = fetchHex {
        pkg = "nimble_options";
        version = "${version}";
        sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
      };

      beamDeps = [];
    };

    nimble_pool = buildMix rec {
      name = "nimble_pool";
      version = "1.1.0";

      src = fetchHex {
        pkg = "nimble_pool";
        version = "${version}";
        sha256 = "af2e4e6b34197db81f7aad230c1118eac993acc0dae6bc83bac0126d4ae0813a";
      };

      beamDeps = [];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.4.1";

      src = fetchHex {
        pkg = "parse_trans";
        version = "${version}";
        sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.18";

      src = fetchHex {
        pkg = "phoenix";
        version = "${version}";
        sha256 = "1797fcc82108442a66f2c77a643a62980f342bfeb63d6c9a515ab8294870004e";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template plug plug_crypto telemetry websock_adapter ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.6.3";

      src = fetchHex {
        pkg = "phoenix_ecto";
        version = "${version}";
        sha256 = "909502956916a657a197f94cc1206d9a65247538de8a5e186f7537c895d95764";
      };

      beamDeps = [ ecto phoenix_html plug postgrex ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "4.2.0";

      src = fetchHex {
        pkg = "phoenix_html";
        version = "${version}";
        sha256 = "9713b3f238d07043583a94296cc4bbdceacd3b3a6c74667f4df13971e7866ec8";
      };

      beamDeps = [];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.8.6";

      src = fetchHex {
        pkg = "phoenix_live_dashboard";
        version = "${version}";
        sha256 = "1681ab813ec26ca6915beb3414aa138f298e17721dc6a2bde9e6eb8a62360ff6";
      };

      beamDeps = [ ecto mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.5.3";

      src = fetchHex {
        pkg = "phoenix_live_reload";
        version = "${version}";
        sha256 = "b4ec9cd73cb01ff1bd1cac92e045d13e7030330b74164297d1aee3907b54803c";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "1.0.2";

      src = fetchHex {
        pkg = "phoenix_live_view";
        version = "${version}";
        sha256 = "8a40265b0cd7d3a35f136dfa3cc048e3b198fc3718763411a78c323a44ebebee";
      };

      beamDeps = [ floki jason phoenix phoenix_html phoenix_template plug telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "phoenix_pubsub";
        version = "${version}";
        sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
      };

      beamDeps = [];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.4";

      src = fetchHex {
        pkg = "phoenix_template";
        version = "${version}";
        sha256 = "2c0c81f0e5c6753faf5cca2f229c9709919aba34fab866d3bc05060c9c444206";
      };

      beamDeps = [ phoenix_html ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.16.1";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "a13ff6b9006b03d7e33874945b2755253841b238c34071ed85b0e86057f8cddc";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.1.0";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "131216a4b030b8f8ce0f26038bc4421ae60e4bb95c5cf5395e1421437824c4fa";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.19.3";

      src = fetchHex {
        pkg = "postgrex";
        version = "${version}";
        sha256 = "d31c28053655b78f47f948c85bb1cf86a9c1f8ead346ba1aa0d0df017fa05b61";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.7";

      src = fetchHex {
        pkg = "ssl_verify_fun";
        version = "${version}";
        sha256 = "fe4c190e8f37401d30167c8c405eda19469f34577987c76dde613e838bbc67f8";
      };

      beamDeps = [];
    };

    sweet_xml = buildMix rec {
      name = "sweet_xml";
      version = "0.7.5";

      src = fetchHex {
        pkg = "sweet_xml";
        version = "${version}";
        sha256 = "193b28a9b12891cae351d81a0cead165ffe67df1b73fe5866d10629f4faefb12";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.17.6";

      src = fetchHex {
        pkg = "swoosh";
        version = "${version}";
        sha256 = "9798f3e72165f40c950f6762c06dab68afcdcf616138fc4a07965c09c250e1e2";
      };

      beamDeps = [ bandit ex_aws finch hackney jason mime plug telemetry ];
    };

    tailwind = buildMix rec {
      name = "tailwind";
      version = "0.2.4";

      src = fetchHex {
        pkg = "tailwind";
        version = "${version}";
        sha256 = "c6e4a82b8727bab593700c998a4d98cf3d8025678bfde059aed71d0000c3e463";
      };

      beamDeps = [ castore ];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.3.0";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "7015fc8919dbe63764f4b4b87a95b7c0996bd539e0d499be6ec9d7f3875b79e6";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "1.0.0";

      src = fetchHex {
        pkg = "telemetry_metrics";
        version = "${version}";
        sha256 = "f23713b3847286a534e005126d4c959ebcca68ae9582118ce436b521d1d47d5d";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.1.0";

      src = fetchHex {
        pkg = "telemetry_poller";
        version = "${version}";
        sha256 = "9eb9d9cbfd81cbd7cdd24682f8711b6e2b691289a0de6826e58452f28c103c8f";
      };

      beamDeps = [ telemetry ];
    };

    thousand_island = buildMix rec {
      name = "thousand_island";
      version = "1.3.9";

      src = fetchHex {
        pkg = "thousand_island";
        version = "${version}";
        sha256 = "25ab4c07badadf7f87adb4ab414e0ed374e5f19e72503aa85132caa25776e54f";
      };

      beamDeps = [ telemetry ];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.7.0";

      src = fetchHex {
        pkg = "unicode_util_compat";
        version = "${version}";
        sha256 = "25eee6d67df61960cf6a794239566599b09e17e668d3700247bc498638152521";
      };

      beamDeps = [];
    };

    waffle = buildMix rec {
      name = "waffle";
      version = "1.1.9";

      src = fetchHex {
        pkg = "waffle";
        version = "${version}";
        sha256 = "307c63cfdfb4624e7c423868a128ccfcb0e5291ae73a9deecb3a10b7a3eb277c";
      };

      beamDeps = [ ex_aws ex_aws_s3 hackney sweet_xml ];
    };

    waffle_ecto = buildMix rec {
      name = "waffle_ecto";
      version = "0.0.12";

      src = fetchHex {
        pkg = "waffle_ecto";
        version = "${version}";
        sha256 = "585fe6371057066d2e8e3383ddd7a2437ff0668caf3f4cbf5a041e0de9837168";
      };

      beamDeps = [ ecto waffle ];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.3";

      src = fetchHex {
        pkg = "websock";
        version = "${version}";
        sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.8";

      src = fetchHex {
        pkg = "websock_adapter";
        version = "${version}";
        sha256 = "315b9a1865552212b5f35140ad194e67ce31af45bcee443d4ecb96b5fd3f3782";
      };

      beamDeps = [ bandit plug websock ];
    };
  };
in self

